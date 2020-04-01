import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:meta/meta.dart';

typedef ModelChangedCallback = void Function([String propertyName]);

/// A [ChangeNotifier] that notifies changes from by giving a name that identifies the change.
abstract class ListenableModel extends ChangeNotifier {
  final _callbacks = Set<ModelChangedCallback>();
  int _microtaskVersion = 0;
  int _version = 0;

  /// Registers a callback that is called when `notifyListeners` was called.
  @nonVirtual
  void addOnModelChanged(ModelChangedCallback callback) => _callbacks.add(callback);

  /// Removes a callback that was previously registered.
  @nonVirtual
  void removeOnModelChanged(ModelChangedCallback callback) => _callbacks.remove(callback);

  /// Removes all registered callbacks that were previously registered.
  @nonVirtual
  void removeAllOnModelChanged() => _callbacks.clear();

  @protected
  @nonVirtual
  @mustCallSuper
  @override
  void notifyListeners([String propertyName]) {
    super.notifyListeners();

    if (_microtaskVersion == _version) {
      _microtaskVersion++;
      scheduleMicrotask(() {
        _version++;
        _microtaskVersion = _version;
        _callbacks.toList().forEach((callback) => callback(propertyName));
        onModelChanged(propertyName);
      });
    }
  }

  /// Called whenever `notifyListeners` was called.
  @protected
  void onModelChanged([String propertyName]) {}

  @mustCallSuper
  @override
  void dispose() {
    removeAllOnModelChanged();
    super.dispose();
  }
}
