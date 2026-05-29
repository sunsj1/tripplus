# Current State (rolling snapshot)

> **Update this file** whenever a task materially changes the user-visible surface or the architecture.
> AI agents read this first to avoid re-discovering what's already built.

**Last updated:** 2026-05-30 (Phase 1 sessions 1–9 landed — through **Alert engine MVP**: pure-Dart `AlertEngine` + fuel/EV/food rules + `flutter_local_notifications` platform setup).

---

## TL;DR

Functional EV-charging assistant app with auth, navigation shell (Plan · Insights · Stations), planning, route-aware EV station discovery, community pulses with offline-first submission, and reliability UX (Phases 1–2 of `RELIABILITY_PHASES.md` done).

**Now pivoting to:** Smart Highway Companion (Phase 1 of `project_plan/`).

---

## Implemented surface (today)

### Auth & onboarding
- Firebase Auth + Google Sign-In.
- `AuthGate`: onboarding → profile completion → `AppShell`.
- Profile uses Firestore `users/{uid}`.

### App shell
- Bottom navigation: **Plan · Insights · Stations**.
- Theme: `lib/core/theme/` (AppColors, AppTextStyles, AppTheme).

### Stations
- `StationsScreen` (list + map).
- `StationDetailScreen` with community section embedded.
- Data sources: Google EV Stations + Open Charge Map (merged in `core/utils/station_merger.dart`).

### Plan
- `PlanScreen` with `RouteInputCard` (from / to).
- `PlanController` + `PlanState`.
- `PlanResultView` shows route + stations along the corridor.
- Core services: `directions_service.dart`, `geocoding_service.dart`, `places_autocomplete_service.dart`, `route_station_service.dart`, `polyline_decoder.dart`.

### Insights
- `InsightsScreen` (currently minimal placeholder).

### Community (advanced — main USP foundation)
- Firestore-backed pulses (collection `stationCommunityReports`).
- Schema: `stationKey`, rating, condition, amenities, optional base64 photo, notes, reporter info, `createdAt`.
- Submit wizard (`station_report_sheet.dart` + step widgets: pulse / amenities / photo / review).
- `CommunityReportsSection` on station detail, `CommunityRatingPulse` chip on tiles.
- **Offline-first submit queue** (`community_submit_queue.dart`, Hive box `community_submit_queue`).
- **Reliability UX Phase 1:** confidence visibility, error taxonomy, low-confidence states.
- **Reliability UX Phase 2:** report quality scoring, conflict-aware timeline, charge-success signal, filters on all-pulses view, route/planning risk hints, lightweight telemetry.

### Local persistence
- Hive boxes initialized in `main.dart`:
  - `charging` (existing cache)
  - `community_submit_queue` (offline queue)

### Permissions / native plist
- iOS `NSPhotoLibraryUsageDescription` set.
- Location permissions wired via `permission_handler`.

---

## Phase 1 progress (47/50 = 94%)

### Session 1 — foundation models (2026-05-28)

- ✅ Internal rebrand: pubspec description + MaterialApp title (`P1-001`, `P1-002`).
- ✅ Product README (`P1-029`).
- ✅ `flutter_local_notifications` + `connectivity_plus` deps (`P1-063`). Native Android/iOS wiring (`P1-027`).
- ✅ `lib/core/domain/vehicle.dart` (`P1-003`).
- ✅ `lib/core/domain/user_preferences.dart` (`P1-031`).
- ✅ `lib/core/domain/poi.dart` — `Poi`, `PoiCategory` × 16, `PoiSource` (`P1-006`).
- ✅ `lib/features/alerts/domain/alert.dart` — `Alert`, `AlertType` (Phase 1+2), `AlertSeverity` (`P1-022`).

### Session 2 — profile experience + POI scaffold (2026-05-28)

- ✅ `lib/core/utils/failure.dart` — canonical `Failure` sealed class, 6 variants (`P1-007`/`P1-061`).
- ✅ `lib/features/pois/` scaffold — `PoiRepository` interface + `poiRepositoryProvider` (throws until `P1-008`).
- ✅ `lib/features/profile/` slice — Hive box `user_profile` + Firestore mirror, `ProfileController`, full UI state (`P1-004`).
- ✅ `ProfileSetupScreen` + `VehicleSetupGate` — now gates `AppShell` after auth (`P1-032`).
- ✅ `ProfileEditScreen` — reachable from app top bar's "Trip preferences" menu entry (`P1-033`).
- ✅ Plan input renders vehicle row + 6 preference toggle chips above FROM/TO; per-trip overrides default from saved profile (`P1-005`). `PlanController` consumption pending `P1-018`.

