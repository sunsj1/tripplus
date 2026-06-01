// P2-030 — Shared interpretation of community-report `condition` strings.
//
// Two vocabularies exist in the wild:
// - EV station reports: `working` / `issues` / `down`
// - Generic POI reports: `good` / `fair` / `poor`
//
// Before P2-030 the reliability math only understood the EV vocabulary, so a
// `poor` POI report scored the same as a `good` one. These helpers normalize
// both so trust signals work for every POI type.

/// Normalized quality in `[0,1]` for a condition string. Unknown → neutral 0.7.
double conditionQuality(String condition) {
  switch (condition) {
    case 'down':
    case 'poor':
      return 0.2;
    case 'issues':
    case 'fair':
      return 0.55;
    case 'working':
    case 'good':
      return 0.9;
    default:
      return 0.7;
  }
}

/// True for conditions that signal a bad experience.
bool isNegativeCondition(String condition) =>
    condition == 'down' || condition == 'poor';

/// True for conditions that signal a good experience.
bool isPositiveCondition(String condition) =>
    condition == 'working' || condition == 'good';
