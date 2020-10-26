import 'package:flutter/material.dart';

class BaseProvider extends ChangeNotifier {

  BuildContext context;
  ActionState _actionState = ActionState(message: '...', actionStatus: ActionStatus.Loading);

  set setBuildContext(BuildContext ctx) {
    context = ctx;
  }

  set setActionState(ActionState actionState) {
    _actionState = actionState;
    notifyListeners();
  }

  ActionState get getActionState => _actionState;

  BaseProvider() {
    setBuildContext = context;
  }

}

class ActionState {
  String message = '';
  ActionStatus actionStatus = ActionStatus.Loading;

  ActionState({this.actionStatus, this.message});
}



enum ActionStatus {Loading, Loaded, ErrorOccurred}