import 'package:flutter/cupertino.dart';
import 'package:hive/hive.dart';
import 'package:lost_heros_endsars/actions/fallen_heros_actions.dart';
import 'package:lost_heros_endsars/utils/base_provider.dart';
import 'package:lost_heros_endsars/utils/constants.dart';
import 'package:lost_heros_endsars/utils/message_alert.dart';

class HomePageProvider extends BaseProvider {

  List _fallenHeros = [];
  BuildContext context;
  bool _isLoggedIn = false;

  set setFallenHeros(List fallen) {
    _fallenHeros = fallen;
    notifyListeners();
  }

  set setIsLoggedIn(bool isLoggedIn) {
    _isLoggedIn = isLoggedIn;
    notifyListeners();
  }

  set setBuildContext(BuildContext ctx) {
    context = ctx;
  }

  List get getFallenHero => _fallenHeros;

  initialize() async {
    var box = Hive.box(userDataBoxKey);
    var isOnline = box.get(userOnlineKey);
    var vicBox = Hive.box(victimBox);
    setIsLoggedIn = isOnline == true ? true : false;
    setActionState = ActionState(message: "Loading...", actionStatus: ActionStatus.Loading);
    try {
      var response = await FallenHerosActions.getOurFallenHeros();
      setFallenHeros = response;
      vicBox.put(victim_list, response);
      // print("response: $response");
      setActionState = ActionState(actionStatus: ActionStatus.Loaded, message: '...');
    } catch (error) {
      setActionState = ActionState(actionStatus: ActionStatus.ErrorOccurred, message: '...');
      // print("Error: $error");
    }
  }

  HomePageProvider() {
    initialize();
  }

  reload() {
    initialize();
  }
}