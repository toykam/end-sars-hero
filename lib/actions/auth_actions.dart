import 'package:lost_heros_endsars/utils/api_helper.dart';
import 'package:lost_heros_endsars/utils/end_points.dart';

class AuthActions {

  static Future login({data}) async {
    var url = "$baseUrl$loginEndpoint";
    return Apihelper.makePostRequest(url: url, data: data, useFormData: false);
  }

  static Future register({data}) async {
    var url = "$baseUrl$registerEndpoint";
    return Apihelper.makePostRequest(url: url, data: data, useFormData: false);
  }

  static Future updateProfile({data}) async {
    // print("UpdateProfile: $data");
    var url = "$baseUrl$updateProfileEndpoint${data['id']}";
    // print("UpdateProfileUrl: $url");
    return Apihelper.makePostRequest(url: url, data: data, useFormData: false);
  }

}