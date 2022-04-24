import 'package:dio/dio.dart';
import 'package:ios_android_flutter/rest/model/response_token.dart';

import 'apis.dart';

part 'retrofit.g.dart';

abstract class ApiRequest {
  factory ApiRequest(Dio dio, {required String baseUrl}) = _ApiRequest;

  Future<ResponseToken> signIn(String login, String password);

  Future<ResponseToken> register(String login, String password);

  Future<bool> hasAccess(String token);
}