### Session 3 — POI data path + community generalization (2026-05-28)

- ✅ `GooglePlacesPoiSource` — concrete `PoiRepository` impl using Google Places Nearby Search + Place Details; 15 categories supported (`P1-008`). EV deliberately refused — served via the adapter below.
- ✅ `lib/core/services/route_poi_service.dart` — generic route-aware POI service. Dispatches `ev → RouteStationService` adapter (ChargingStation → Poi mapping); other categories → `PoiRepository.searchAlongRoute` (`P1-009`).
- ✅ Community report schema extension: `CommunityTargetType { station, poi }` enum + `targetType` + `targetKey` fields on `StationCommunityReport` / `StationCommunitySubmitInput`; DTO mirrors `stationKey` into `targetKey` so the upcoming `P1-051` query path serves both targets from one index. Back-compat preserved (`P1-010`).
- ✅ `lib/features/pois/domain/community_poi_key.dart` — `communityPoiKey(Poi) → poi_<sanitized id>`.
- ✅ `poiRepositoryProvider` and new `routePoiServiceProvider` exposed.

### Session 4 — Community read path (2026-05-28)

- ✅ `P1-050` closed out (session 3 DTO change is the Firestore-side schema change; Firestore is schemaless).
- ✅ `CommunityReportRepository.watchByTargetKey(targetKey)` — new stream alongside `watchStationReports(stationKey)` (`P1-051`).
- ✅ `poiCommunityControllerProvider.family.autoDispose` keyed by `targetKey`; shares `StationCommunityController` via a new `queryByTargetKey` flag (`P1-052`).
- ✅ `firebase/firestore.indexes.json` adds composite `targetKey + createdAt desc` (`P1-055`). **Deploy step owed: `firebase deploy --only firestore:indexes`.**

### Session 5 — Smart Intelligence Grid + Category screen (2026-05-28)

- ✅ `lib/features/discovery/presentation/view/discovery_screen.dart` — 3-column grid of all 16 `PoiCategory` items, the iconic PDF surface (`P1-011`).
- ✅ `lib/features/pois/presentation/view/poi_category_screen.dart` — reusable screen parameterized by `PoiCategory`. Uses `RoutePoiService.findAlongRoute` when a `PlanResult` exists, else `PoiRepository.searchNearby` from current location. EV without a plan → "Plan a trip first" empty state (`P1-012`).
- ✅ Grid tile `onTap` pushes `PoiCategoryScreen(category)` (`P1-013`).
- ✅ Loading / Empty / Errored states with calming copy; `Failure` variants map to actionable headlines + `Failure.actionLabel` CTA (`P1-014`).
- ✅ List ⇄ map toggle in app bar; map view mirrors `station_map_screen.dart` with POI markers + popup (`P1-015`).

### Session 6 — POI community pulses + four-tab shell + Crashlytics (2026-05-28)

- ✅ `PoiCommunityRatingPulse` chip on every POI tile via `pulseSlot` (`P1-054`).
- ✅ `PoiCommunityReportsSection` (read-only) embedded in a new `showPoiDetailSheet` modal that opens on POI tile tap (`P1-053`). POI submit path deliberately deferred — wizard is `ChargingStation`-typed and needs its own task.
- ✅ AppShell tabs revised → **Plan · Trip · Discover · Profile**; `app_bottom_nav.dart` refactored around a `_NavSpec` list; Trip is a placeholder until `P1-017`; Profile is a new `ProfileTabScreen` mirroring `ProfileEditScreen` without the pop (`P1-016`).
- ✅ Discovery is now reachable from the bottom nav for the first time.
- ✅ `firebase_crashlytics: ^5.0.0` + Dart-side init (`setCrashlyticsCollectionEnabled(!kDebugMode)`, `FlutterError.onError`, `PlatformDispatcher.onError`). Android gradle plugin still owed to Phase 2's `P2-071` (`P1-064`).
- ⚠️ `InsightsScreen` and `StationsScreen` are now orphan code (not in the nav). Phase 2 decides to repurpose or delete.

### Session 7 — Trip Dashboard + Trip foundation (2026-05-30)

