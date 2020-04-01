import 'package:arch/src/initializer.dart';
import 'package:arch/src/service_locator.dart';
import 'package:arch/src/service_registry.dart';
import 'package:flutter/widgets.dart';

abstract class Application extends StatelessWidget {
  Application(Initializer initializer, {Key key})
      : assert(initializer != null),
        super(key: key) {
    initializer.registerTypes(ServiceRegistryImpl()..registerInternalDependencies(serviceLocator));
    onInitialize();
  }

  static final ServiceLocator serviceLocator = ServiceLocatorImpl();

  void onInitialize() {}
}
