import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:travel_app/core/network/network_exception.dart';

void main() {
  group('NetworkException Unit Tests', () {
    test('Empty response factory creates correct exception', () {
      final exc = NetworkException.emptyResponse();
      expect(exc.type, equals(NetworkExceptionType.emptyResponse));
      expect(exc.message, contains('boş yanıt'));
    });

    test('Parse error factory creates correct exception', () {
      final exc = NetworkException.parseError('invalid json');
      expect(exc.type, equals(NetworkExceptionType.parseError));
      expect(exc.message, contains('invalid json'));
    });

    test('Dio bad response converts status codes correctly', () {
      final dioError = DioException(
        requestOptions: RequestOptions(path: '/test'),
        response: Response(
          requestOptions: RequestOptions(path: '/test'),
          statusCode: 404,
        ),
        type: DioExceptionType.badResponse,
      );

      final exc = NetworkException.fromDioError(dioError);

      expect(exc.statusCode, equals(404));
      expect(exc.message, contains('bulunamadı'));
    });
  });
}
