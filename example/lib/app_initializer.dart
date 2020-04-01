import 'package:arch/ioc.dart';
import 'package:arch/services.dart';
import 'package:arch_example/main.dart';

class AppInitializer implements Initializer {
  @override
  void registerTypes(ServiceRegistry registry) {
    registry
      ..registerForNavigation(
        view: () => SecondPage(),
        viewModel: () => SecondViewModel(registry.resolve<NavigationService>()),
        viewName: 'SecondPage',
      );
  }
}
