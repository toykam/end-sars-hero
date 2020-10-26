import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animator/flutter_animator.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:lost_heros_endsars/providers/edit_profile_provider.dart';
import 'package:lost_heros_endsars/utils/base_provider.dart';
import 'package:lost_heros_endsars/utils/constants.dart';
import 'package:lost_heros_endsars/utils/styles.dart';
import 'package:lost_heros_endsars/utils/widgets.dart';
import 'package:provider/provider.dart';

class EditProfilePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: getAppBar(context,
        title: "Edit Profile", subtitle: "Change you profile information", height: 40.0, showProfile: false
      ),
      body: Consumer<EditProfileProvider>(
        builder: (context, value, child) {
          return Visibility(
            visible: value.getActionState.actionStatus == ActionStatus.Loaded,
            child: WatchBoxBuilder(
              box: Hive.box(userDataBoxKey),
              builder: (context, box) {
                var userData = box.get(userDataKey);
                return Container(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        Container(
                          padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                          child: FadeIn(
                            child: TextFormField(
                              initialValue: userData['full_name'],
                              decoration: getInputDecoration(hintText: "Full name"),
                              onChanged: (String name) {
                                userData['full_name'] = name;
                                print(userData);
                              },
                            ),
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                          child: FadeIn(
                            child: TextFormField(
                              initialValue: userData['email'],
                              decoration: getInputDecoration(hintText: "Email address"),
                              onChanged: (String name) {
                                userData['email'] = name;
                                print(userData);
                              },
                            ),
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                          child: FadeIn(
                            child: TextFormField(
                              initialValue: userData['username'],
                              decoration: getInputDecoration(hintText: "Username"),
                              onChanged: (String name) {
                                userData['username'] = name;
                                print(userData);
                              },
                            ),
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                          child: FadeIn(
                            child: TextFormField(
                              initialValue: userData['phone_number'],
                              decoration: getInputDecoration(hintText: "Phone number"),
                              onChanged: (String name) {
                                userData['phone_number'] = name;
                                print(userData);
                              },
                              keyboardType: TextInputType.phone,
                            ),
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                          child: FadeIn(
                            child: OutlineButton(
                              child: Text("Update Profile"),
                              onPressed: () => value.updateProfile(context, userData: userData),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
            replacement: Container(
              child: Center(
                child: CupertinoActivityIndicator(),
              ),
            ),
          );
        },
      ),
    );
  }
}
