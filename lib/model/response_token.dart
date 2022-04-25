import 'package:json_annotation/json_annotation.dart';

part 'response_token.g.dart';

@JsonSerializable()
class ResponseToken {
  late String token;

  ResponseToken({required this.token});

  factory ResponseToken.fromJson(Map<String, dynamic> json) =>
      _$ResponseTokenFromJson(json);
}
