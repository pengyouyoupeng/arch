import 'package:arch/src/dialog.dart';
import 'package:arch/src/view_model.dart';
import 'package:arch/src/widgets.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:provider/provider.dart';

/// A view that is stateless and has a view model.
abstract class ViewBase<TViewModel extends ViewModelBase> extends StatelessWidget {
  const ViewBase({Key key}) : super(key: key);

  /// Describes the UI to be presented by this view.
  ///
  /// Called whenever the view model changes.
  Widget buildView(BuildContext context, TViewModel viewModel);

  @nonVirtual
  @override
  Widget build(BuildContext context) {
    return ListenableProvider<TViewModel>(
      create: (_) {
        if (Application.serviceLocator.canResolve<TViewModel>()) {
          final viewModel = Application.serviceLocator.resolve<TViewModel>();
          final parameters = ModalRoute.of(context)?.settings?.arguments as Map<String, Object>;
          viewModel.init(parameters);
          didInitViewModel(viewModel);
          return viewModel;
        }

        throw Error.safeToString('Cannot find view model $TViewModel for ${this.runtimeType}. Did you registered it?');
      },
      child: Consumer<TViewModel>(builder: (context, viewModel, _) => buildView(context, viewModel)),
      dispose: (_, viewModel) => dispose(viewModel),
    );
  }

  /// Called after initializing the view model.
  ///
  /// Set objects here that depend on the view model after it was initialized.
  void didInitViewModel(TViewModel viewModel) {}

  /// Free resources in this object before removing it from the widget tree.
  ///
  /// If you override this, make sure to end your method with a call to super.dispose(),
  /// because this will dispose the view model after all disposal in this view is finished.
  @mustCallSuper
  void dispose(TViewModel viewModel) {
    viewModel?.dispose();
  }
}

/// A view that is presented as a dialog. It is stateless and can be navigated to.
abstract class DialogBase<TDialogModel extends DialogModelBase> extends StatelessWidget {
  DialogBase({Key key}) : super(key: key);

  /// Describes the UI to be presented by this dialog.
  ///
  /// Called whenever the dialog model changes.
  Widget buildDialog(BuildContext context, TDialogModel dialogModel);

  @nonVirtual
  @override
  Widget build(BuildContext context) {
    return ListenableProvider<TDialogModel>(
      create: (_) {
        final dialogModel = Application.serviceLocator.resolve<TDialogModel>();
        final parameters = DialogRoute.of(context)?.settings?.arguments as Map<String, Object>;
        dialogModel?.init(parameters);
        didInitDialogModel(dialogModel);
        return dialogModel;
      },
      child: Consumer<TDialogModel>(builder: (context, dialogModel, _) => buildDialog(context, dialogModel)),
      dispose: (_, dialogModel) => dispose(dialogModel),
    );
  }

  /// Called after initializing the dialog model.
  ///
  /// Set objects here that depend on the dialog model after it was initialized.
  void didInitDialogModel(TDialogModel dialogModel) {}

  /// Free resources in this object before removing it from the widget tree.
  ///
  /// If you override this, make sure to end your method with a call to super.dispose(),
  /// because this will dispose the dialog model after all disposal in this dialog is finished.
  @mustCallSuper
  void dispose(TDialogModel dialogModel) {
    dialogModel?.dispose();
  }
}

/// A view's state that has a view model.
abstract class ViewStateBase<TWidget extends StatefulWidget, TViewModel extends ViewModelBase> extends State<TWidget> {
  TViewModel _viewModel;
  TViewModel get viewModel => _viewModel;

  /// Describes the UI to be presented by this state.
  ///
  /// Called whenever the view model changes.
  Widget buildView(BuildContext context);

  @mustCallSuper
  @override
  void initState() {
    super.initState();
    if (Application.serviceLocator.canResolve<TViewModel>()) {
      _viewModel = Application.serviceLocator.resolve<TViewModel>();
    } else {
      throw Error.safeToString('Cannot find view model $TViewModel for $TWidget\'s. Did you registered it?');
    }
  }

  /// Called after initializing the view model.
  ///
  /// Set objects here that depend on the view model after it was initialized.
  void didInitViewModel() {}

  /// Free resources in this object before removing it from the widget tree.
  ///
  /// If you override this, make sure to end your method with a call to super.dispose(),
  /// because this will dispose the view model after all disposal in this state is finished.
  @mustCallSuper
  @override
  void dispose() {
    viewModel.dispose();
    super.dispose();
  }

  @nonVirtual
  @override
  Widget build(BuildContext context) {
    return ListenableProvider<TViewModel>(
      create: (_) {
        final parameters = ModalRoute.of(context)?.settings?.arguments as Map<String, Object>;
        _viewModel.init(parameters);
        didInitViewModel();
        return _viewModel;
      },
      child: Consumer<TViewModel>(builder: (context, _, __) => buildView(context)),
    );
  }
}

/// A view's state that has a view model, mixed with [AutomaticKeepAliveClientMixin].
abstract class AutomaticKeepAliveViewStateBase<TWidget extends StatefulWidget, TViewModel extends ViewModelBase>
    extends State<TWidget> with AutomaticKeepAliveClientMixin {
  TViewModel _viewModel;
  TViewModel get viewModel => _viewModel;

  /// Describes the UI to be presented by this state.
  ///
  /// Called whenever the view model changes.
  Widget buildView(BuildContext context);

  @override
  bool get wantKeepAlive => true;

  @mustCallSuper
  @override
  void initState() {
    super.initState();
    if (Application.serviceLocator.canResolve<TViewModel>()) {
      _viewModel = Application.serviceLocator.resolve<TViewModel>();
    } else {
      throw Error.safeToString('Cannot find view model $TViewModel for $TWidget\'s. Did you registered it?');
    }
  }

  /// Called after initializing the view model.
  ///
  /// Set objects here that depend on the view model after it was initialized.
  void didInitViewModel() {}

  /// Free resources in this object before removing it from the widget tree.
  ///
  /// If you override this, make sure to end your method with a call to super.dispose(),
  /// because this will dispose the view model after all disposal in this state is finished.
  @mustCallSuper
  @override
  void dispose() {
    viewModel.dispose();
    super.dispose();
  }

  @nonVirtual
  @override
  Widget build(BuildContext context) {
    super.build(context);

    return ListenableProvider<TViewModel>(
      create: (_) {
        final parameters = ModalRoute.of(context)?.settings?.arguments as Map<String, Object>;
        _viewModel.init(parameters);
        didInitViewModel();
        return _viewModel;
      },
      child: Consumer<TViewModel>(builder: (context, _, __) => buildView(context)),
    );
  }
}
