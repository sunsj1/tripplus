/// P2-042 — Static dataset of major Indian tolled corridors.
///
/// No live toll API in Phase 2 — we ship a curated list of well-known
/// expressways with an approximate per-km rate (₹) and a small set of
/// waypoints. The toll estimator decides whether the active route follows a
/// corridor by checking how many of its waypoints lie close to the route
/// polyline; if a strong match exists we use that corridor's rate, otherwise
/// we fall back to the legacy flat `₹1.5/km`.
class TollCorridor {
  const TollCorridor({
    required this.name,
    required this.ratePerKm,
    required this.waypoints,
    this.matchRadiusKm = 12,
  });

  final String name;
  final double ratePerKm;
  final List<({double lat, double lng})> waypoints;

  /// Max perpendicular distance (km) between a waypoint and the route polyline
  /// for the waypoint to count as a "hit".
  final double matchRadiusKm;
}

/// Curated corridors. Rates are typical 2024–25 car-class single-trip rates;
/// the goal is "directionally correct", not penny-perfect.
const kTollCorridors = <TollCorridor>[
  // ── Mumbai–Pune Expressway ───────────────────────────────────────────────
  TollCorridor(
    name: 'Mumbai–Pune Expressway',
    ratePerKm: 2.6,
    waypoints: [
      (lat: 19.0410, lng: 73.0190), // Kalamboli start
      (lat: 18.9290, lng: 73.2750), // Khopoli
      (lat: 18.7508, lng: 73.3838), // Khandala
      (lat: 18.6190, lng: 73.7200), // Talegaon
      (lat: 18.5680, lng: 73.7720), // Pune end
    ],
  ),
  // ── Yamuna Expressway (Delhi NCR ↔ Agra) ─────────────────────────────────
  TollCorridor(
    name: 'Yamuna Expressway',
    ratePerKm: 2.9,
    waypoints: [
      (lat: 28.4870, lng: 77.5230), // Jewar
      (lat: 28.0670, lng: 77.7530), // Mathura belt
      (lat: 27.4030, lng: 77.9510), // Agra entry
    ],
  ),
  // ── Delhi–Meerut Expressway ──────────────────────────────────────────────
  TollCorridor(
    name: 'Delhi–Meerut Expressway',
    ratePerKm: 2.5,
    waypoints: [
      (lat: 28.6480, lng: 77.3030), // Akshardham start
      (lat: 28.7470, lng: 77.5180), // Dasna
      (lat: 28.9920, lng: 77.7060), // Meerut
    ],
  ),
  // ── Bengaluru–Mysuru Expressway ──────────────────────────────────────────
  TollCorridor(
    name: 'Bengaluru–Mysuru Expressway',
    ratePerKm: 2.3,
    waypoints: [
      (lat: 12.9120, lng: 77.5050), // Bengaluru exit
      (lat: 12.7290, lng: 77.2870), // Bidadi/Ramanagara
      (lat: 12.5430, lng: 76.8930), // Mandya belt
      (lat: 12.3050, lng: 76.6550), // Mysuru entry
    ],
  ),
  // ── Mumbai–Nagpur Samruddhi Mahamarg ─────────────────────────────────────
  TollCorridor(
    name: 'Samruddhi Mahamarg (Mumbai–Nagpur)',
    ratePerKm: 2.4,
    waypoints: [
      (lat: 19.7670, lng: 75.0830), // Aurangabad belt
      (lat: 20.3160, lng: 75.9100), // Jalna–Buldhana
      (lat: 20.7280, lng: 77.5360), // Akola–Washim
      (lat: 21.1450, lng: 79.0820), // Nagpur entry
    ],
  ),
  // ── Eastern Peripheral / Western Peripheral (Delhi bypass) ──────────────
  TollCorridor(
    name: 'Eastern/Western Peripheral Expressway',
    ratePerKm: 2.2,
    waypoints: [
      (lat: 28.9220, lng: 77.4170), // Kundli
      (lat: 28.7100, lng: 77.6750), // Ghaziabad bypass
      (lat: 28.4480, lng: 77.4080), // Palwal
    ],
  ),
  // ── Hyderabad ORR ────────────────────────────────────────────────────────
  TollCorridor(
    name: 'Hyderabad Outer Ring Road',
    ratePerKm: 2.0,
    waypoints: [
      (lat: 17.4480, lng: 78.3870), // Gachibowli
      (lat: 17.2580, lng: 78.3470), // Shamshabad
      (lat: 17.2470, lng: 78.5840), // Pedda Amberpet
      (lat: 17.5260, lng: 78.6620), // Ghatkesar
    ],
  ),
];
