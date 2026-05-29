import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:tripplus/features/trip/domain/models/trip.dart';

part 'active_trip_state.freezed.dart';

/// UI state emitted by [ActiveTripController].
@freezed
sealed class ActiveTripState with _$ActiveTripState {
  /// No trip in progress (or no trip persisted in Hive).
  const factory ActiveTripState.idle() = ActiveTripIdle;

  /// A trip has been created but "Start" has not been tapped yet.
  const factory ActiveTripState.ready({required Trip trip}) = ActiveTripReady;

  /// Tracking is live — user tapped "Start trip".
  const factory ActiveTripState.running({required Trip trip}) =
      ActiveTripRunning;

  /// Tracking paused — user tapped "Pause".
  const factory ActiveTripState.paused({required Trip trip}) = ActiveTripPaused;

  /// Trip finished — user tapped "End trip".
  const factory ActiveTripState.completed({required Trip trip}) =
      ActiveTripCompleted;
}

extension ActiveTripStateX on ActiveTripState {
  /// True when there is any in-flight trip (ready, running, or paused).
  bool get hasTrip => this is! ActiveTripIdle;

  /// Extracts the trip regardless of sub-state. Returns null for [idle].
  Trip? get trip => switch (this) {
        ActiveTripIdle() => null,
        ActiveTripReady(:final trip) => trip,
        ActiveTripRunning(:final trip) => trip,
        ActiveTripPaused(:final trip) => trip,
        ActiveTripCompleted(:final trip) => trip,
      };
}
