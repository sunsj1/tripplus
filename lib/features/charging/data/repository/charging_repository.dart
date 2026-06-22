import 'package:dio/dio.dart';
import 'package:logger/logger.dart';
import 'package:journeyplus/core/constants/api_constants.dart';
import 'package:journeyplus/core/utils/result.dart';
import 'package:journeyplus/features/charging/data/dto/charging_dto.dart';
import 'package:journeyplus/features/charging/data/dto/charging_mapper.dart';
import 'package:journeyplus/features/charging/data/local_db/charging_local_db.dart';
import 'package:journeyplus/features/charging/domain/models/charging_station.dart';

class ChargingRepository {
  final Dio _dio;
  final ChargingLocalDb _localDb;
  final _logger = Logger();

  ChargingRepository({required Dio dio, required ChargingLocalDb localDb})
    : _dio = dio,
      _localDb = localDb;

  Future<Result<List<ChargingStation>>> getChargingStations({
    required double latitude,
    required double longitude,
    double? radiusKm,
    int? maxResults,
  }) async {
    final radius = radiusKm ?? ApiConstants.defaultRadiusKm;
    final limit = maxResults ?? ApiConstants.defaultMaxResults;

    // Only use cache for default (current-location) queries
    if (radiusKm == null && _localDb.isCacheValid(latitude, longitude)) {
      final cached = _localDb.getStations();
      if (cached != null && cached.isNotEmpty) {
        _logger.i('Returning ${cached.length} stations from cache');
        return Result.success(cached);
      }
    }

    return _fetchFromApi(
      latitude: latitude,
      longitude: longitude,
      radiusKm: radius,
      maxResults: limit,
    );
  }

  Future<Result<List<ChargingStation>>> _fetchFromApi({
    required double latitude,
    required double longitude,
    double radiusKm = 100,
    int maxResults = 50,
  }) async {
    final key = ApiConstants.openChargeMapApiKey.trim();
    if (key.isEmpty) {
      return const Result.failure(
        'Open Charge Map API key is missing. Set OPEN_CHARGE_MAP_API_KEY in .env.',
      );
    }

    try {
      _logger.i('Fetching stations from Open Charge Map API v3...');

      Response<dynamic> response;
      try {
        response = await _getPoiWithRetries(
          latitude: latitude,
          longitude: longitude,
          radiusKm: radiusKm,
          maxResults: maxResults,
          compact: false,
          verbose: true,
        );
      } on DioException catch (e) {
        final code = e.response?.statusCode;
        if (code == 503 || code == 502) {
          _logger.w(
            'Full POI payload failed ($code), retrying with compact mode...',
          );
          response = await _getPoiWithRetries(
            latitude: latitude,
            longitude: longitude,
            radiusKm: radiusKm,
            maxResults: maxResults,
            compact: true,
            verbose: false,
          );
        } else {
          rethrow;
        }
      }

      if (response.data == null || response.data is! List) {
        _logger.w('Unexpected POI shape, trying compact mode...');
        response = await _getPoiWithRetries(
          latitude: latitude,
          longitude: longitude,
          radiusKm: radiusKm,
          maxResults: maxResults,
          compact: true,
          verbose: false,
        );
      }

      if (response.data == null || response.data is! List) {
        return const Result.failure('Invalid response from server.');
      }

      final List<dynamic> rawList = response.data as List<dynamic>;
      if (rawList.isEmpty) {
        return const Result.failure('No charging stations found nearby.');
      }

      final dtos = rawList
          .map((item) => ChargingDto.fromJson(item as Map<String, dynamic>))
          .toList();

      final stations = ChargingMapper.fromDtoList(dtos);

      await _localDb.saveStations(
        stations: stations,
        latitude: latitude,
        longitude: longitude,
      );

      _logger.i('Fetched and cached ${stations.length} stations');
      return Result.success(stations);
    } on DioException catch (e) {
      _logger.e('API error: ${e.message}');
      final cached = _localDb.getStations();
      if (cached != null && cached.isNotEmpty) {
        _logger.w('Returning stale cache as fallback');
        return Result.success(cached);
      }
      return Result.failure(_mapDioError(e));
    } catch (e) {
      _logger.e('Unexpected error: $e');
      return Result.failure('Something went wrong. Please try again.');
    }
  }

  /// OCM fair-use: avoid hammering; retry only on transient 502/503/429.
  Future<Response<dynamic>> _getPoiWithRetries({
    required double latitude,
    required double longitude,
    required bool compact,
    required bool verbose,
    double radiusKm = 100,
    int maxResults = 50,
  }) async {
    const maxAttempts = 3;
    var delay = const Duration(seconds: 1);
    DioException? lastException;

    for (var attempt = 0; attempt < maxAttempts; attempt++) {
      try {
        return await _dio.get<dynamic>(
          '/poi',
          options: Options(
            headers: {'X-API-Key': ApiConstants.openChargeMapApiKey.trim()},
          ),
          queryParameters: _poiQuery(
            latitude: latitude,
            longitude: longitude,
            compact: compact,
            verbose: verbose,
            radiusKm: radiusKm,
            maxResults: maxResults,
          ),
        );
      } on DioException catch (e) {
        lastException = e;
        final code = e.response?.statusCode;
        final retryable =
            code == 503 ||
            code == 502 ||
            code == 429 ||
            e.type == DioExceptionType.connectionError;

        if (retryable && attempt < maxAttempts - 1) {
          _logger.w(
            'Open Charge Map unavailable (${code ?? e.type}), '
            'retry ${attempt + 2}/$maxAttempts in ${delay.inSeconds}s',
          );
          await Future<void>.delayed(delay);
          delay = Duration(seconds: delay.inSeconds * 2);
          continue;
        }
        rethrow;
      }
    }

    throw lastException!;
  }

  Map<String, dynamic> _poiQuery({
    required double latitude,
    required double longitude,
    required bool compact,
    required bool verbose,
    double radiusKm = 100,
    int maxResults = 50,
  }) {
    final key = ApiConstants.openChargeMapApiKey.trim();
    return {
      'client': 'journeyplus',
      'output': 'json',
      'key': key,
      'latitude': latitude,
      'longitude': longitude,
      'distance': radiusKm,
      'distanceunit': 'km',
      'maxresults': maxResults,
      'compact': compact,
      'verbose': verbose,
    };
  }

  String _mapDioError(DioException e) {
    final code = e.response?.statusCode;
    if (code == 503 || code == 502) {
      return 'Charging data is temporarily unavailable. Please try again in a moment.';
    }
    if (code == 429) {
      return 'Too many requests. Wait a minute and try again.';
    }
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.receiveTimeout:
      case DioExceptionType.sendTimeout:
        return 'Connection timed out. Check your internet.';
      case DioExceptionType.connectionError:
        return 'No internet connection.';
      case DioExceptionType.badResponse:
        return 'Server error (${e.response?.statusCode}).';
      default:
        return 'Network error. Please try again.';
    }
  }
}
