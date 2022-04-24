part of 'retrofit.dart';

class _ApiRequest implements ApiRequest {
  _ApiRequest(this._dio, {required this.baseUrl}) {
    ArgumentError.checkNotNull(_dio, '_dio');
  }

  final Dio _dio;

  String baseUrl;

  @override
  signIn(String login, String password) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _data = <String, dynamic>{};
    _data.putIfAbsent("login", () => login);
    _data.putIfAbsent("password", () => password);
    var options=Options(
      receiveTimeout: 1000,sendTimeout: 1000,
      method: 'POST',
      headers: <String, dynamic>{},
      extra: _extra,
    );
    final _result = await _dio.request('$baseUrl${Apis.signIn}',
        queryParameters: queryParameters,
        options: options,
        data: _data);
    final value = ResponseToken.fromJson(_result.data);
    return value;
  }

  @override
  register(String login, String password) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _data = <String, dynamic>{};
    _data.putIfAbsent("login", () => login);
    _data.putIfAbsent("password", () => password);
    var options=Options(
      receiveTimeout: 1000,sendTimeout: 1000,
      method: 'POST',
      headers: <String, dynamic>{},
      extra: _extra,
    );
    final _result = await _dio.request('$baseUrl${Apis.register}',
        queryParameters: queryParameters,
        options: options,
        data: _data);
    final value = ResponseToken.fromJson(_result.data);
    return value;
  }

  @override
  hasAccess(String token) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _data = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    _headers.putIfAbsent("Authorization", () => "Bearer $token");
    var options=Options(
      receiveTimeout: 1000,sendTimeout: 1000,
      method: 'GET',
      headers: _headers,
      extra: _extra,
    );
    final _result = await _dio.request('$baseUrl${Apis.hasAccess}',
        queryParameters: queryParameters,
        options: options,
        data: _data);
    return _result.data;
  }

}