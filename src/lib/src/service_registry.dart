import 'package:arch/src/dialog.dart';
import 'package:arch/src/navigation.dart';
import 'package:arch/src/service_locator.dart';
import 'package:arch/src/view_model.dart';
import 'package:flutter/widgets.dart';
import 'package:get_it/get_it.dart';

abstract class ServiceRegistry {
  /// Registers an instance of [T] and returns it whenever [T] is being resolved.
  void registerSingleton<T>(T instance, {String name});

  /// Registers lazy factory of [T]. Calls [factory] only when [T] is being first
  /// resolved. The instance created by [factory] will be used in succeeding
  /// resolution of [T].
  void registerLazySingleton<T>(T Function() factory, {String name});

  /// Registers a factory of [T] and is called whenever [T] is being resolved.
  void registerFactory<T>(T Function() factory, {String name});

  /// Registers a view that can be navigated using [NavigationService].
  ///
  /// - [view] must not be null.
  /// - [viewModel] is optional.
  /// - [viewName] is optional. If `null`, uses [TView]'s name.
  void registerForNavigation<TView extends Widget, TViewModel extends ViewModelBase>({
    @required TView Function() view,
    TViewModel Function() viewModel,
    String viewName,
  });

  /// Resolves [T].
  ///
  /// If [T] is registered as a singleton, ensure that [T] is registered first before resolving it.
  T resolve<T>([String name]);
}

class ServiceRegistryImpl implements ServiceRegistry {
  static final _i = GetIt.I;

  void registerInternalDependencies(ServiceLocator serviceLocator) {
    _i
      ..registerLazySingleton<NavigationService>(() => NavigationServiceImpl())
      ..registerLazySingleton<DialogService>(() => DialogServiceImpl())
      ..registerSingleton<ServiceLocator>(serviceLocator);
  }

  @override
  void registerFactory<T>(T Function() factory, {String name}) => _i.registerFactory(factory, instanceName: name);

  @override
  void registerLazySingleton<T>(T Function() factory, {String name}) =>
      _i.registerLazySingleton(factory, instanceName: name);

  @override
  void registerSingleton<T>(T instance, {String name}) => _i.registerSingleton(instance, instanceName: name);

  @override
  void registerForNavigation<TView extends Widget, TViewModel extends ViewModelBase>({
    @required TView Function() view,
    TViewModel Function() viewModel,
    String viewName,
  }) {
    assert(view != null);
    _i.registerFactory<TView>(view, instanceName: viewName ?? TView.toString());

    if (viewModel != null) {
      _i..registerFactory<TViewModel>(viewModel);
    }
  }

  @override
  T resolve<T>([String name]) {
    if (name?.isNotEmpty ?? false == true) {
      return _i.get<Object>(instanceName: name) as T;
    } else {
      return _i.get<T>();
    }
  }
}
