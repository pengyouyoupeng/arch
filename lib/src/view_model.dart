import 'package:arch/src/dialog.dart';
import 'package:arch/src/listenable_model.dart';
import 'package:arch/src/navigation.dart';
import 'package:meta/meta.dart';

abstract class ViewModelBase extends ListenableModel {
  ViewModelBase({this.navigationService, this.dialogService});

  @protected
  final NavigationService navigationService;

  @protected
  final DialogService dialogService;

  Future<void> init([Map<String, Object> parameters]) => Future<void>.value();
}

abstract class DialogModelBase extends ListenableModel {
  DialogModelBase(this._dialogService);

  final DialogService _dialogService;

  Future<void> init([Map<String, Object> parameters]) => Future<void>.value();

  @nonVirtual
  void pop([Map<String, Object> result]) => _dialogService.pop(result);
}
