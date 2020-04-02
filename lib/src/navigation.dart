import 'package:arch/src/widgets.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';

/// A service for navigation.
abstract class NavigationService {
  static final navigatorKey = GlobalKey<NavigatorState>();

  void pop([Map<String, Object> result]);

  void popUntil(String viewName);

  Future<Map<String, Object>> push(String viewName, [Map<String, Object> parameters]);

  Future<Map<String, Object>> pushAndRemoveUntil(
    String viewName,
    String removeUntil, [
    Map<String, Object> parameters,
  ]);

  void pushToNewRoot(String viewName, [Map<String, Object> parameters]);

  Future<Map<String, Object>> pushModal(String viewName, [Map<String, Object> parameters]);

  Future<Map<String, Object>> pushReplacement(String viewName, [Map<String, Object> parameters]);
}

class NavigationServiceImpl implements NavigationService {
  @override
  void pop([Map<String, Object> result]) => _navigator.pop(result);

  @override
  void popUntil(String viewName) => _navigator.popUntil(ModalRoute.withName('/$viewName'));

  @override
  Future<Map<String, Object>> push(String viewName, [Map<String, Object> parameters]) {
    return _navigator.push(
      MaterialPageRoute(
        builder: (_) => _getView(viewName),
        settings: RouteSettings(name: '/$viewName', arguments: parameters),
      ),
    );
  }

  @override
  Future<Map<String, Object>> pushAndRemoveUntil(
    String viewName,
    String removeUntil, [
    Map<String, Object> parameters,
  ]) {
    return _navigator.pushAndRemoveUntil(
      MaterialPageRoute(
        builder: (_) => _getView(viewName),
        settings: RouteSettings(name: '/$viewName', arguments: parameters),
      ),
      ModalRoute.withName('/$removeUntil'),
    );
  }

  @override
  void pushToNewRoot(String viewName, [Map<String, Object> parameters]) {
    _navigator.pushAndRemoveUntil(
      PageTransition<void>(
        type: PageTransitionType.fade,
        curve: Curves.easeOutSine,
        duration: Duration(milliseconds: 150),
        child: _getView(viewName),
        settings: RouteSettings(name: '/$viewName', arguments: parameters),
      ),
      (_) => false,
    );
  }

  @override
  Future<Map<String, Object>> pushModal(String viewName, [Map<String, Object> parameters]) {
    return _navigator.push(
      MaterialPageRoute(
        builder: (_) => _getView(viewName),
        fullscreenDialog: true,
        settings: RouteSettings(name: '/$viewName', arguments: parameters),
      ),
    );
  }

  @override
  Future<Map<String, Object>> pushReplacement(String viewName, [Map<String, Object> parameters]) {
    return _navigator.pushReplacement(
      MaterialPageRoute(
        builder: (_) => _getView(viewName),
        settings: RouteSettings(name: '/$viewName', arguments: parameters),
      ),
    );
  }

  static NavigatorState get _navigator => NavigationService.navigatorKey.currentState;

  static Widget _getView(String name) {
    if (Application.serviceLocator.canResolve<Widget>(name: name)) {
      return Application.serviceLocator.resolve<Widget>(name);
    }

    throw Error.safeToString('Cannot find view/page named $name. Did you registered it?');
  }
}
