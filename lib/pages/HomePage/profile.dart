import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animator/flutter_animator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:lost_heros_endsars/providers/profile_provider.dart';
import 'package:lost_heros_endsars/utils/constants.dart';
import 'package:lost_heros_endsars/utils/end_points.dart';
import 'package:lost_heros_endsars/utils/widgets.dart';
import 'package:provider/provider.dart';

class ProfilePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: getAppBar(context,
        title: "Profile", subtitle: "Your information are displayed here", height: 40.0, showProfile: false,
      ),
      body: Consumer<ProfileProvider>(
        builder: (context, value, child) {
          return Visibility(
            visible: value.getIsLoggedIn,
            child: WatchBoxBuilder(
              box: Hive.box(userDataBoxKey),
              builder: (context, box) {
                var userData = box.get(userDataKey);
                print(userData);
                return Column(
                  children: [
                    SizedBox(height: 10,),
                    FadeIn(
                      child: GestureDetector(
                        onTap: () => value.showProfilePicture(context),
                        onDoubleTap: () => value.selectPictureToUploadView(context),
                        child: CircleAvatar(
                          backgroundColor: Colors.black,
                          radius: 50,
                          child: Hero(
                            tag: 'profile_image',
                            child: ClipRRect(
                              borderRadius:  BorderRadius.all(Radius.circular(1000)),
                              child: CachedNetworkImage(
                                imageUrl: "$baseUrl/profiles/${userData['image_url']}",
                                height: 60, width: 60, fit: BoxFit.cover,
                              )
                            )
                          ),
                        ),
                      ),
                    ),
                    FadeIn(
                      child: ListTile(
                        title: Text("Full name"),
                        subtitle: Text('${userData['full_name']}'),
                        contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                      ),
                    ),
                    FadeIn(
                      child: ListTile(
                        title: Text("Email address"),
                        subtitle: Text('${userData['email']}'),
                        contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                      ),
                    ),
                    FadeIn(
                      child: ListTile(
                        title: Text("Username"),
                        subtitle: Text('${userData['username']}'),
                        contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                      ),
                    ),
                    FadeIn(
                      child: ListTile(
                        title: Text("Phone number"),
                        subtitle: Text('${userData['phone_number']}'),
                        contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          OutlineButton(
                            child: Text("Edit Profile"),
                            onPressed: () => Navigator.of(context).pushNamed('edit_profile'),
                          ),
                          OutlineButton(
                            child: Text("Logout", style: TextStyle(
                              color: Colors.red
                            ),),
                            onPressed: () => value.logout(context),
                          ),
                        ],
                      ),
                    )
                  ],
                );
              },
            ),
            replacement: Container(
              alignment: Alignment.center,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text("You are logged in", style: GoogleFonts.acme(
                    fontSize: 24
                  ),),
                  SizedBox(height: 20,),
                  OutlineButton(
                    onPressed: () => Navigator.pushNamed(context, 'login'),
                    child: Text("Login"),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
