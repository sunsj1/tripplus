# Phase 1 — Smart Highway Companion MVP

**Goal:** Transform the existing EV-charging assistant into the **Smart Highway Companion** MVP from the PDF — multi-vehicle, route-aware POI discovery, smart intelligence grid, distance-based alerts, generalized community pulses.

**Target duration:** 4–6 focused weeks.
**Definition of done:** A user can plan Pune → Nashik in any vehicle, pick preferences, see route-aware POIs across all grid categories, and receive at least 3 categories of distance-based alerts during the trip.

> Track each task by its **ID** (e.g. `P1-007`). When done, report the ID and I'll update `tasks.csv` and `notion_tracker.md`.

---

## 1.1 Branding & product identity

| ID | Task | Priority | Est. | Depends on | Status |
|---|---|---|---|---|---|
| `P1-001` | Update `pubspec.yaml` description: `"EV Charging Station Assistant"` → `"AI Highway Companion for Indian road trips"` | P0 | 15m | — | ⬜ |
| `P1-002` | Update `MaterialApp.title` in `lib/main.dart` to match new positioning | P0 | 5m | `P1-001` | ⬜ |
| `P1-029` | Replace default Flutter `README.md` with product README (positioning, screenshots placeholder, build steps) | P1 | 1h | `P1-001` | ⬜ |
| `P1-030` | Launch icon + splash for new brand identity (placeholder assets are fine for MVP) | P2 | 2h | — | ⬜ |

---

## 1.2 Vehicle profile & user preferences

| ID | Task | Priority | Est. | Depends on | Status |
|---|---|---|---|---|---|
| `P1-003` | Create `lib/core/domain/vehicle.dart` — `VehicleType` enum (`petrol`, `diesel`, `ev`, `bike`) + `Vehicle` freezed entity (type, fuelEfficiencyKmpl?, batteryKwh?, connectorTypes?, fastChargeOnly?) | P0 | 1h | — | ⬜ |
| `P1-004` | Create `lib/features/profile/` feature slice (data + domain + presentation). Persist `Vehicle` + `UserPreferences` in Hive box `user_profile` (also mirror to Firestore `users/{uid}` doc) | P0 | 4h | `P1-003` | ⬜ |
| `P1-031` | `UserPreferences` model: pureVeg, familyMode, womenSafe, budgetTier, fastChargersOnly, petFriendly, nightSafe, scenicRoute, preferredFuelBrand?, dietaryFlags | P0 | 1h | `P1-003` | ⬜ |
| `P1-032` | Profile setup screen (post-onboarding, before AppShell): vehicle picker + preference chips | P0 | 4h | `P1-031` | ⬜ |
| `P1-033` | Profile edit screen accessible from a new "Profile" entry in AppShell (or settings) | P1 | 3h | `P1-032` | ⬜ |
| `P1-005` | Extend plan input UI (`route_input_card.dart`) — add vehicle selector + quick-toggle preference chips for this trip | P0 | 3h | `P1-032` | ⬜ |

---

## 1.3 Generalized POI domain

| ID | Task | Priority | Est. | Depends on | Status |
|---|---|---|---|---|---|
| `P1-006` | Create `lib/core/domain/poi.dart` — `Poi` freezed entity (id, name, category, location, address, source, rating, reviewCount, openNow?, attributes Map, photos[], priceLevel?) + `PoiCategory` enum (16 grid items from PDF) | P0 | 2h | — | ⬜ |
| `P1-007` | Scaffold `lib/features/pois/` feature slice — empty folders + provider seams (`pois_providers.dart`, `poi_repository.dart` interface) | P0 | 2h | `P1-006` | ⬜ |
| `P1-008` | Implement `GooglePlacesPoiSource` — search Google Places along route polyline (uses existing `directions_service.dart` polyline + bounded text-search) for fuel, restaurants, washrooms, ATMs, hotels, mechanics, parking, hospitals, police, cafes, scenic, temples, tourist places | P0 | 2d | `P1-007` | ⬜ |
| `P1-009` | Generalize `lib/core/services/route_station_service.dart` → `route_poi_service.dart` accepting `PoiCategory`. Preserve `google_ev_station_service.dart` as the specialization for EV (OCM + Google EV). Keep existing station screens working through an adapter | P0 | 1.5d | `P1-008` | ⬜ |
| `P1-010` | POI domain models for community-trust extension fields: `targetType`, `targetKey` so community pulses work for any POI | P0 | 2h | `P1-006`, `P1-023` | ⬜ |

