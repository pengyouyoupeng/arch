import 'package:get_it/get_it.dart';

/// Locates services registered,
abstract class ServiceLocator {
  /// Resolves an instance of [T].
  T resolve<T>([String name]);

  /// Determines whether an instance of [T] can be resolved.
  ///
  /// You can optionally pass [instance] to determine whether that object can be resolved.
  bool canResolve<T>({Object instance, String name});
}

class ServiceLocatorImpl implements ServiceLocator {
  static final _i = GetIt.I;

  @override
  T resolve<T>([String name]) {
    try {
      if (name?.isNotEmpty ?? false == true) {
        return _i.get<Object>(instanceName: name) as T;
      } else {
        return _i.get<T>();
      }
    } catch (e) {
      throw Error.safeToString('Failed to resolve <$T>. Did you registered it?');
    }
  }

  @override
  bool canResolve<T>({Object instance, String name}) {
    try {
      return _i.isRegistered<T>(instance: instance, instanceName: name);
    } catch (e) {
      return false;
    }
  }
}
