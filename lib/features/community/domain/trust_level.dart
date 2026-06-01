/// P2-030 — Coarse trust tier derived from the numeric reliability score and
/// the number of contributing reports. Drives consistent badge colours/labels
/// across tiles, detail sheets, and source badges.
enum TrustLevel {
  /// Strong, fresh, consistent signal.
  high,

  /// Decent signal but with caveats (mixed or ageing).
  medium,

  /// Weak or contradictory signal.
  low,

  /// Not enough data to judge.
  unknown;

  /// Maps a `0–100` reliability score + report count to a tier.
  factory TrustLevel.fromScore(int score, int reportCount) {
    if (reportCount == 0) return TrustLevel.unknown;
    if (reportCount < 2) return TrustLevel.low;
    if (score >= 75) return TrustLevel.high;
    if (score >= 45) return TrustLevel.medium;
    return TrustLevel.low;
  }

  String get label {
    switch (this) {
      case TrustLevel.high:
        return 'Trusted';
      case TrustLevel.medium:
        return 'Mixed';
      case TrustLevel.low:
        return 'Low trust';
      case TrustLevel.unknown:
        return 'Unrated';
    }
  }
}
