/// Formats elapsed time as minutes only (no seconds) — calmer in-cab UX.
String formatElapsedMinutesOnly(Duration d) {
  final totalMinutes = d.inMinutes;
  if (totalMinutes < 60) return '${totalMinutes}m';
  final h = totalMinutes ~/ 60;
  final m = totalMinutes % 60;
  return m == 0 ? '${h}h' : '${h}h ${m}m';
}

String formatTripDurationMinutes(int minutes) {
  if (minutes < 60) return '${minutes}m';
  final h = minutes ~/ 60;
  final m = minutes % 60;
  return m == 0 ? '${h}h' : '${h}h ${m}m';
}

bool tripMatchesRouteLabels({
  required String tripFrom,
  required String tripTo,
  required String planFrom,
  required String planTo,
}) {
  String norm(String s) => s.trim().toLowerCase();
  return norm(tripFrom) == norm(planFrom) && norm(tripTo) == norm(planTo);
}
