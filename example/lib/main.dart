import 'package:arch/ioc.dart';
import 'package:arch/mvvm.dart';
import 'package:arch/services.dart';
import 'package:flutter/material.dart';

void main() => runApp(MyApp(AppInitializer()));

class AppInitializer implements Initializer {
  @override
  void registerTypes(ServiceRegistry registry) {
    registry
      ..registerForNavigation(
        view: () => HomeView(),
        viewModel: () => HomeViewModel(registry.resolve<NavigationService>()),
        viewName: 'HomeView',
      )
      ..registerForNavigation(
        view: () => SecondView(),
        viewModel: () => SecondViewModel(
          registry.resolve<NavigationService>(), // NavigationService and DialogService are automatically registered
          registry.resolve<DialogService>(),
        ),
        // This will default to the view's type name `SecondView`.
      );
  }
}

class ParameterNames {
  static const messageFromHome = 'messageFromHome';
  static const messageFromSecond = 'messageFromSecond';
}

class MyApp extends Application {
  MyApp(Initializer initializer) : super(initializer);

  @override
  void onInitialize() {
    print('Initialized');
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Arch Demo',
      navigatorKey: NavigationService.navigatorKey, // IMPORTANT
      theme: ThemeData(primarySwatch: Colors.blue),
      home: HomeView(),
    );
  }
}

class HomeView extends StatefulWidget {
  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends ViewStateBase<HomeView, HomeViewModel> {
  @override
  Widget buildView(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(viewModel.title)),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text('You have pushed the button this many times: ${viewModel.counter}'),
            RaisedButton(
              child: Text('Go to Second View'),
              onPressed: viewModel.navigate,
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => viewModel.counter++,
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ),
    );
  }
}

class HomeViewModel extends ViewModelBase {
  HomeViewModel(NavigationService navigationService) : super(navigationService: navigationService);

  String title = 'Flutter Demo Home View';

  int _counter = 0;
  int get counter => _counter;
  set counter(int value) {
    if (_counter != value) {
      _counter = value;
      notifyListeners('counter');
    }
  }

  Future<void> navigate() async {
    final result = await navigationService.push('SecondView', {ParameterNames.messageFromHome: 'Hello'});
    if (result?.containsKey(ParameterNames.messageFromSecond) == true) {
      print(result[ParameterNames.messageFromSecond]);
    }
  }
}

class SecondView extends ViewBase<SecondViewModel> {
  SecondView({Key key}) : super(key: key);

  @override
  Widget buildView(BuildContext context, SecondViewModel viewModel) {
    return Scaffold(
      appBar: AppBar(title: Text(viewModel.title)),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            RaisedButton(
              child: Text('Go Back'),
              onPressed: viewModel.goBack,
            ),
            RaisedButton(
              child: Text('Show Alert'),
              onPressed: viewModel.alert,
            ),
          ],
        ),
      ), //
    );
  }
}

class SecondViewModel extends ViewModelBase {
  SecondViewModel(NavigationService navigationService, DialogService dialogService)
      : super(navigationService: navigationService, dialogService: dialogService);

  final title = 'Second View';

  @override
  Future<void> init([Map<String, Object> parameters]) async {
    if (parameters?.containsKey(ParameterNames.messageFromHome) == true) {
      print(parameters[ParameterNames.messageFromHome]);
    }
  }

  void goBack() => navigationService.pop({ParameterNames.messageFromSecond: 'Hi!'});

  void alert() => dialogService.alert('This is an alert dialog');
}
