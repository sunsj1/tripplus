import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:journeyplus/core/utils/polyline_decoder.dart';

part 'route_option.freezed.dart';

/// One driving alternative between origin and destination (Google Maps style).
@freezed
abstract class RouteOption with _$RouteOption {
  const factory RouteOption({
    required String id,
    required String summary,
    required double distanceKm,
    required int durationMinutes,
    int? durationInTrafficMinutes,
    required String encodedPolyline,
    @Default(<LatLng>[]) List<LatLng> polylinePoints,
    @Default(false) bool hasTolls,
    @Default(false) bool isSuggested,
  }) = _RouteOption;

  const RouteOption._();

  int get effectiveDurationMinutes =>
      durationInTrafficMinutes ?? durationMinutes;
}
