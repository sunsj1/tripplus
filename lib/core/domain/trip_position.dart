import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:geolocator/geolocator.dart';
import 'package:journeyplus/core/utils/polyline_decoder.dart';

part 'trip_position.freezed.dart';

/// Immutable, watchable GPS snapshot shared by trip-time features.
///
/// Keeping the plugin's [Position] behind this boundary lets alerts, corridor
/// lists, and UI react to one stable source without depending on Geolocator.
@freezed
abstract class TripPosition with _$TripPosition {
  const TripPosition._();

  const factory TripPosition({
    required double latitude,
    required double longitude,
    required double accuracyMeters,
    required DateTime capturedAt,
    @Default(0) double speedMetersPerSecond,
    @Default(0) double headingDegrees,
  }) = _TripPosition;

  factory TripPosition.fromGeolocator(Position position) => TripPosition(
    latitude: position.latitude,
    longitude: position.longitude,
    accuracyMeters: position.accuracy,
    capturedAt: position.timestamp,
    speedMetersPerSecond: position.speed,
    headingDegrees: position.heading,
  );

  LatLng get latLng => LatLng(latitude, longitude);
}
