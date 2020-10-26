import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:hive/hive.dart';
import 'package:lost_heros_endsars/actions/auth_actions.dart';
import 'package:lost_heros_endsars/utils/base_provider.dart';
import 'package:lost_heros_endsars/utils/constants.dart';
import 'package:lost_heros_endsars/utils/message_alert.dart';

class EditProfileProvider extends BaseProvider {
  var userData = {};


  initialize() async {
    setActionState = ActionState(actionStatus: ActionStatus.Loading, message: '..');
    var userBox = Hive.box(userDataBoxKey);
    userData = userBox.get(userDataKey);
    setActionState = ActionState(actionStatus: ActionStatus.Loaded, message: '..');
  }

  updateProfile(BuildContext context, {userData}) async {
    MessageAlert.confirmAlert(context, message: "Are you sure you want to update your profile?", actionAfterConfirm: () async {
      MessageAlert.LoadingAlert(context, message: "Updating your profile...");
      var data = {
        'full_name': userData['full_name'], 'username': userData['username'],
        'email': userData['email'], 'phone_number': userData['phone_number'], 'id': userData['id']
      };
      var updateResponse = await AuthActions.updateProfile(data: data);
      updateResponse = jsonDecode(updateResponse);
      print(updateResponse);
      if (updateResponse['status'] == true) {
        var userBox = Hive.box(userDataBoxKey);
        userBox.put(userDataKey, userData);
        MessageAlert.successAlert(context, message: updateResponse['message'], action: () {
          Navigator.of(context).pop();
        });
      } else {
        MessageAlert.errorAlert(context, message: updateResponse['message']);
      }
    });
  }

  EditProfileProvider() {
    initialize();
  }
}