# Codebase quick-map

> File paths I (the AI) need to remember across sessions. Not exhaustive — only what I have to touch repeatedly.

## Entry points
- `lib/main.dart` — app bootstrap, Hive boxes, Firebase init.
- `pubspec.yaml` — deps + product description.
- `firebase/firestore.indexes.json` — composite indexes (extend for `targetKey + createdAt` in `P1-055`).

## Core
- `lib/core/services/` — `directions_service.dart`, `geocoding_service.dart`, `google_ev_station_service.dart`, `places_autocomplete_service.dart`, `route_station_service.dart` (EV-typed), **`route_poi_service.dart`** (`P1-009`), **`location_service.dart`** — `LocationService` + `locationServiceProvider`; `requestPermission()`, `currentPosition()`, `listenToPosition(cb)` returning `StreamSubscription` (`P1-042`), **`connectivity_service.dart`** — `connectivityStreamProvider` (`Stream<List<ConnectivityResult>>`), `isOnlineProvider` (`bool`, optimistic default true) (`P1-044`).
- `lib/core/utils/` — `location_helper.dart`, `polyline_decoder.dart`, `result.dart` (Freezed Result type), `station_merger.dart`, **`failure.dart`** — canonical `Failure` sealed class with 6 variants (`P1-007`/`P1-061`).
- `lib/core/theme/` — `app_theme.dart`, plus `AppColors` / `AppTextStyles`.
- `lib/core/constants/cache_constants.dart` — Hive box names (existing). Note: profile box name lives on `ProfileBox.boxName` (feature-internal).
- `lib/core/widgets/app_top_bar.dart` — global top bar; profile popup now has "Edit profile" (name/phone), **"Trip preferences"** (vehicle + prefs, `P1-033`), "Log out".
- `lib/core/domain/` — cross-feature domain models.
  - `vehicle.dart` — `VehicleType` enum + `Vehicle` freezed (created `P1-003`).
  - `user_preferences.dart` — `UserPreferences` + `BudgetTier` (created `P1-031`).
  - `poi.dart` — `Poi`, `PoiCategory` (16 items), `PoiSource` (created `P1-006`).

## Features (today)
- `auth/` `data domain presentation` — `AuthGate` routes signed-in users through `VehicleSetupGate` before AppShell (`P1-032`).
- `onboarding/`
- `shell/presentation/view/app_shell.dart` — four tabs: **Plan · Trip · Discover · Profile** (`P1-016`). `Scaffold.body` is `Column([OfflineBanner(), Expanded(IndexedStack)])` so the offline banner appears on all tabs (`P1-044`). Old `InsightsScreen` + `StationsScreen` are orphan code (still compile, not in nav).
- `plan/presentation/` — `RouteInputCard` (now takes vehicle + preferences, `P1-005`), `TripContextRow` widget, `PlanController`, `PlanState`, `PlanResultView`. `PlanScreen` holds per-trip override state for vehicle + preferences.
- `stations/presentation/` — list + map screens, station detail.
- `community/` `data domain presentation` — Firestore-backed pulses; offline queue; widgets `CommunityReportsSection`, `CommunityRatingPulse`. **Still uses `Either<String, T>` prefix strings** — not migrated to typed `Failure` yet.
  - `domain/community_target_type.dart` — `CommunityTargetType { station, poi }` (`P1-010`).
  - `domain/models/station_community_report.dart` — gained `targetType` + `targetKey` + derived `effectiveTargetKey` (`P1-010`, back-compat with old `stationKey` docs).
  - `data/dto/station_community_report_dto.dart` — read/write the new fields; station writes mirror `stationKey` into `targetKey` so the `P1-051` query-by-targetKey path serves both target types.
  - `data/repository/community_report_repository.dart` — `watchStationReports(stationKey)` (legacy) + **`watchByTargetKey(targetKey)`** (`P1-051`).
  - `presentation/controller/station_community_controller.dart` — internal field renamed to `_targetKey`; new optional `queryByTargetKey` constructor flag toggles which stream to subscribe to.
  - `presentation/controller/community_providers.dart` — `stationCommunityControllerProvider` (legacy) + **`poiCommunityControllerProvider`** family keyed by `targetKey` (`P1-052`).
  - `presentation/widgets/poi_community_rating_pulse.dart` — POI counterpart of `CommunityRatingPulse` (`P1-054`).
  - `presentation/widgets/poi_community_reports_section.dart` — POI counterpart of `CommunityReportsSection`; read-only (POI submit deferred) (`P1-053`).
- `firebase/firestore.indexes.json` — composite indexes for `stationKey + createdAt desc` AND `targetKey + createdAt desc` (`P1-055`). Run `firebase deploy --only firestore:indexes` after editing.
- `charging/`
- `insights/`
- `alerts/`
  - `domain/alert.dart` — `Alert`, `AlertType` (Phase 1+2 values), `AlertSeverity` (created `P1-022`).
  - `presentation/` — view + widget folders exist; not yet populated by Phase 1 work.