---

## 1.4 Smart Intelligence Grid (the iconic PDF screen)

| ID | Task | Priority | Est. | Depends on | Status |
|---|---|---|---|---|---|
| `P1-011` | Create `lib/features/discovery/` feature. `DiscoveryScreen` — 3-column grid of all `PoiCategory` items with icons, gradient cards | P0 | 4h | `P1-006` | ⬜ |
| `P1-012` | `PoiCategoryScreen` — single reusable screen parameterized by `PoiCategory`. Shows route-aware list, distance from current location, community pulse, filter chips | P0 | 1d | `P1-008`, `P1-011` | ⬜ |
| `P1-013` | Wire grid items → `PoiCategoryScreen` route | P0 | 1h | `P1-012` | ⬜ |
| `P1-014` | Empty / loading / error states for `PoiCategoryScreen` reusing existing error taxonomy | P0 | 3h | `P1-012` | ⬜ |
| `P1-015` | Map view toggle on `PoiCategoryScreen` (reuse `station_map_screen.dart` pattern with POI markers) | P1 | 4h | `P1-012` | ⬜ |

---

## 1.5 AppShell navigation update

| ID | Task | Priority | Est. | Depends on | Status |
|---|---|---|---|---|---|
| `P1-016` | Update `lib/features/shell/presentation/view/app_shell.dart` — revise tabs to: **Plan** · **Trip** · **Discover** · **Profile** (or keep Insights as 5th tab) | P0 | 2h | `P1-011`, `P1-033` | ⬜ |
| `P1-017` | "Trip" tab — shows current/last active trip dashboard if any, else CTA to plan one | P0 | 4h | `P1-040` | ⬜ |

---

## 1.6 Smart Route Dashboard (trip control center)

| ID | Task | Priority | Est. | Depends on | Status |
|---|---|---|---|---|---|
| `P1-018` | Extend `PlanResult` model — add `etaMinutes`, `tollsEstimate?`, `fuelEstimateCost?` (derived from vehicle.fuelEfficiency + segment distance), `chargingEstimate?` (existing), `weatherTag?` (placeholder for Phase 2), `trafficLevel?` (placeholder) | P0 | 3h | `P1-003` | ⬜ |
| `P1-019` | Trip Dashboard widget in `plan_result_view.dart` — stat cards row: distance · ETA · fuel/charge cost · tolls placeholder | P0 | 4h | `P1-018` | ⬜ |
| `P1-020` | Smart Trip Timeline widget — vertical timeline: `Start → Fuel stop → Breakfast → EV charge → Destination` using POI suggestions on route | P0 | 1d | `P1-008`, `P1-019` | ⬜ |
| `P1-021` | Timeline editor — user can pin/unpin a POI suggestion as a stop | P1 | 6h | `P1-020` | ⬜ |

---

## 1.7 Distance-based alerts engine (MVP)

| ID | Task | Priority | Est. | Depends on | Status |
|---|---|---|---|---|---|
| `P1-022` | Create `lib/features/alerts/domain/alert.dart` — `Alert` freezed entity (id, type, severity, message, distanceKm, triggeredAt, relatedPoiId?) + `AlertType` enum | P0 | 2h | — | ⬜ |
| `P1-023` | `AlertEngine` (rule evaluator) — pure Dart, takes `(activeRoute, currentLocation, vehicle, preferences, upcomingPois)` and returns `List<Alert>` | P0 | 1.5d | `P1-022`, `P1-008` | ⬜ |
| `P1-024` | Rule: **Fuel Low** — "Last trusted pump for next X km" when vehicle is petrol/diesel and next reliable pump is >40km away | P0 | 4h | `P1-023` | ⬜ |
| `P1-025` | Rule: **EV Gap** — "Next fast charger is X km away" using existing charging station service | P0 | 3h | `P1-023` | ⬜ |
| `P1-026` | Rule: **Food window** — "Next highly rated veg restaurant after X km" honors `pureVeg` preference | P0 | 4h | `P1-023` | ⬜ |
| `P1-027` | Add `flutter_local_notifications` dependency + iOS/Android setup | P0 | 3h | — | ⬜ |
| `P1-028` | `AlertNotifier` — Riverpod stream from `AlertEngine` → fires local notification + in-app banner | P0 | 6h | `P1-027`, `P1-023` | ⬜ |
| `P1-034` | Alert history screen (per-trip log of fired alerts) | P1 | 4h | `P1-028` | ⬜ |

