import 'package:arch/src/navigation.dart';
import 'package:arch/src/widgets.dart';
import 'package:flutter/material.dart';

abstract class DialogService {
  Future<void> alert(String message, {String title, String ok = 'Ok'});

  Future<bool> confirm(String message, {String title, String ok = 'Ok', String cancel = 'Cancel'});

  Future<Map<String, Object>> showCustomDialog(String dialogName, [Map<String, Object> parameters]);

  void pop([Map<String, Object> result]);
}

class DialogRoute extends InheritedWidget {
  DialogRoute({@required Widget child, this.settings}) : super(child: child);

  final RouteSettings settings;

  static DialogRoute of(BuildContext context) => context.dependOnInheritedWidgetOfExactType<DialogRoute>();

  @override
  bool updateShouldNotify(DialogRoute oldWidget) => settings != oldWidget.settings;
}

class DialogServiceImpl implements DialogService {
  @override
  Future<void> alert(String message, {String title, String ok = 'Ok'}) {
    return showDialog(
      context: _context,
      builder: (context) {
        return AlertDialog(
          title: title != null ? Text(title) : null,
          content: Text(message),
          actions: <Widget>[
            FlatButton(
              child: Text(ok),
              onPressed: Navigator.of(context).pop,
            )
          ],
        );
      },
    );
  }

  @override
  Future<bool> confirm(String message, {String title, String ok = 'Ok', String cancel = 'Cancel'}) {
    return showDialog<bool>(
      context: _context,
      builder: (context) {
        return AlertDialog(
          title: title != null ? Text(title) : null,
          content: Text(message),
          actions: <Widget>[
            FlatButton(
              child: Text(cancel),
              onPressed: () => Navigator.of(context).pop(false),
            ),
            FlatButton(
              child: Text(ok),
              onPressed: () => Navigator.of(context).pop(true),
            ),
          ],
        );
      },
    );
  }

  @override
  Future<Map<String, Object>> showCustomDialog(String dialogName, [Map<String, Object> parameters]) {
    return showDialog(
      context: _context,
      builder: (context) => DialogRoute(
        child: Application.serviceLocator.resolve<Widget>(dialogName),
        settings: RouteSettings(name: dialogName, arguments: parameters),
      ),
    );
  }

  @override
  void pop([Map<String, Object> result]) => Navigator.of(_context).pop(result);

  static BuildContext get _context => NavigationService.navigatorKey.currentState.overlay.context;
}
