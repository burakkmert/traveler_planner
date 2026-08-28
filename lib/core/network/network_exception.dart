import 'package:dio/dio.dart';

/// Application Network Exception class encapsulating all HTTP & Network failure cases securely.
class NetworkException implements Exception {
  final String message;
  final int? statusCode;
  final NetworkExceptionType type;

  const NetworkException({
    required this.message,
    this.statusCode,
    this.type = NetworkExceptionType.unknown,
  });

  /// Factory converter mapping DioException to clean, sanitized NetworkException.
  factory NetworkException.fromDioError(DioException dioException) {
    switch (dioException.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return const NetworkException(
          message: 'Bağlantı zaman aşımına uğradı. Lütfen internetinizi kontrol edin.',
          type: NetworkExceptionType.timeout,
        );
      case DioExceptionType.connectionError:
        return const NetworkException(
          message: 'İnternet bağlantısı erişilemez durumda.',
          type: NetworkExceptionType.noInternet,
        );
      case DioExceptionType.badResponse:
        final code = dioException.response?.statusCode;
        return NetworkException(
          message: _handleStatusCode(code),
          statusCode: code,
          type: NetworkExceptionType.badResponse,
        );
      case DioExceptionType.cancel:
        return const NetworkException(
          message: 'İstek iptal edildi.',
          type: NetworkExceptionType.cancel,
        );
      default:
        return const NetworkException(
          message: 'Beklenmeyen bir ağ hatası oluştu. Lütfen daha sonra tekrar deneyin.',
          type: NetworkExceptionType.unknown,
        );
    }
  }

  /// Factory for parsing/empty payload errors.
  factory NetworkException.emptyResponse() {
    return const NetworkException(
      message: 'Sunucudan boş yanıt dönüldü.',
      type: NetworkExceptionType.emptyResponse,
    );
  }

  factory NetworkException.parseError([String? details]) {
    final sanitizedDetails = details != null ? _sanitizeErrorDetails(details) : '';
    return NetworkException(
      message: 'Veri işleme hatası (JSON Parse)${sanitizedDetails.isNotEmpty ? ': $sanitizedDetails' : ''}',
      type: NetworkExceptionType.parseError,
    );
  }

  static String _sanitizeErrorDetails(String raw) {
    // Strip file paths or IP addresses if any exist in raw details string
    var clean = raw.replaceAll(RegExp(r'[a-zA-Z]:[\\/][^\s]+'), '[PATH]');
    clean = clean.replaceAll(RegExp(r'\b\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}\b'), '[IP]');
    return clean;
  }

  static String _handleStatusCode(int? statusCode) {
    switch (statusCode) {
      case 400:
        return 'Geçersiz istek (400). Lütfen parametreleri kontrol edin.';
      case 401:
        return 'Yetkisiz erişim (401). API anahtarı geçersiz veya eksik.';
      case 403:
        return 'Erişim engellendi (403). Bu kaynağa erişim izniniz yok.';
      case 404:
        return 'İstenen kaynak bulunamadı (404).';
      case 429:
        return 'Çok fazla istek atıldı (429 Rate Limit). Lütfen bekleyin.';
      case 500:
        return 'Sunucu içi hata (500). Lütfen daha sonra tekrar deneyin.';
      case 503:
        return 'Servis kullanılamıyor (503). Sunucu bakımda olabilir.';
      default:
        return 'Sunucu hatası ($statusCode). Lütfen tekrar deneyin.';
    }
  }

  @override
  String toString() => message;
}

enum NetworkExceptionType {
  timeout,
  noInternet,
  badResponse,
  emptyResponse,
  parseError,
  cancel,
  unknown,
}
