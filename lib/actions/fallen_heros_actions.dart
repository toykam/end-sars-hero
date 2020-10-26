import 'package:lost_heros_endsars/utils/api_helper.dart';
import 'package:lost_heros_endsars/utils/end_points.dart';

class FallenHerosActions {

  static Future getOurFallenHeros() async {
    var url = baseUrl+"$getAllFallenHeroEndpoint";
    return Apihelper.makeGetRequest(url: url);
  }

  static Future addNewFallenHero({heroData}) async {
    var url = baseUrl+'$addNewFallenHeroEndpoint';
    return Apihelper.makePostRequest(url: url, data: heroData, useFormData: false);
  }

  static Future getFallenHeroDetail({userId, heroId}) async {
    var url = baseUrl+"$getFallenHeroDetailEndpoint"+userId+'/$heroId';
    return Apihelper.makeGetRequest(url: url);
  }

  static Future addToStory({data}) async {
    var url = "$baseUrl$addToFallenHeroStoryEndpoint";
    return Apihelper.makePostRequest(url: url, data: data, useFormData: false);
  }

  static Future followStory({data}) async {
    var url = "$baseUrl$followHeroDetailEndpoint";
    return Apihelper.makePostRequest(url: url, data: data, useFormData: false);
  }

  static Future unFollowStory({data}) async {
    var url = "$baseUrl$followHeroDetailEndpoint";
    return Apihelper.makePostRequest(url: url, data: data, useFormData: false);
  }

}