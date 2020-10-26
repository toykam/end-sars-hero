
import 'dart:convert';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lost_heros_endsars/providers/home_page_provider.dart';
import 'package:lost_heros_endsars/utils/base_provider.dart';
import 'package:lost_heros_endsars/utils/constants.dart';
import 'package:lost_heros_endsars/utils/end_points.dart';
import 'package:lost_heros_endsars/utils/message_alert.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';

class ProfileProvider extends BaseProvider {

  bool _isLoggedIn = false;
  var userData = {};

  set setLoggedIn(bool loggedIn) {
    _isLoggedIn = loggedIn;
    notifyListeners();
  }

  bool get getIsLoggedIn => _isLoggedIn;

  initialize() async {
    setActionState = ActionState(message: '...', actionStatus: ActionStatus.Loading);
    var usBox = Hive.box(userDataBoxKey); // Box Containing userdata and login status
    bool isLoggedIn = usBox.get(userOnlineKey);
    if (isLoggedIn == true) {
      setLoggedIn = true;
      userData = usBox.get(userDataKey);
    }
    setActionState = ActionState(message: '...', actionStatus: ActionStatus.Loaded);
  }

  selectImageToUpload(BuildContext context, ImageSource imageSource) async {
    PickedFile _pickedFile = await ImagePicker.platform.pickImage(source: imageSource);
    if (_pickedFile != null) {
      _uploadProfilePicture(context, fil: File(_pickedFile.path));
    }
  }

  selectPictureToUploadView(BuildContext context) async {
    showModalBottomSheet(
      backgroundColor: Colors.black.withOpacity(0.9),
      enableDrag: false,
      context: context,
      builder: (context) {
        return Container(
          color: Colors.white,
          padding: EdgeInsets.fromLTRB(15, 5, 15, 0),
          width: MediaQuery.of(context).size.width,
          height: 150,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Select Image Source", style: GoogleFonts.abel(
                fontSize: 20, fontWeight: FontWeight.bold
              ),),
              SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      IconButton(
                        icon: Icon(Icons.camera, size: 50,),
                        onPressed: () => selectImageToUpload(context, ImageSource.camera),
                      ),
                      SizedBox(height: 20,),
                      Text('Camera')
                    ],
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      IconButton(
                        icon: Icon(Icons.image, size: 50,),
                        onPressed: () => selectImageToUpload(context, ImageSource.gallery),
                      ),
                      SizedBox(height: 20,),
                      Text('Gallery')
                    ],
                  ),
                ],
              )
            ],
          ),
        );
      },
    );
    // File _selectedImage = await ImagePicker.pickImage(source: ImageSource.gallery);
  }

  showProfilePicture(BuildContext context) async {
    showModalBottomSheet(
      backgroundColor: Colors.black.withOpacity(0.5),
      enableDrag: false,
      isScrollControlled: true,
      context: context,
      builder: (context) {
        return Container(
          color: Colors.black.withOpacity(0.5),
          padding: EdgeInsets.fromLTRB(15, 5, 15, 0),
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Hero(
                tag: 'profile_image',
                child: ClipRRect(
                  borderRadius: BorderRadius.all(Radius.circular(10000)),
                  child: CachedNetworkImage(
                    imageUrl: "$baseUrl/profiles/${userData['image_url']}", height: 200, width: 200,
                  )
                )
                // Image.asset('assets/images/end_sars_logo.png', height: 100, width: 100,)
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: OutlineButton(
                  child: Text('Change Picture'),
                  onPressed: () {
                    Navigator.of(context).pop('modal');
                    selectPictureToUploadView(context);
                  },
                  textColor: Colors.white,
                ),
              )
            ],
          )
        );
      },
    );
  }

  _uploadProfilePicture(BuildContext context, {File fil}) async {
    try {
      MessageAlert.LoadingAlert(context, message: "Uploading profile picture...");
      final directory = await getExternalStorageDirectory();
      File errorFile = File('${directory.path}/error.txt');

      var box = Hive.box(userDataBoxKey);

      var userData = box.get(userDataKey);
      var userId = userData['id'];
      print(userId);

      var url = baseUrl+updateProfilePictureEndpoint+userId;
      final file = await MultipartFile.fromPath(
        'image', fil.path,
      );

      var request = new MultipartRequest("POST", Uri.parse(url));
      request.files.add(file);

      var streamedResponse = await request.send();
      var response = await Response.fromStream(streamedResponse);
      print("${response.body.toString()}");
      errorFile.writeAsString('${response.body}');
      var res = jsonDecode(response.body);

      if (res['status'] == true) {
        userData['image_url'] = res['data'];
        box.put(userDataKey, userData);
        MessageAlert.successAlert(context, message: res['message'], action: () {
          Provider.of<HomePageProvider>(context, listen: false).reload();
        });
      } else {
        MessageAlert.errorAlert(context, message: res['message']);
      }

    } catch (error) {
      print(error);
      MessageAlert.errorAlert(context, message: "$error");
    }

  }

  logout(BuildContext context) {
    // print('About to logout');
    MessageAlert.confirmAlert(context, message: "Do you really want to logout?",  actionAfterConfirm: () {
      var usBox = Hive.box(userDataBoxKey); // Box Containing userdata and login status
      setLoggedIn = false;
      usBox.put(userOnlineKey, false);
      Navigator.pushReplacementNamed(context, '/');
    });
  }

  ProfileProvider() {
    initialize();
  }
}