import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:hive/hive.dart';
import 'package:lost_heros_endsars/actions/fallen_heros_actions.dart';
import 'package:lost_heros_endsars/utils/base_provider.dart';
import 'package:lost_heros_endsars/utils/constants.dart';
import 'package:lost_heros_endsars/utils/message_alert.dart';
import 'package:path_provider/path_provider.dart';

class AddToStoryProvider extends BaseProvider {

  String victimId = '';
  String userId = '1';
  String _story = '';
  String _location = '';
  String _officerInCharge = '';
  String _division = '';

  set setStory(String story) {
    _story = story;
    notifyListeners();
  }

  set setLocation(String location) {
    _location = location;
    notifyListeners();
  }

  set setOfficerInCharge(String officer) {
    _officerInCharge = officer;
    notifyListeners();
  }

  set setDivision(String officer) {
    _division = officer;
    notifyListeners();
  }


  String get getStory => _story;
  String get getLocation => _location;
  String get getOfficerInCharge => _officerInCharge;
  String get getDivision => _division;

  addToStories(BuildContext context) async {
    final directory = await getExternalStorageDirectory();
    File errorFile = File('${directory.path}/error.txt');

    try {
      var box = Hive.box(userDataBoxKey);
      var isOnline = box.get(userOnlineKey);
      // bool isOnline = box.get(userOnlineKey) == false || null ? false : true;

      if (isOnline == true) {
        var userId = box.get(userDataKey)['id'];
        if (_story == '' || _location == '') {
          MessageAlert.errorAlert(context, message: "Story and location field are required, Please fill them and try again");
        } else {
          MessageAlert.LoadingAlert(context, message: 'Adding to story...');
          var data = {
            'victim_id': victimId,
            'user_id': userId,
            'story': _story, 'location': _location, 'officer_incharge': _officerInCharge
          };
          var response = await FallenHerosActions.addToStory(data: data);
          response = jsonDecode(response);
          if (response['status'] == true) {
            MessageAlert.successAlert(context, message: response['message'], action: () {

            });
          } else {
            MessageAlert.errorAlert(context, message: response['message']);
          }
        }
      } else {
        MessageAlert.confirmAlert(context, message: "To add to this story, You have to login or register", actionAfterConfirm: () {
          Navigator.of(context).pushNamed('login');
        });
      }
    } catch (error) {
      // Navigator.of(context).pop();
      print(error);
      errorFile.writeAsString('${error.toString()}');
      MessageAlert.errorAlert(context, message: "$error");
      // rethrow;
    }
  }

  AddToStoryProvider({data}) {
    victimId = data['victimId'];
  }
}