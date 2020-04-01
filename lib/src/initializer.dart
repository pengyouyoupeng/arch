import 'package:arch/src/service_registry.dart';

abstract class Initializer {
  void registerTypes(ServiceRegistry registry);
}
