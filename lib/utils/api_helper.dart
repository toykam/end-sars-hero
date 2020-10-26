import 'package:dio/dio.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'package:http/http.dart' as http;

class Apihelper {

  static Future makeGetRequest({url}) async {

    Dio _dio = Dio();
    _dio.interceptors.add(PrettyDioLogger(requestHeader: true,
        requestBody: true,
        responseBody: true,
        responseHeader: false,
        error: true,
        compact: true,
        maxWidth: 90));
    /// Dio Configuration
    
    return _dio.get(url, options: Options(
      headers: {
        'Content-Type': 'application/json'
      }
    )).then((value) => value.data);
  }

  static Future makePostRequest({url, data, useFormData}) async {

    Dio _dio = Dio();
    _dio.interceptors.add(PrettyDioLogger(requestHeader: true,
        requestBody: true,
        responseBody: true,
        responseHeader: false,
        error: true,
        compact: true,
        maxWidth: 90));
    /// Dio Configuration
    // http.
    return http.post(url, body: useFormData ? FormData.fromMap(data) : data).then((value) => value.body);
  }


}