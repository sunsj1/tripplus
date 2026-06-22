import 'package:dio/dio.dart';
import 'package:logger/logger.dart';
import 'package:journeyplus/core/constants/api_constants.dart';

class PlacePrediction {
  final String placeId;
  final String description;
  final String mainText;
  final String secondaryText;

  const PlacePrediction({
    required this.placeId,
    required this.description,
    required this.mainText,
    required this.secondaryText,
  });
}

class PlacesAutocompleteService {
  final Dio _dio;
  final _logger = Logger();

  PlacesAutocompleteService(this._dio);

  Future<List<PlacePrediction>> getSuggestions(String input) async {
    if (input.trim().length < 2) return [];

    if (ApiConstants.isGoogleMapsKeyConfigured) {
      return _googleAutocomplete(input);
    }
    return _nominatimSearch(input);
  }

  Future<List<PlacePrediction>> _googleAutocomplete(String input) async {
    try {
      final response = await _dio.get(
        'https://maps.googleapis.com/maps/api/place/autocomplete/json',
        queryParameters: {
          'input': input,
          'key': ApiConstants.googleMapsApiKey,
          'types': 'geocode|establishment',
          'components': 'country:in',
        },
      );

      final data = response.data;
      if (data['status'] != 'OK' && data['status'] != 'ZERO_RESULTS') {
        _logger.w('Places API status: ${data['status']}');
        return _nominatimSearch(input);
      }

      final predictions = data['predictions'] as List? ?? [];
      return predictions.map<PlacePrediction>((p) {
        final structured = p['structured_formatting'] ?? {};
        return PlacePrediction(
          placeId: p['place_id'] ?? '',
          description: p['description'] ?? '',
          mainText: structured['main_text'] ?? p['description'] ?? '',
          secondaryText: structured['secondary_text'] ?? '',
        );
      }).toList();
    } catch (e) {
      _logger.w('Google Places failed: $e, falling back to Nominatim');
      return _nominatimSearch(input);
    }
  }

  Future<List<PlacePrediction>> _nominatimSearch(String input) async {
    try {
      final response = await _dio.get(
        'https://nominatim.openstreetmap.org/search',
        queryParameters: {
          'q': input,
          'format': 'json',
          'addressdetails': 1,
          'limit': 5,
          'countrycodes': 'in',
        },
        options: Options(
          headers: {'User-Agent': 'JourneyPlus/1.0'},
        ),
      );

      final results = response.data as List? ?? [];
      return results.map<PlacePrediction>((r) {
        final display = r['display_name'] as String? ?? '';
        final parts = display.split(',');
        final main = parts.isNotEmpty ? parts.first.trim() : display;
        final secondary =
            parts.length > 1 ? parts.sublist(1, 3.clamp(0, parts.length)).join(',').trim() : '';

        return PlacePrediction(
          placeId: r['place_id']?.toString() ?? '',
          description: display,
          mainText: main,
          secondaryText: secondary,
        );
      }).toList();
    } catch (e) {
      _logger.e('Nominatim search failed: $e');
      return [];
    }
  }
}
