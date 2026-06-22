import 'package:journeyplus/features/trip/domain/models/trip.dart';

/// P2-052 — Builds the plain-text payload for sharing a trip.
///
/// We have no backend yet so there's no shareable URL — but a clean text
/// summary + a Google Maps directions URL is enough to drop in WhatsApp, SMS,
/// or notes. Keep this pure and testable: no `share_plus` import here.
String buildTripShareText(Trip trip) {
  final buf = StringBuffer()
    ..writeln('🚗 ${trip.from} → ${trip.to}')
    ..writeln('${trip.totalDistanceKm.round()} km · ${_etaPhrase(trip)}');

  final cost = _costLine(trip);
  if (cost != null) buf.writeln(cost);
  if (trip.tollsEstimate != null) {
    buf.writeln('Tolls ~₹${trip.tollsEstimate!.round()}');
  }

  buf
    ..writeln()
    ..writeln(_mapsUrl(trip))
    ..writeln()
    ..write('Planned with JourneyPlus');
  return buf.toString();
}

String _etaPhrase(Trip trip) {
  final mins = trip.etaMinutes ?? trip.drivingMinutes;
  if (mins <= 0) return 'ETA unknown';
  if (mins < 60) return 'ETA ~${mins}m';
  final h = mins ~/ 60;
  final m = mins % 60;
  return m == 0 ? 'ETA ~${h}h' : 'ETA ~${h}h ${m}m';
}

String? _costLine(Trip trip) {
  final cost = trip.tripCostEstimate;
  if (cost == null) return null;
  final label = trip.isCostCharging ? 'Charging' : 'Fuel';
  return '$label ~₹${cost.round()}';
}

/// Google Maps directions URL — works without a key, opens natively when the
/// recipient taps it from any chat app.
String _mapsUrl(Trip trip) {
  final from = Uri.encodeComponent(trip.from);
  final to = Uri.encodeComponent(trip.to);
  return 'https://www.google.com/maps/dir/?api=1'
      '&origin=$from&destination=$to&travelmode=driving';
}
