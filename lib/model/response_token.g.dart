part of 'response_token.dart';

ResponseToken _$ResponseTokenFromJson(Map<String, dynamic> json) {
  return ResponseToken(token: json['token'] as String);
}
