import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:getx_pattern/app/modules/login/model/login_model.dart';

class LoginApiProvider {

  static Future<LoginModel> fetchLoginModelApi({
    required String? email,
    required String? password,
  }) async {

    Response<Map<String, dynamic>> response;
    final Dio dio = Dio();
    // final String baseUrl = AppConfig.API_URL;
    try {
      response = await dio.post<Map<String, dynamic>>(
        'http://restapi.adequateshop.com/api/authaccount/login',
        data: {
          "email": email,
          "password": password
        }
      );
      final Map<String, dynamic> map =
      Map<String, dynamic>.from(response.data!);
      return LoginModel.fromJson(map);
    } catch (e) {
      rethrow;
    }
  }
}
