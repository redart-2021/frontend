import 'dart:io';

import 'package:dio/dio.dart';
import 'package:fresh_dio/fresh_dio.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:shared_preferences/shared_preferences.dart';


class ApiException implements Exception {
  String message;
  dynamic rawData;
  Exception originalException;

  ApiException({this.message, this.rawData, this.originalException});

  @override
  String toString() => message ?? originalException?.toString();
}


class JwtTokenPair {
  String access;
  String refresh;
  DateTime accessExpire;
  DateTime refreshExpire;

  JwtTokenPair(this.access, this.refresh) {
    final accessDecoded = JwtDecoder.decode(access);
    accessExpire = DateTime.fromMillisecondsSinceEpoch(
        accessDecoded['exp'] * 1000);
    final refreshDecoded = JwtDecoder.decode(refresh);
    refreshExpire = DateTime.fromMillisecondsSinceEpoch(
        refreshDecoded['exp'] * 1000);
    // TODO: checks: type, time
  }

  OAuth2Token asOauth() => OAuth2Token(
    accessToken: access,
    refreshToken: refresh,
    expiresIn: accessExpire.millisecondsSinceEpoch ~/ 1000,
    tokenType: 'Token',
  );
}


class DelayInterceptor extends Interceptor {
  int delaySeconds;

  DelayInterceptor(this.delaySeconds);

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    await Future.delayed(Duration(seconds: delaySeconds));
    super.onRequest(options, handler);
  }
}


class HttpApiClient {
  bool fake = true;
  bool offline = true;

  final _authUrl = '/token/';
  final _refreshUrl = '/token/refresh/';

  String _scheme = 'http';
  String _host = 'localhost';
  int _port;
  int _netDelay = 0;
  Fresh<OAuth2Token> _refresher;
  DelayInterceptor _delayer;
  Dio _httpClient;

  String get scheme => _scheme;
  set scheme(String value) {
    _scheme = value;
    _setBaseUrl();
  }
  String get host => _host;
  set host(String value) {
    _host = value;
    _setBaseUrl();
  }
  int get port => _port;
  set port(int value) {
    _port = value;
    _setBaseUrl();
  }
  int get netDelay => _netDelay;
  set netDelay(int value) {
    _netDelay = value;
    _delayer.delaySeconds = netDelay;
  }

  HttpApiClient({ Dio client }) {
    _httpClient = client ?? Dio();
    _setBaseUrl();

    _refresher = Fresh.oAuth2(
      tokenStorage: InMemoryTokenStorage(),  // TODO: shared preferences
      shouldRefresh: (response) {
        return response?.requestOptions?.path != _authUrl &&
          response?.requestOptions?.path != _refreshUrl &&
          (response?.statusCode == 401 || response?.statusCode == 403);
      },
      refreshToken: (token, client) async {
        final response = await post(_refreshUrl, {'refresh': token.refreshToken});
        return JwtTokenPair(response['access'], token.refreshToken).asOauth();
      },
    );
    _delayer = DelayInterceptor(_netDelay);

    _httpClient.interceptors.addAll([
      _refresher,
      _delayer,
    ]);
  }

  void configure({
      String scheme,
      String host,
      int port,
      bool fake,
      bool offline,
      int netDelay,
  }) {
    _scheme = scheme;
    _host = host;
    _port = port;
    this.fake = fake;
    this.offline = offline;
    _netDelay = netDelay;
    _delayer.delaySeconds = netDelay;
    _setBaseUrl();
  }

  _setBaseUrl() {
    final portString = _port != null ? ':$_port' : '';
    _httpClient.options.baseUrl = '$scheme://$_host$portString/api/v1';
  }

  void authenticate(Map<String, dynamic> authData) async {
    final response = await post(_authUrl, authData);
    _refresher.setToken(JwtTokenPair(response['access'],
        response['refresh']).asOauth());
  }

  void logout() {
    _refresher.clearToken();
  }

  void storeSettings() async {
    final sp = await SharedPreferences.getInstance();
    sp..setString('apiClient:scheme', scheme)
      ..setString('apiClient:host', _host)
      ..setBool('apiClient:fake', fake)
      ..setBool('apiClient:offline', offline)
      ..setInt('apiClient:netDelay', _netDelay);

    if (_port != null) {
      sp.setInt('apiClient:port', _port);
    } else {
      sp.remove('apiClient:port');
    }
  }

  void restoreSettings() async {
    final sharedPreferences = await SharedPreferences.getInstance();
    _scheme = sharedPreferences.getString('apiClient:scheme') ?? 'https';
    _host = sharedPreferences.getString('apiClient:host') ?? '2021.jlemyp.xyz';
    _port = sharedPreferences.getInt('apiClient:port');
    fake = sharedPreferences.getBool('apiClient:fake') ?? false;
    offline = sharedPreferences.getBool('apiClient:offline') ?? false;
    _netDelay = sharedPreferences.getInt('apiClient:netDelay') ?? 0;
    _delayer.delaySeconds = _netDelay;
    _setBaseUrl();
  }

  Future<dynamic> _doRequest(Future<dynamic> Function() func) async {
    // хня по перевыбрасу ошибки
    try {
      return await func();
    } on DioError catch (error) {
      if (error.error is SocketException) {
        throw ApiException(
          message: 'сервер недоступен',
          originalException: error,
        );
      }

      if (error.response == null) {
        throw ApiException(originalException: error);
      }

      var data = error.response.data;
      var ct = error.response.headers['content-type'][0];
      if (ct == null || !ct.contains('application/json')) {
        throw ApiException(
          rawData: data,
          originalException: error,
        );
      }

      if (data is! Map) {
        throw ApiException(
          rawData: data,
          originalException: error,
        );
      }

      if (data.containsKey('detail')) {
        throw ApiException(
          message: data['detail'],
          rawData: data,
          originalException: error,
        );
      }

      if (data.containsKey('details') && data['details'][0] is String) {
        throw ApiException(
          message: (data['details'] as List<String>).join('\n'),
          rawData: data,
          originalException: error,
        );
      }

      throw ApiException(
        rawData: data,
        originalException: error,
      );
    }
  }

  Future<dynamic> get(String path, {Map<String, dynamic> params}) async {
    return await _doRequest(() async {
      final response = await _httpClient.get(path, queryParameters: params);
      return response.data;
    });
  }

  Future<dynamic> post(String path, Map<String, dynamic> data) async {
    return await _doRequest(() async {
      final response = await _httpClient.post(path, data: data);
      return response.data;
    });
  }

  Future<dynamic> patch(String path, Map<String, dynamic> data) async {
    return await _doRequest(() async {
      final response = await _httpClient.patch(path, data: data);
      return response.data;
    });
  }

  Future<dynamic> delete(String path, {Map<String, dynamic> params}) async {
    await _doRequest(() async {
      final response = await _httpClient.delete(path, queryParameters: params);
      return response.data;
    });
  }
}