---

## 1.8 Active Trip & offline corridor cache

| ID | Task | Priority | Est. | Depends on | Status |
|---|---|---|---|---|---|
| `P1-040` | Create `lib/features/trip/` — `Trip` model (id, routePolyline, originPoi, destinationPoi, startedAt, endedAt?, statusEnum, plannedStops[], firedAlerts[]) | P0 | 3h | `P1-018` | ⬜ |
| `P1-041` | `ActiveTripController` — starts/pauses/ends a trip, persists to Hive box `active_trip` | P0 | 6h | `P1-040` | ⬜ |
| `P1-042` | Foreground location tracking during active trip (opt-in, clear UX) using `geolocator` + Android foreground service | P0 | 1d | `P1-041` | ⬜ |
| `P1-043` | Offline corridor cache — when a trip is planned, cache route polyline + first 50 POIs per category in Hive box `corridor_cache` keyed by trip id | P0 | 6h | `P1-040`, `P1-008` | ⬜ |
| `P1-044` | Offline detection + degraded mode banner ("Using cached trip data") | P1 | 3h | `P1-043` | ⬜ |

---

## 1.9 Community pulses → POIs (generalization)

| ID | Task | Priority | Est. | Depends on | Status |
|---|---|---|---|---|---|
| `P1-050` | Extend Firestore community report schema: add `targetType: 'station' \| 'poi'` and `targetKey` (replaces `stationKey` in queries; keep `stationKey` for back-compat) | P0 | 4h | `P1-006` | ⬜ |
| `P1-051` | Update `community_report_repository.dart` to accept `targetKey` (generic) while preserving `stationKey` reads | P0 | 4h | `P1-050` | ⬜ |
| `P1-052` | Update `community_providers.dart` — add `poiCommunityControllerProvider.family` keyed by `targetKey` | P0 | 2h | `P1-051` | ⬜ |
| `P1-053` | Mount existing `CommunityReportsSection` widget inside POI detail screens (reusable) | P0 | 3h | `P1-052`, `P1-012` | ⬜ |
| `P1-054` | Mount `CommunityRatingPulse` chip on every POI list tile in `PoiCategoryScreen` | P0 | 2h | `P1-052`, `P1-012` | ⬜ |
| `P1-055` | Migrate Firestore composite index file `firebase/firestore.indexes.json` to include `targetKey + createdAt` (in addition to existing `stationKey + createdAt`) | P1 | 1h | `P1-050` | ⬜ |

---

## 1.10 Cross-cutting hygiene

| ID | Task | Priority | Est. | Depends on | Status |
|---|---|---|---|---|---|
| `P1-060` | Lightweight telemetry hooks on new flows (reuse the logger pattern from `community_telemetry.dart`) | P1 | 3h | — | ⬜ |
| `P1-061` | Error taxonomy parity for `PoiRepository` (network / permission / index / firestore / platform / quota) | P0 | 2h | `P1-007` | ⬜ |
| `P1-062` | Skeleton loaders for POI lists | P1 | 3h | `P1-012` | ⬜ |
| `P1-063` | Add `flutter_local_notifications` + `connectivity_plus` to `pubspec.yaml` and regenerate lockfile | P0 | 30m | — | ⬜ |
| `P1-064` | Add Crashlytics dependency (initialize but optional; deeper integration is `P2-022`) | P1 | 1h | — | ⬜ |
| `P1-065` | Update `docs/context/current_state.md` after each major sub-section completes | P0 | rolling | — | ⬜ |

---

## Phase 1 completion checklist

- [ ] All `P0` tasks in `1.1` through `1.9` are `Done`.
- [ ] You can plan a trip in any vehicle with preferences and reach `PlanResult` with the new dashboard.
- [ ] Smart Intelligence Grid renders and at least 6 categories return route-aware results (fuel, restaurant, washroom, ATM, hotel, mechanic).
- [ ] Distance-based alerts fire for at least 3 rules (`P1-024`, `P1-025`, `P1-026`).
- [ ] Community pulse appears on at least one non-station POI category.
- [ ] App still works for the legacy EV station flows (no regression).