- ✅ `PlanResult` extended with `etaMinutes`, `tollsEstimate`, `fuelEstimateCost`, `chargingEstimate`, `weatherTag`, `trafficLevel` (`P1-018`). `PlanController.analyzeRoute` now accepts `Vehicle?`; computes fuel/charging cost from efficiency + price constants and traffic level from duration vs. theoretical 80 km/h (`P1-018`).
- ✅ Trip Dashboard stat-card row in `PlanResultView` showing ETA, Tolls, Fuel/Charging, Traffic. "TRIP OVERVIEW" section header. Uses existing `StatCard` widget (`P1-019`).
- ✅ "Start this trip" `FilledButton` on `PlanResultView` — calls `activeTripControllerProvider.notifier.prepareTrip(plan, vehicle)`, then shows snackbar "Trip ready — go to the Trip tab" (`P1-017`).
- ✅ `lib/features/trip/` slice — `Trip` Freezed model with full lifecycle fields, `TripStatus` enum, `TripBox` (Hive `active_trip` box). `uuid` package added to pubspec. `active_trip` box opened in `main.dart` (`P1-040`).
- ✅ `ActiveTripController` + `ActiveTripState` sealed Freezed union. Full lifecycle: `prepareTrip → startTrip → pause/resume → endTrip → dismissCompleted`. All state transitions Hive-persisted. `activeTripControllerProvider` (non-autoDispose) (`P1-041`).
- ✅ `TripTabScreen` replaces `_TripTabPlaceholder` in `AppShell`. Five views: idle CTA, ready-to-start confirm, live dashboard with 1-second elapsed ticker, paused dashboard, completed summary with actual duration. Pause/Resume/End buttons with End-trip confirmation dialog (`P1-017`).

### Session 8 — Smart Trip Timeline + Offline resilience (2026-05-30)

- ✅ `TimelineStop` plain Dart model + `TimelineStopType` enum (`P1-020`).
- ✅ `TripTimelineController` — `StateNotifier<List<TimelineStop>>`; `togglePin(index)` for P1-021; autoDispose family keyed by `PlanResult` (`P1-020`, `P1-021`).
- ✅ `SmartTripTimeline` widget — vertical timeline with icon bubbles, gradient connector lines, distance chips, pin-toggle animated pills; wired into `PlanResultView` after "Start trip" button (`P1-020`, `P1-021`).
- ✅ `LocationService` — `requestPermission()`, `currentPosition()`, `listenToPosition()`; Android `FOREGROUND_SERVICE` + `FOREGROUND_SERVICE_LOCATION` permissions added (`P1-042`).
- ✅ `ActiveTripController` starts/stops location `StreamSubscription` on `startTrip`/`pauseTrip`/`resumeTrip`/`endTrip` (`P1-042`).
- ✅ `CorridorCache` + `CorridorCacheBox` (`corridor_cache` Hive box); populated on `prepareTrip()`, cleared on `endTrip()` (`P1-043`).
- ✅ `connectivityStreamProvider` + `isOnlineProvider` + `OfflineBanner` animated widget; wired into `AppShell` body (`P1-044`).

### Session 9 — Alert engine MVP (2026-05-30)

- ✅ `AlertEngine` pure-Dart evaluator + `AlertEngineInput` + `AlertRouteUtils` (`P1-023`). Dedupes by `AlertType`, severity-ranked.
- ✅ `FuelLowRule` — trusted fuel gap >40 km for petrol/diesel/bike (`P1-024`).
- ✅ `EvGapRule` — charger gap / next stop >40 km; honours `fastChargeOnly` (`P1-025`).
- ✅ `FoodWindowRule` — highly rated meal lookahead; honours `pureVeg` via `PoiCategory.pureVeg` (`P1-026`).
- ✅ `LocalNotificationService` — Android channel + receivers + `POST_NOTIFICATIONS`; init in `main.dart`; `alertEngineProvider` (`P1-027`).
- ✅ Unit tests: `test/features/alerts/alert_engine_test.dart` (4 cases).

### NOT implemented (remaining Phase 1 targets)

- ❌ Alert delivery: `AlertNotifier` stream → banner + notification (`P1-028`), history screen (`P1-034`).
- ❌ Hygiene: telemetry hooks (`P1-060`), skeleton loaders (`P1-062`), launch icon/splash (`P1-030`).

See `project_plan/01_phase_1_mvp.md` for the full Phase 1 task list.

---

## Architecture invariants (do not break)

1. Feature-slice layout under `lib/features/`.
2. Riverpod everywhere; controllers are `StateNotifier<UiState>`.
3. Freezed models for all domain types.
4. Repositories return `Either<Failure, T>` for writes.
5. Community reports are immutable (schema may only add fields).
6. Community photos are base64 JPEG inline on the doc (no Firebase Storage).
7. Stable identity helpers always used (no raw Google/OCM ids).

---

## How to update this file

When you finish a task ID, append/replace the relevant bullet under "Implemented surface" and remove from "NOT implemented" if appropriate. Keep this file under 200 lines — if it grows beyond that, split sub-sections into dedicated files.
