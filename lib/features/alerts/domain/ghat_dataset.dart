/// P2-002 — Static dataset of well-known Indian ghat (mountain pass) sections.
///
/// No live elevation API in Phase 2 — instead we ship a curated list of famous
/// ghats with an approximate centre point. The ghat rule checks whether the
/// active route passes within [GhatSection.radiusKm] of any centre and, if so,
/// warns the driver as they approach.
///
/// Coordinates are approximate centres of each ghat section; precision to ~1 km
/// is sufficient because [radiusKm] provides the matching tolerance.
class GhatSection {
  const GhatSection({
    required this.name,
    required this.lat,
    required this.lng,
    this.radiusKm = 8,
    this.lengthKm = 10,
  });

  final String name;
  final double lat;
  final double lng;

  /// Route must pass within this perpendicular distance (km) to count as
  /// traversing this ghat.
  final double radiusKm;

  /// Approximate length of the winding section (km) — used in the message.
  final double lengthKm;
}

/// Curated ghats. Maharashtra-heavy (the primary launch corridor region) plus
/// a few major sections elsewhere in India. Extend as coverage grows.
const kGhatSections = <GhatSection>[
  // ── Maharashtra ──────────────────────────────────────────────────────────
  GhatSection(name: 'Bhor Ghat', lat: 18.7558, lng: 73.3739, lengthKm: 10),
  GhatSection(name: 'Khandala Ghat', lat: 18.7506, lng: 73.3833, radiusKm: 6, lengthKm: 7),
  GhatSection(name: 'Kasara Ghat (Thal Ghat)', lat: 19.6333, lng: 73.4833, lengthKm: 12),
  GhatSection(name: 'Malshej Ghat', lat: 19.3419, lng: 73.7700, lengthKm: 9),
  GhatSection(name: 'Tamhini Ghat', lat: 18.4667, lng: 73.4167, lengthKm: 15),
  GhatSection(name: 'Varandha Ghat', lat: 18.0500, lng: 73.6667, lengthKm: 12),
  GhatSection(name: 'Amba Ghat', lat: 16.9667, lng: 73.8000, lengthKm: 10),
  GhatSection(name: 'Kumbharli Ghat', lat: 17.4000, lng: 73.7000, lengthKm: 12),
  GhatSection(name: 'Amboli Ghat', lat: 15.9500, lng: 74.0000, lengthKm: 10),
  // ── Karnataka ────────────────────────────────────────────────────────────
  GhatSection(name: 'Charmadi Ghat', lat: 13.0500, lng: 75.4500, lengthKm: 12),
  GhatSection(name: 'Shiradi Ghat', lat: 12.9667, lng: 75.5500, lengthKm: 14),
  GhatSection(name: 'Agumbe Ghat', lat: 13.5000, lng: 75.0833, lengthKm: 8),
  // ── Other ────────────────────────────────────────────────────────────────
  GhatSection(name: 'Nilgiri Ghat (Kallar–Coonoor)', lat: 11.3500, lng: 76.8000, lengthKm: 14),
  GhatSection(name: 'Bhimashankar Ghat', lat: 19.0700, lng: 73.5400, lengthKm: 9),
];
