import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:journeyplus/features/trip/presentation/controller/active_trip_controller.dart';

/// Starts a trip only after location prerequisites are satisfied and explains
/// the iOS Always upgrade needed for the strongest locked-screen reliability.
Future<void> startTripWithLocation(
  BuildContext context,
  ActiveTripController controller,
) async {
  final outcome = await controller.startTrip();
  if (!context.mounted || outcome == TripStartOutcome.started) return;

  switch (outcome) {
    case TripStartOutcome.started:
      return;
    case TripStartOutcome.startedBackgroundLimited:
      await _showSettingsDialog(
        context,
        title: 'Keep trip alerts active',
        message:
            'JourneyPlus can track this trip with “While Using the App”. '
            'For the most reliable alerts when your iPhone is locked, open '
            'Settings and change Location to “Always”.',
        openSettings: Geolocator.openAppSettings,
      );
    case TripStartOutcome.locationDenied:
      await _showSettingsDialog(
        context,
        title: 'Location is required',
        message:
            'Allow location to calculate what is ahead and deliver trip '
            'alerts. JourneyPlus tracks only while a trip is running.',
        openSettings: Geolocator.openAppSettings,
      );
    case TripStartOutcome.locationDeniedForever:
      await _showSettingsDialog(
        context,
        title: 'Enable location in Settings',
        message:
            'Location permission is blocked. Open Settings and allow location '
            'so JourneyPlus can track this trip.',
        openSettings: Geolocator.openAppSettings,
      );
    case TripStartOutcome.locationServicesDisabled:
      await _showSettingsDialog(
        context,
        title: 'Turn on Location Services',
        message:
            'Your phone’s Location Services are off. Turn them on before '
            'starting the trip.',
        openSettings: Geolocator.openLocationSettings,
      );
  }
}

Future<void> _showSettingsDialog(
  BuildContext context, {
  required String title,
  required String message,
  required Future<bool> Function() openSettings,
}) {
  return showDialog<void>(
    context: context,
    builder: (dialogContext) => AlertDialog(
      title: Text(title),
      content: Text(message),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(dialogContext).pop(),
          child: const Text('Not now'),
        ),
        FilledButton(
          onPressed: () {
            Navigator.of(dialogContext).pop();
            openSettings();
          },
          child: const Text('Open Settings'),
        ),
      ],
    ),
  );
}
