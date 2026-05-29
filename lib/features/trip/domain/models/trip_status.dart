/// The lifecycle status of a road trip.
enum TripStatus {
  /// Created from a plan but not yet started.
  notStarted,

  /// User has tapped "Start trip" — navigation and alerts are live.
  active,

  /// User tapped "Pause" — tracking suspended, can be resumed.
  paused,

  /// User tapped "End trip" — final summary available.
  completed,
}
