import 'dart:io';

import 'package:dio/dio.dart';
import 'package:dio/io.dart';

typedef OnDioRequest(RequestOptions options);
typedef OnDioResponse(Response response);
typedef OnDioError(DioError e);

class HttpUtils {
  late Dio _dio;
  late BaseOptions _options;
  static HttpUtils? _instance;
  static late InterceptorsWrapper _interceptorsWrapper;
  static late LogInterceptor _logInterceptor;
  bool inProduction = const bool.fromEnvironment('dart.vm.product');
  factory HttpUtils(
          {bool needAuthor = true,
          bool needLog = true,
          OnDioRequest? onDioRequest,
          OnDioResponse? onDioResponse,
          OnDioError? onDioError}) =>
      _getInstance(
          needAuthor, needLog, onDioRequest, onDioResponse, onDioError);

  HttpUtils._internal(OnDioRequest? req, OnDioResponse? res, OnDioError? ode) {
    _options = BaseOptions(); //不可加超时，否则下载文件会失败
    _dio = Dio(_options);
    (_dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate =
        (client) {
      client.badCertificateCallback =
          (X509Certificate cert, String host, int port) {
        return true; //无条件允许https证书通行
      };
    };
    // _dio.httpClientAdapter = Http2Adapter(ConnectionManager(onClientCreate: (_, config) => config.onBadCertificate = (_) => true));
    _logInterceptor = LogInterceptor(
        request: false,
        requestHeader: false,
        requestBody: false,
        responseHeader: false,
        responseBody: !inProduction);
    _interceptorsWrapper = InterceptorsWrapper(onRequest: (options, handler) {
      // if (options.headers["Authorization"] == null) {
      //   String token = SpUtil.getString('token')!;
      //   if (token.isNotEmpty) options.headers["Authorization"] = "Bearer $token";
      // }
      if (req != null) req(options);
      return handler.next(options);
    }, onResponse: (response, handler) {
      if (res != null) res(response);
      return handler.next(response);
    }, onError: (DioError e, handler) {
      if (ode != null) ode(e);
      return handler.next(e);
    });
  }

  static HttpUtils _getInstance(bool needAuthor, bool needLog,
      OnDioRequest? opt, OnDioResponse? res, OnDioError? ode) {
    if (_instance == null) {
      _instance = HttpUtils._internal(opt, res, ode);
    }
    _instance!._dio.interceptors.clear();
    if (needLog) {
      _instance!._dio.interceptors.add(_logInterceptor);
    }
    if (needAuthor) {
      _instance!._dio.interceptors.add(_interceptorsWrapper);
    }
    return _instance!;
  }

  Future get(String path, {data, Options? options, CancelToken? cancelToken}) {
    return _dio
        .get(path, queryParameters: data, options: options)
        .then((response) {
      return response.data;
    });
  }

  Future<dynamic> post(String path,
      {data,
      Options? options,
      Map<String, dynamic>? queryParameters,
      CancelToken? cancelToken}) {
    return _dio
        .post(path,
            data: data, options: options, queryParameters: queryParameters)
        .then((response) {
      return response.data;
    });
  }

  Future<Map> put(String path,
      {data,
      Options? options,
      Map<String, dynamic>? queryParameters,
      CancelToken? cancelToken}) {
    return _dio
        .put(path,
            data: data, queryParameters: queryParameters, options: options)
        .then((response) {
      return response.data;
    });
  }

  Future<Map> delete(String path,
      {data,
      Options? options,
      Map<String, dynamic>? queryParameters,
      CancelToken? cancelToken}) {
    return _dio
        .delete(path,
            data: data, queryParameters: queryParameters, options: options)
        .then((response) {
      return response.data;
    });
  }

  Future<Response> downloadFile(String urlPath, String savePath,
      {Options? option,
      Map<String, dynamic>? queryParameters,
      ProgressCallback? onReceiveProgress}) {
    return _dio
        .download(urlPath, savePath,
            options: option,
            queryParameters: queryParameters,
            onReceiveProgress: onReceiveProgress)
        .then((response) {
      return response;
    });
  }
}
