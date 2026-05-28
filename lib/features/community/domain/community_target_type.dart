/// What kind of entity a community pulse is attached to.
///
/// Phase 1 only has `station` (EV charging stations). `poi` is the generic
/// target used once we generalize pulses to any [PoiCategory] in Phase 1
/// (`P1-050`) and onwards. Stored as the string in [wireValue].
enum CommunityTargetType { station, poi }

extension CommunityTargetTypeX on CommunityTargetType {
  String get wireValue {
    switch (this) {
      case CommunityTargetType.station:
        return 'station';
      case CommunityTargetType.poi:
        return 'poi';
    }
  }

  static CommunityTargetType fromWire(String? raw) {
    switch (raw) {
      case 'poi':
        return CommunityTargetType.poi;
      case 'station':
      default:
        return CommunityTargetType.station;
    }
  }
}
