import 'package:arch/src/navigation.dart';
import 'package:arch/src/view.dart';
import 'package:arch/src/widgets.dart';
import 'package:flutter/material.dart';

/// A service for showing [AlertDialog]s.
abstract class DialogService {
  /// Shows an [AlertDialog] for acknowledgement.
  /// 
  /// It only has a single, dismissive action used for acknowledgement.
  Future<void> alert(String message, {String title, String ok = 'Ok'});

  /// Shows an [AlertDialog] for confirmation.
  /// 
  /// Returns `true` when the OK button was clicked, `false` if
  /// the cancel button was clicked, and `null` if the alert 
  /// dialog was dismissed.
  Future<bool> confirm(String message, {String title, String ok = 'Ok', String cancel = 'Cancel'});

  /// Shows a custom dialog.
  Future<Map<String, Object>> showCustomDialog(String dialogName, [Map<String, Object> parameters]);

  /// Pops the current [AlertDialog], returning the [result].
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
        child: _getDialog(dialogName),
        settings: RouteSettings(name: dialogName, arguments: parameters),
      ),
    );
  }

  @override
  void pop([Map<String, Object> result]) => Navigator.of(_context).pop(result);

  static BuildContext get _context => NavigationService.navigatorKey.currentState.overlay.context;

  static Widget _getDialog(String name) {
    if (Application.serviceLocator.canResolve<DialogBase>(name: name)) {
      return Application.serviceLocator.resolve<DialogBase>(name);
    }

    throw Error.safeToString('Cannot find dialog named $name. Did you registered it?');
  }
}
