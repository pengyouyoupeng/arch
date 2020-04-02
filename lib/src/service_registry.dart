import 'package:arch/src/dialog.dart';
import 'package:arch/src/navigation.dart';
import 'package:arch/src/view.dart';
import 'package:arch/src/view_model.dart';
import 'package:flutter/widgets.dart';
import 'package:get_it/get_it.dart';

import 'service_locator.dart';

abstract class ServiceRegistry implements ServiceLocator {
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
    @required TViewModel Function() viewModel,
    String viewName,
  });

  /// Registers a dialog that can be shown using [DialogService.showCustomDialog]
  void registerDialog<TDialog extends DialogBase, TDialogModel extends DialogModelBase>({
    @required TDialog Function() dialog,
    @required TDialogModel Function() dialogModel,
    String dialogName,
  });
}

class ServiceRegistryImpl extends ServiceLocatorImpl implements ServiceRegistry {
  static final _i = GetIt.I..allowReassignment = true;

  void registerInternalDependencies() {
    _i
      ..registerLazySingleton<NavigationService>(() => NavigationServiceImpl())
      ..registerLazySingleton<DialogService>(() => DialogServiceImpl());
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
    @required TViewModel Function() viewModel,
    String viewName,
  }) {
    assert(view != null);
    assert(viewModel != null);
    _i.registerFactory<TView>(view, instanceName: viewName ?? TView.toString());
    _i..registerFactory<TViewModel>(viewModel);
  }

  @override
  void registerDialog<TDialog extends DialogBase<DialogModelBase>, TDialogModel extends DialogModelBase>({
    TDialog Function() dialog,
    TDialogModel Function() dialogModel,
    String dialogName,
  }) {
    assert(dialog != null);
    assert(dialogModel != null);
    _i.registerFactory<TDialog>(dialog, instanceName: dialogName ?? TDialog.toString());
    _i..registerFactory<TDialogModel>(dialogModel);
  }
}
