import 'package:arch/arch.dart';
import 'package:arch_example/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

class TestInitializer implements Initializer {
  @override
  void registerTypes(ServiceRegistry registry) {
    registry
      ..registerForNavigation(
        view: () => HomeView(),
        viewModel: () => HomeViewModel(registry.resolve<NavigationService>()),
      )
      ..registerForNavigation(
        view: () => SecondView(),
        viewModel: () => SecondViewModel(
          registry.resolve<NavigationService>(),
          registry.resolve<DialogService>(),
        ),
      );
  }
}

class TestApp extends Application {
  TestApp(this.home) : super(TestInitializer());

  final Widget home;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: NavigationService.navigatorKey,
      theme: ThemeData(primarySwatch: Colors.blue),
      home: home,
    );
  }
}

void main() {
  group('HomeView', () {
    TestApp app;
    HomeView widget;

    setUp(() async {
      widget = HomeView();
      app = TestApp(widget);
    });

    testWidgets('Verify counter incremented', (tester) async {
      // Act
      await tester.pumpWidget(app);
      await tester.tap(find.byIcon(Icons.add));
      await tester.pumpAndSettle();

      // Assert
      expect(find.text('You have pushed the button this many times: 0'), findsNothing);
      expect(find.text('You have pushed the button this many times: 1'), findsOneWidget);
    });

    testWidgets('Navigates to SecondView', (tester) async {
      // Act
      await tester.pumpWidget(app);
      await tester.tap(find.text('Go to Second View'));
      await tester.pumpAndSettle();

      // Assert
      expect(find.byKey(Key('HomeView')), findsNothing);
      expect(find.byKey(Key('SecondView')), findsOneWidget);
    });
  });
}
