import 'package:dio/dio.dart';
import '../../../../core/env/env.dart';
import '../../../../core/network/dio_client.dart';
import '../../../../core/network/network_exception.dart';
import '../../domain/models/hotel_offer.dart';

abstract class HotelRemoteDataSource {
  Future<List<HotelOffer>> searchHotels({
    required String destinationCity,
    required DateTime checkInDate,
    required DateTime checkOutDate,
    required int passengerCount,
  });
}

class HotelRemoteDataSourceImpl implements HotelRemoteDataSource {
  final DioClient _dioClient;

  static const String _tokenUrl =
      'https://test.api.amadeus.com/v1/security/oauth2/token';
  static const String _cityHotelsUrl =
      'https://test.api.amadeus.com/v1/reference-data/locations/hotels/by-city';
  static const String _hotelOffersUrl =
      'https://test.api.amadeus.com/v3/shopping/hotel-offers';

  String? _accessToken;
  DateTime? _tokenExpiryTime;

  HotelRemoteDataSourceImpl(this._dioClient);

  Future<String> _getAccessToken() async {
    if (_accessToken != null &&
        _tokenExpiryTime != null &&
        DateTime.now().isBefore(_tokenExpiryTime!)) {
      return _accessToken!;
    }

    final clientId = Env.amadeusClientId;
    final clientSecret = Env.amadeusClientSecret;

    if (clientId.isEmpty || clientSecret.isEmpty) {
      throw const NetworkException(
        message: 'Amadeus API anahtarları tanımlanmamış.',
        type: NetworkExceptionType.badResponse,
      );
    }

    final dio = Dio();
    try {
      final response = await dio.post(
        _tokenUrl,
        data: {
          'grant_type': 'client_credentials',
          'client_id': clientId,
          'client_secret': clientSecret,
        },
        options: Options(
          contentType: Headers.formUrlEncodedContentType,
        ),
      );

      final data = response.data as Map<String, dynamic>;
      _accessToken = data['access_token'] as String?;
      final expiresIn = (data['expires_in'] as num?)?.toInt() ?? 1799;
      _tokenExpiryTime =
          DateTime.now().add(Duration(seconds: expiresIn - 60));

      if (_accessToken == null) {
        throw NetworkException.parseError('OAuth Access Token alınamadı.');
      }

      return _accessToken!;
    } on DioException catch (e) {
      throw NetworkException.fromDioError(e);
    }
  }

  @override
  Future<List<HotelOffer>> searchHotels({
    required String destinationCity,
    required DateTime checkInDate,
    required DateTime checkOutDate,
    required int passengerCount,
  }) async {
    final token = await _getAccessToken();
    final cityCode = _extractCityCode(destinationCity);

    final checkInStr =
        '${checkInDate.year}-${_twoDigits(checkInDate.month)}-${_twoDigits(checkInDate.day)}';
    final checkOutStr =
        '${checkOutDate.year}-${_twoDigits(checkOutDate.month)}-${_twoDigits(checkOutDate.day)}';

    // Step 1: Fetch Hotel IDs by City Code
    final cityHotelsResponse = await _dioClient.get(
      _cityHotelsUrl,
      queryParameters: {
        'cityCode': cityCode,
      },
      options: Options(
        headers: {
          'Authorization': 'Bearer $token',
        },
      ),
    );

    if (cityHotelsResponse is! Map<String, dynamic>) {
      throw NetworkException.parseError('Şehir otelleri yanıtı geçersiz.');
    }

    final dataList = cityHotelsResponse['data'] as List<dynamic>? ?? [];
    if (dataList.isEmpty) {
      return [];
    }

    final hotelIds = dataList
        .take(5)
        .map((h) => (h as Map<String, dynamic>)['hotelId']?.toString())
        .whereType<String>()
        .join(',');

    if (hotelIds.isEmpty) return [];

    // Step 2: Fetch Hotel Offers by Hotel IDs
    final offersResponse = await _dioClient.get(
      _hotelOffersUrl,
      queryParameters: {
        'hotelIds': hotelIds,
        'checkInDate': checkInStr,
        'checkOutDate': checkOutStr,
        'adults': passengerCount,
        'currency': 'TRY',
      },
      options: Options(
        headers: {
          'Authorization': 'Bearer $token',
        },
      ),
    );

    if (offersResponse is! Map<String, dynamic>) {
      throw NetworkException.parseError('Otel teklifleri yanıtı geçersiz.');
    }

    final offersList = offersResponse['data'] as List<dynamic>? ?? [];
    return offersList
        .map((item) => HotelOffer.fromAmadeusJson(
              item as Map<String, dynamic>,
              destinationCity,
            ))
        .toList();
  }

  String _extractCityCode(String cityInput) {
    final upper = cityInput.trim().toUpperCase();
    if (upper.contains('ROMA') || upper.contains('ROME') || upper.contains('FCO')) {
      return 'ROM';
    }
    if (upper.contains('PARİS') || upper.contains('PARIS') || upper.contains('CDG')) {
      return 'PAR';
    }
    if (upper.contains('İSTANBUL') || upper.contains('ISTANBUL') || upper.contains('IST')) {
      return 'IST';
    }
    if (upper.contains('TOKYO') || upper.contains('HND')) return 'TYO';
    if (upper.contains('ANKARA') || upper.contains('ESB')) return 'ANK';
    if (upper.contains('ANTALYA') || upper.contains('AYT')) return 'AYT';
    if (upper.contains('LONDRA') || upper.contains('LONDON') || upper.contains('LHR')) {
      return 'LON';
    }
    return 'ROM';
  }

  String _twoDigits(int n) => n >= 10 ? '$n' : '0$n';
}
