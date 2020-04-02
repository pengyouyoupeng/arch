import 'package:arch/src/initializer.dart';
import 'package:arch/src/service_locator.dart';
import 'package:arch/src/service_registry.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

abstract class Application extends StatelessWidget {
  Application(Initializer initializer, {Key key})
      : assert(initializer != null),
        super(key: key) {
    initializer.registerTypes(ServiceRegistryImpl()..registerInternalDependencies());
    onInitialize();
  }

  static final ServiceLocator serviceLocator = ServiceLocatorImpl();

  void onInitialize() {}
}

/// A widget that builds it self when the [ChangeNotifier] notifies changes.
class ChangeNotifierBuilder<T extends ChangeNotifier> extends StatelessWidget {
  ChangeNotifierBuilder({
    @required this.create,
    @required this.builder,
    this.child,
    Key key,
  }) : super(key: key);

  final T Function() create;

  final Widget Function(BuildContext, T, Widget) builder;

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<T>(
      create: (_) => create(),
      child: Consumer<T>(
        builder: (context, model, child) => builder(context, model, child),
        child: child,
      ),
    );
  }
}
