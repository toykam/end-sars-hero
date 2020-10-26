import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:hive/hive.dart';
import 'package:lost_heros_endsars/actions/auth_actions.dart';
import 'package:lost_heros_endsars/utils/base_provider.dart';
import 'package:lost_heros_endsars/utils/constants.dart';
import 'package:lost_heros_endsars/utils/message_alert.dart';
import 'package:path_provider/path_provider.dart';

class AuthProvider extends BaseProvider {
  String _fullName = '';
  String _email = '';
  String _password = '';
  String _confirmPassword = '';
  String _username = '';
  bool _hidePassword = true;


  set setPassword(String password) {
    _password = password;
    notifyListeners();
  }

  set setConfirmPassword(String password) {
    _confirmPassword = password;
    notifyListeners();
  }

  set setEmail(String email) {
    _email = email;
    notifyListeners();
  }

  set setFullName(String fullName) {
    _fullName = fullName;
    notifyListeners();
  }

  set setUserName(String username) {
    _username = username;
    notifyListeners();
  }

  set setHidePassword(bool hide) {
    _hidePassword = hide;
    notifyListeners();
  }


  String get getFullName => _fullName;
  String get getPassword => _password;
  String get getConfirmPassword => _confirmPassword;
  String get getEmail => _email;
  String get getUserName => _username;
  bool get getHidePassword => _hidePassword;

  void login(BuildContext context) async {
    final directory = await getExternalStorageDirectory();
    File errorFile = File('${directory.path}/error.txt');
    MessageAlert.LoadingAlert(context, message: "Login in progress");
    try {
      if (_email == '' || _password == '') {
        Navigator.of(context).pop();
        MessageAlert.errorAlert(context, message: "All fields are required");
      } else {
        var data = {
          'email': _email, 'password': _password
        };
        var loginResponse = await AuthActions.login(data: data);
        loginResponse = jsonDecode(loginResponse);
        // print(loginResponse);
        if (loginResponse['status'] == true) {
          var userBox = Hive.box(userDataBoxKey);
          userBox.put(userDataKey, loginResponse['data']);
          userBox.put(userOnlineKey, true);
          MessageAlert.successAlert(context, message: loginResponse['message']);
          await Future.delayed(Duration(seconds: 3));
          Navigator.pushReplacementNamed(context, '/');
        } else {
          MessageAlert.errorAlert(context, message: loginResponse['message']);
        }
      }
    } catch (error) {
      // Navigator.pop(context);
      errorFile.writeAsString('$error');
      MessageAlert.errorAlert(context, message: '$error');
      // rethrow;
    }
  }

  void register(BuildContext context) async {
    final directory = await getExternalStorageDirectory();
    File errorFile = File('${directory.path}/error.txt');
    MessageAlert.LoadingAlert(context, message: "Registration in progress");
    try {
      var data = {
        'email': _email, 'password': _password, 'full_name': _fullName, 'username': _username, 'confirm_password': _confirmPassword
      };
      print("RegistrationData: $data");
      var loginResponse = await AuthActions.register(data: data);
      print(loginResponse);
      loginResponse = jsonDecode(loginResponse);
      print(loginResponse);
      if (loginResponse['status'] == true) {
        MessageAlert.successAlert(context, message: loginResponse['message'], action: () {
          // Navigator.pushReplacementNamed(context, 'login');
          Navigator.of(context).pushReplacementNamed('login');
        });
        await Future.delayed(Duration(seconds: 3));
        Navigator.pushReplacementNamed(context, 'login');
      } else {
        MessageAlert.errorAlert(context, message: loginResponse['message']);
      }
    } catch (error) {
      print(error);
      // Navigator.pop(context);
      errorFile.writeAsString('$error');
      MessageAlert.errorAlert(context, message: '$error');
    }
  }

  AuthProvider() {
  }
}