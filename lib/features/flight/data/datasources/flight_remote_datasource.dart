import 'package:dio/dio.dart';
import '../../../../core/env/env.dart';
import '../../../../core/network/dio_client.dart';
import '../../../../core/network/network_exception.dart';
import '../../domain/models/flight_offer.dart';

abstract class FlightRemoteDataSource {
  Future<List<FlightOffer>> searchFlightOffers({
    required String originCity,
    required String destinationCity,
    required DateTime departureDate,
    DateTime? returnDate,
    required int passengerCount,
  });
}

class FlightRemoteDataSourceImpl implements FlightRemoteDataSource {
  final DioClient _dioClient;

  static const String _tokenUrl =
      'https://test.api.amadeus.com/v1/security/oauth2/token';
  static const String _flightOffersUrl =
      'https://test.api.amadeus.com/v2/shopping/flight-offers';

  String? _accessToken;
  DateTime? _tokenExpiryTime;

  FlightRemoteDataSourceImpl(this._dioClient);

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
        message: 'Amadeus Client ID / Secret tanımlanmamış.',
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
        throw NetworkException.parseError('OAuth Access token alınamadı.');
      }

      return _accessToken!;
    } on DioException catch (e) {
      throw NetworkException.fromDioError(e);
    }
  }

  @override
  Future<List<FlightOffer>> searchFlightOffers({
    required String originCity,
    required String destinationCity,
    required DateTime departureDate,
    DateTime? returnDate,
    required int passengerCount,
  }) async {
    final token = await _getAccessToken();

    final originCode = _extractIataCode(originCity);
    final destinationCode = _extractIataCode(destinationCity);
    final depDateStr =
        '${departureDate.year}-${_twoDigits(departureDate.month)}-${_twoDigits(departureDate.day)}';

    final Map<String, dynamic> queryParams = {
      'originLocationCode': originCode,
      'destinationLocationCode': destinationCode,
      'departureDate': depDateStr,
      'adults': passengerCount,
      'max': 10,
      'currencyCode': 'TRY',
    };

    if (returnDate != null) {
      queryParams['returnDate'] =
          '${returnDate.year}-${_twoDigits(returnDate.month)}-${_twoDigits(returnDate.day)}';
    }

    final response = await _dioClient.get(
      _flightOffersUrl,
      queryParameters: queryParams,
      options: Options(
        headers: {
          'Authorization': 'Bearer $token',
        },
      ),
    );

    if (response is! Map<String, dynamic>) {
      throw NetworkException.parseError('Uçuş yanıtı geçerli bir JSON objesi değil.');
    }

    final dataList = response['data'] as List<dynamic>? ?? [];
    return dataList
        .map((item) => FlightOffer.fromAmadeusJson(
              item as Map<String, dynamic>,
              originCity,
              destinationCity,
            ))
        .toList();
  }

  String _extractIataCode(String cityInput) {
    final regExp = RegExp(r'\(([A-Z]{3})\)');
    final match = regExp.firstMatch(cityInput);
    if (match != null) {
      return match.group(1)!;
    }
    final upper = cityInput.trim().toUpperCase();
    if (upper.contains('İSTANBUL') || upper.contains('ISTANBUL')) return 'IST';
    if (upper.contains('ROMA') || upper.contains('ROME')) return 'FCO';
    if (upper.contains('PARİS') || upper.contains('PARIS')) return 'CDG';
    if (upper.contains('TOKYO')) return 'HND';
    if (upper.contains('ANKARA')) return 'ESB';
    if (upper.contains('İZMİR') || upper.contains('IZMIR')) return 'ADB';
    if (upper.contains('ANTALYA')) return 'AYT';
    if (upper.contains('LONDRA') || upper.contains('LONDON')) return 'LHR';
    return 'IST'; // Default IATA fallback
  }

  String _twoDigits(int n) => n >= 10 ? '$n' : '0$n';
}
