import 'dart:convert';
import 'dart:io';

// import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lost_heros_endsars/providers/home_page_provider.dart';
import 'package:lost_heros_endsars/utils/base_provider.dart';
import 'package:lost_heros_endsars/utils/constants.dart';
import 'package:lost_heros_endsars/utils/end_points.dart';
import 'package:lost_heros_endsars/utils/message_alert.dart';
import 'package:path_provider/path_provider.dart' as path;
import 'package:provider/provider.dart';

class AddNewHeroProvider extends BaseProvider {
  String _heroName = '';
  String _heroTitle = '';
  String _heroBio = '';
  String _heroStory = '';
  String _heroIncidenceLocation = '';
  String _heroPoliceInCharge = '';
  String _heroPoliceDivision = '';
  String _heroState = '';
  File _heroImage;
  Widget displayImage = Container();

  set setDisplayImage(Widget widget) {
    displayImage = widget;
    notifyListeners();
  }

  set setHeroState(String heroState) {
    _heroState = heroState;
    notifyListeners();
  }

  set setHeroPoliceDivision(String division) {
    _heroPoliceDivision = division;
    notifyListeners();
  }
  set setHeroTitle(String title) {
    _heroTitle = title;
    notifyListeners();
  }


  set setHeroPoliceInCharge(String policeInCharge) {
    _heroPoliceInCharge = policeInCharge;
    notifyListeners();
  }

  set setHeroIncidenceLocation(String location) {
    _heroIncidenceLocation = location;
    notifyListeners();
  }

  set setHeroStory(String story) {
    _heroStory = story;
    notifyListeners();
  }

  set setHeroBio(String bio) {
    _heroBio = bio;
    notifyListeners();
  }

  set setHeroName(String name) {
    _heroName = name;
    notifyListeners();
  }

  String get getHeroName => _heroName;
  String get getHeroPoliceDivision => _heroPoliceDivision;
  String get getHeroPoliceInCharge => _heroPoliceInCharge;
  String get getHeroIncidenceLocation => _heroIncidenceLocation;
  String get getHeroBio => _heroBio;
  String get getHeroStory => _heroStory;
  File get getImageFile => _heroImage;
  String get getHeroState => _heroState;



  selectImage(BuildContext context) async {
    File _pickedImage = await ImagePicker.pickImage(source: ImageSource.gallery, maxHeight: 150, maxWidth: MediaQuery.of(context).size.width);
    if (_pickedImage != null) {
      _heroImage = _pickedImage;
      notifyListeners();
      setDisplayImage = Image.file(_heroImage, width: MediaQuery.of(context).size.width, height: 300, fit: BoxFit.cover,);
    }
  }

  void confirmSubmission(BuildContext context) {
    MessageAlert.confirmAlert(context, message: "Are you sure this information is correct?", actionAfterConfirm: () {
      addHero(context);
    });
  }


  void addHero(BuildContext context) async {
    final directory = await path.getExternalStorageDirectory();
    File errorFile = File('${directory.path}/error.txt');
    // print(errorFile.path);

    MessageAlert.LoadingAlert(context, message: "Adding Hero to List");
    try {
      var box = Hive.box(userDataBoxKey);
      var isOnline = box.get(userOnlineKey);

      if (isOnline == true) {
        var userId = box.get(userDataKey)['id'];
        print(userId);

        var url = baseUrl+addNewFallenHeroEndpoint;
        final file = await MultipartFile.fromPath(
          'image',
          _heroImage.path,
        );

        var request = new MultipartRequest("POST", Uri.parse(url));
        request.fields['victim_name'] = _heroName;
        request.fields['story'] = _heroStory;
        request.fields['title'] = _heroTitle;
        request.fields['status'] = _heroState;
        request.fields['bio'] = _heroBio;
        request.fields['location'] = _heroIncidenceLocation;
        request.fields['officer_incharge'] = _heroPoliceInCharge;
        request.fields['police_division'] = _heroPoliceDivision;
        request.fields['user_id'] = userId;

        request.files.add(file);

        // var response = await FallenHerosActions.addNewFallenHero(heroData: data);
        var streamedResponse = await request.send();
        var response = await Response.fromStream(streamedResponse);
        print("${response.body.toString()}");
        errorFile.writeAsString('${response.body}');
        var res = jsonDecode(response.body);

        if (res['status'] == true) {
          MessageAlert.successAlert(context, message: "Hero history have been added  successfully", action: () {
            Provider.of<HomePageProvider>(context, listen: false).reload();
          });
        } else {
          MessageAlert.errorAlert(context, message: 'Error occurred ');
        }
      } else {
        MessageAlert.confirmAlert(context, message: "To add to this story, You have to login or register", actionAfterConfirm: () {
          Navigator.of(context).pushNamed('login');
        });
      }
    } catch (error) {
      print('AddHeroError: $error');
      MessageAlert.errorAlert(context, message: "An error occurred,please try again later");
    }
  }


  AddNewHeroProvider() {}
}