- `profile/` — created in `P1-004`.
  - `domain/profile_data.dart` — `ProfileData { vehicle?, preferences }`.
  - `data/local_db/profile_box.dart` — Hive box (`user_profile`); opened in `main.dart`.
  - `data/repository/profile_repository.dart` — `readLocal`, `hydrateFromFirestore`, `save` returning `Either<Failure, _>`.
  - `presentation/controller/` — `profile_providers.dart`, `profile_controller.dart`, `profile_ui_state.dart` (`ProfileIdle/Saving/Errored`).
  - `presentation/view/` — `vehicle_setup_gate.dart`, `profile_setup_screen.dart`, `profile_edit_screen.dart`, `profile_tab_screen.dart` (`P1-016` tab).
  - `presentation/widget/` — `vehicle_picker.dart`, `preferences_chips.dart`.
- `pois/`
  - `data/repository/poi_repository.dart` — abstract `PoiRepository` interface (uses `LatLng` from `polyline_decoder.dart`).
  - `data/repository/google_places_poi_source.dart` — concrete impl using Google Places Nearby Search + Place Details (`P1-008`). 15 categories supported; EV refused (delegated).
  - `domain/community_poi_key.dart` — `communityPoiKey(Poi)` → `poi_<sanitized id>` (`P1-010`).
  - `presentation/controller/pois_providers.dart` — `poiRepositoryProvider` bound to `GooglePlacesPoiSource`; `routePoiServiceProvider`; `poiCategoryControllerProvider.family.autoDispose<PoiCategory>` (`P1-012`).
  - `presentation/controller/poi_category_ui_state.dart` — Freezed sealed `PoiCategoryUiState { loading, data, empty, errored }`, with `PoiQuerySource { alongRoute, nearby }`.
  - `presentation/controller/poi_category_controller.dart` — decides between route-aware and nearby strategies based on `PlanController` snapshot at construction; EV without a plan → explicit empty state.
  - `presentation/view/poi_category_screen.dart` — reusable category screen with list/map toggle in app bar (`P1-012` + `P1-015`).
  - `presentation/widget/poi_list_tile.dart` — list tile; `pulseSlot` now filled by `PoiCommunityRatingPulse` (`P1-054`).
  - `presentation/widget/poi_category_map_view.dart` — Google Maps view with POI markers; same pattern as `station_map_screen.dart`.
  - `presentation/widget/poi_detail_sheet.dart` — `showPoiDetailSheet(context, poi)` modal that embeds `PoiCommunityReportsSection` (`P1-053`).
- `discovery/`
  - `presentation/view/discovery_screen.dart` — Smart Intelligence Grid (3 × ~6 of 16 categories). Tile tap pushes `PoiCategoryScreen` (`P1-011` + `P1-013`). Reachable via the Discover tab in `AppShell` (`P1-016`).

- `trip/`
  - `data/local_db/trip_box.dart` — Hive `active_trip` box; JSON-encoded single `Trip` under key `current`. API: `read()`, `save(trip)`, `clear()` (`P1-040`).
  - `domain/models/trip.dart` — `Trip` Freezed + json_serializable. Fields: id, from, to, vehicle, status, totalDistanceKm, drivingMinutes, etaMinutes?, tollsEstimate?, tripCostEstimate?, isCostCharging, stationCount, createdAt, startedAt?, pausedAt?, completedAt?, elapsedPausedMs. Derived: `isTracking`, `elapsed` (`P1-040`).
  - `domain/models/trip_status.dart` — `TripStatus { notStarted, active, paused, completed }` (`P1-040`).
  - `presentation/controller/active_trip_state.dart` — Freezed sealed `ActiveTripState { idle, ready(trip), running(trip), paused(trip), completed(trip) }`. Extension `ActiveTripStateX.trip` extracts trip from any sub-state (`P1-041`).
  - `presentation/controller/active_trip_controller.dart` — `StateNotifier<ActiveTripState>`. Entry point: `prepareTrip(plan, vehicle)`. Transitions: `startTrip` / `pauseTrip` / `resumeTrip` / `endTrip` / `dismissCompleted`. All Hive-persisted. Accepts `LocationService`; starts/stops `StreamSubscription<Position>` on trip state changes; builds `CorridorCache` on `prepareTrip` (`P1-041`, `P1-042`, `P1-043`).
  - `presentation/controller/trip_providers.dart` — `activeTripControllerProvider` (NOT autoDispose); injects `locationServiceProvider` (`P1-041`, `P1-042`).
  - `domain/models/corridor_cache.dart` — plain Dart; `tripId`, `encodedPolyline`, `stationIds`, `totalDistanceKm`, `cachedAt`, `isStale`, `toJson`/`fromJson` (`P1-043`).
  - `data/local_db/corridor_cache_box.dart` — Hive `corridor_cache` box; `read()`, `save()`, `clear()`, `evictIfStale()` (`P1-043`).
  - `presentation/view/trip_tab_screen.dart` — `TripTabScreen(onPlanTrip)`. Switches on state: idle→CTA, ready→confirm+Start, running/paused→live dashboard with elapsed ticker, completed→summary. Pause/Resume/End trip buttons. End trip shows confirmation dialog (`P1-017`).

## Hive boxes already open in `main.dart`
- `CacheConstants.chargingBoxName` — existing.
- `CommunitySubmitQueue.boxName` (`community_submit_queue`) — existing.
- `ProfileBox.boxName` (`user_profile`) — `P1-004`.
- `TripBox.boxName` (`active_trip`) — `P1-040`.
- `CorridorCacheBox.boxName` (`corridor_cache`) — `P1-043`.

## Build-runner
After ANY change to a `*.freezed.dart` source class, run:

```
dart run build_runner build --delete-conflicting-outputs
```
