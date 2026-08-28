import '../models/search_params.dart';

/// Validation result data structure containing validation status and optional error message.
class SearchValidationResult {
  final bool isValid;
  final String? errorMessage;
  final String? fieldKey; // Indicates which specific field triggered the error

  const SearchValidationResult.success()
      : isValid = true,
        errorMessage = null,
        fieldKey = null;

  const SearchValidationResult.failure(this.errorMessage, {this.fieldKey})
      : isValid = false;
}

/// Pure Domain Validator for Travel Search parameters with Input Sanitization.
class SearchValidator {
  SearchValidator._();

  /// Sanitizes text inputs by stripping HTML tags, control characters, and trimming length.
  static String sanitizeInput(String rawInput) {
    if (rawInput.isEmpty) return '';

    // 1. Remove control characters (\x00-\x1F, \x7F)
    var cleaned = rawInput.replaceAll(RegExp(r'[\x00-\x1F\x7F]'), '');

    // 2. Strip potential HTML tags
    cleaned = cleaned.replaceAll(RegExp(r'<[^>]*>'), '');

    // 3. Trim length (Max 100 chars to prevent memory overload)
    if (cleaned.length > 100) {
      cleaned = cleaned.substring(0, 100);
    }

    return cleaned.trim();
  }

  static SearchValidationResult validate(SearchParams params) {
    // 1. Origin check & sanitization
    final originTrimmed = params.origin.trim();
    if (originTrimmed.isEmpty) {
      return const SearchValidationResult.failure(
        'Kalkış noktası boş bırakılamaz.',
        fieldKey: 'origin',
      );
    }

    final originCleaned = sanitizeInput(params.origin);
    if (originCleaned.isEmpty) {
      return const SearchValidationResult.failure(
        'Kalkış noktası geçersiz karakterler içeriyor.',
        fieldKey: 'origin',
      );
    }

    // 2. Destination check & sanitization
    final destinationTrimmed = params.destination.trim();
    if (destinationTrimmed.isEmpty) {
      return const SearchValidationResult.failure(
        'Varış noktası boş bırakılamaz.',
        fieldKey: 'destination',
      );
    }

    final destinationCleaned = sanitizeInput(params.destination);
    if (destinationCleaned.isEmpty) {
      return const SearchValidationResult.failure(
        'Varış noktası geçersiz karakterler içeriyor.',
        fieldKey: 'destination',
      );
    }

    // 3. Origin & Destination equality check
    if (originCleaned.toLowerCase() == destinationCleaned.toLowerCase()) {
      return const SearchValidationResult.failure(
        'Kalkış ve varış noktası aynı olamaz.',
        fieldKey: 'destination',
      );
    }

    // 4. Start Date check
    if (params.startDate == null) {
      return const SearchValidationResult.failure(
        'Başlangıç tarihi seçilmelidir.',
        fieldKey: 'startDate',
      );
    }

    final now = DateTime.now();
    final todayMidnight = DateTime(now.year, now.month, now.day);
    final startMidnight = DateTime(
      params.startDate!.year,
      params.startDate!.month,
      params.startDate!.day,
    );

    if (startMidnight.isBefore(todayMidnight)) {
      return const SearchValidationResult.failure(
        'Başlangıç tarihi geçmiş bir tarih olamaz.',
        fieldKey: 'startDate',
      );
    }

    // 5. End Date check
    if (params.endDate == null) {
      return const SearchValidationResult.failure(
        'Dönüş tarihi seçilmelidir.',
        fieldKey: 'endDate',
      );
    }

    final endMidnight = DateTime(
      params.endDate!.year,
      params.endDate!.month,
      params.endDate!.day,
    );

    if (endMidnight.isBefore(startMidnight)) {
      return const SearchValidationResult.failure(
        'Dönüş tarihi başlangıç tarihinden önce olamaz.',
        fieldKey: 'endDate',
      );
    }

    // 6. Passenger Count check
    if (params.passengerCount < 1 || params.passengerCount > 9) {
      return const SearchValidationResult.failure(
        'Yolcu sayısı 1 ile 9 kişi arasında olmalıdır.',
        fieldKey: 'passengerCount',
      );
    }

    return const SearchValidationResult.success();
  }
}
