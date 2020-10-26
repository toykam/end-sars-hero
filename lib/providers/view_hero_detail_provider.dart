import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_share/flutter_share.dart';
import 'package:hive/hive.dart';
import 'package:lost_heros_endsars/actions/fallen_heros_actions.dart';
import 'package:lost_heros_endsars/utils/base_provider.dart';
import 'package:lost_heros_endsars/utils/constants.dart';
import 'package:lost_heros_endsars/utils/end_points.dart';
import 'package:lost_heros_endsars/utils/message_alert.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';

class ViewHeroDetailProvider extends BaseProvider {

  Map<String, dynamic> _heroDetail = {};
  String heroId;
  String userId;
  String oneSignalId = '';
  List _stories = [];
  List _followers = [];
  bool _followed = false;


  set setHeroDetail(Map<String, dynamic> hero) {
    _heroDetail = hero;
    notifyListeners();
  }
  set setFollowers(List followers) {
    _followers = followers;
    notifyListeners();
  }
  set setStories(List stories) {
    _stories = stories;
    notifyListeners();
  }

  set setFollowed(bool foled) {
    _followed = foled;
    notifyListeners();
  }


  Map<String, dynamic> get getHeroDetail => _heroDetail;
  List get getStories => _stories;
  List get getFollowers => _followers;
  bool get getFollowed => _followed;

  initialize() async {
    setActionState = ActionState(message: '...', actionStatus: ActionStatus.Loading);
    setFollowed = false;
    try {
      var box = Hive.box(userDataBoxKey);
      var userData = box.get(userDataKey);
      if (userData != null) {
        userId = userData['id'];
        oneSignalId = userData['user_id'];
        print("OnSignal: $oneSignalId");
        await OneSignal.shared.setExternalUserId('$oneSignalId');
        // await OneSignal.shared.setEmail(email: );
      }
      var response = await FallenHerosActions.getFallenHeroDetail(heroId: heroId, userId: userId);
      setHeroDetail = response['data'];
      setStories = response['stories'];
      setFollowers = response['followers'];
      _followers.forEach((element) {
        // print("Follower: $element");
        // print("OneSignalInLoop: $oneSignalId");
        print(oneSignalId == element['user_id']);

        if (element['user_id'].toString() == oneSignalId.toString()) {
          setFollowed = true;
          // print("Already Followed");
        }
      });
      setActionState = ActionState(message: "Loaded", actionStatus: ActionStatus.Loaded);
      // print(userData);
      notifyListeners();
    } catch (error) {
      print(error);
      setActionState = ActionState(message: "ErrorOccurred", actionStatus: ActionStatus.ErrorOccurred);
      MessageAlert.errorAlert(context, message: "$error");
    }
  }

  ViewHeroDetailProvider({data}) {
    setBuildContext = context;
    heroId = data['victimId'].toString();
    userId = data['userId'].toString();
    initialize();
  }


  _followStory(BuildContext context) async {
    MessageAlert.LoadingAlert(context, message: "Following ${_heroDetail['victim_name']} story...");
    var data = {
      'victim_id': _heroDetail['id'],
      'user_id': oneSignalId
    };
    print("DataToFollow: $data");
    var followResponse = await FallenHerosActions.followStory(data: data);
    followResponse = jsonDecode(followResponse);
    if (followResponse['status'] == true) {
      MessageAlert.successAlert(context, message: "You are now following ${_heroDetail['victim_name']} Story", action: () {
        setFollowed = true;
      });
    } else {
      MessageAlert.errorAlert(context, message: "Unable to follow ${_heroDetail['victim_name']} Story");
    }
  }

  followStory(BuildContext context) async {
    var box = Hive.box(userDataBoxKey);
    var isOnline = box.get(userOnlineKey);

    if (isOnline == true) {
      MessageAlert.confirmAlert(context, message: "Following ${_heroDetail['victim_name']}\'s Story, it means you will get notifications for all stories added to ${_heroDetail['victim_name']}\' wall", actionAfterConfirm: () {
        _followStory(context);
      });
    } else {
      MessageAlert.confirmAlert(context, message: "To follow this story, You have to login or register", actionAfterConfirm: () {
        Navigator.of(context).pushNamed('login');
      });
    }
  }

  _unFollowStory(BuildContext context) async {
    MessageAlert.LoadingAlert(context, message: "Unfollowing ${_heroDetail['victim_name']} story...");
    await OneSignal.shared.setExternalUserId('$oneSignalId');
    // await Future.delayed(Duration(seconds: 5));
    var data = {
      'victim_id': _heroDetail['id'],
      'user_id': oneSignalId
    };
    var followResponse = await FallenHerosActions.unFollowStory(data: data);
    followResponse = jsonDecode(followResponse);
    if (followResponse['status'] == true) {
      MessageAlert.successAlert(context, message: "You have successfully unfollow ${_heroDetail['victim_name']} Story", action: () {
        setFollowed = false;
      });
    } else {
      MessageAlert.errorAlert(context, message: "Unable to unfollow ${_heroDetail['victim_name']} Story");
    }
  }

  unFollowStory(BuildContext context) async {
    var box = Hive.box(userDataBoxKey);
    var isOnline = box.get(userOnlineKey);

    if (isOnline == true) {
      MessageAlert.confirmAlert(context, message: "Unfollowing ${_heroDetail['victim_name']}\'s Story, it means you will no longer get notifications for all stories added to ${_heroDetail['victim_name']}\' wall", actionAfterConfirm: () {
        _unFollowStory(context);
      });
    } else {
      MessageAlert.confirmAlert(context, message: "To follow this story, You have to login or register", actionAfterConfirm: () {
        Navigator.of(context).pushNamed('login');
      });
    }
  }

  Future<void> shareHeroDetail() async {
    await FlutterShare.share(
        text: 'This is ${_heroDetail['victim_name']} he is also a victim of the SARS officer brutality. click the link below to read more about the incidence. #EndSARS #EndPoliceBrutality',
        title: 'Share Link',
        linkUrl: "$baseUrl/web/hero/info/${_heroDetail['victim_name'].toString().replaceAll(' ', '_')}/${_heroDetail['id']}",
        chooserTitle: 'Select where to share'
    );
  }

  reload() {
    initialize();
  }

}