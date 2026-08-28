import 'package:dio/dio.dart';
import 'network_exception.dart';

/// Centralized HTTP Network Client wrapping Dio instance.
class DioClient {
  final Dio _dio;

  DioClient({Dio? dio})
      : _dio = dio ??
            Dio(
              BaseOptions(
                connectTimeout: const Duration(seconds: 10),
                receiveTimeout: const Duration(seconds: 10),
                sendTimeout: const Duration(seconds: 10),
                headers: {
                  'Content-Type': 'application/json',
                  'Accept': 'application/json',
                },
              ),
            ) {
    _dio.interceptors.add(
      LogInterceptor(
        request: true,
        requestHeader: false,
        requestBody: false,
        responseHeader: false,
        responseBody: false,
        error: true,
      ),
    );
  }

  /// Performs an HTTP GET request with error handling and empty payload checks.
  Future<dynamic> get(
    String url, {
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    try {
      final response = await _dio.get(
        url,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      );

      return _verifyAndReturnBody(response);
    } on DioException catch (e) {
      throw NetworkException.fromDioError(e);
    } catch (e) {
      if (e is NetworkException) rethrow;
      throw NetworkException.parseError(e.toString());
    }
  }

  /// Performs an HTTP POST request.
  Future<dynamic> post(
    String url, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    try {
      final response = await _dio.post(
        url,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      );

      return _verifyAndReturnBody(response);
    } on DioException catch (e) {
      throw NetworkException.fromDioError(e);
    } catch (e) {
      if (e is NetworkException) rethrow;
      throw NetworkException.parseError(e.toString());
    }
  }

  dynamic _verifyAndReturnBody(Response response) {
    if (response.statusCode == null ||
        response.statusCode! < 200 ||
        response.statusCode! >= 300) {
      throw NetworkException(
        message: 'HTTP İstek Başarısız: Status ${response.statusCode}',
        statusCode: response.statusCode,
      );
    }

    if (response.data == null) {
      throw NetworkException.emptyResponse();
    }

    return response.data;
  }
}
