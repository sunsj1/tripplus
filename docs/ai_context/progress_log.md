# AI progress log

> Append-only, session-wise record. Each session is a self-contained commit unit.
> Format per session: header → tasks → files changed → notes / follow-ups.
> Newest at the top.

---

## Session 4 — Community read path

- **Started:** 2026-05-28
- **Finished:** 2026-05-28
- **Tasks completed (4/4):** `P1-050`, `P1-051`, `P1-052`, `P1-055`
- **Theme:** finish what session 3 started on the schema side — add the read path + provider + composite index so anyone (station or POI) reads pulses through one generic surface.

### Per-task notes

- `P1-050` — Closeout. Session 3 already shipped the actual Firestore-side change (DTO writes `targetType` + `targetKey` on every create; Firestore is schemaless so no migration). No new code in this session; marking done after verifying:
  - `station_community_report_dto.dart` `toCreateMap` writes both fields ✅
  - station writes mirror `stationKey → targetKey` so a single index serves both target types ✅
  - reads via `fromDocument` fall back to `stationKey` when `targetKey` is absent ✅
- `P1-051` — `CommunityReportRepository.watchByTargetKey(targetKey)`:
  - New stream method alongside `watchStationReports(stationKey)`. Same in-memory-sort + `take(50)` pattern; same `Either<String, ...>` prefix-string error scheme as the rest of this repo.
  - Old reports (pre-`P1-010`) only have `stationKey` and are deliberately invisible to this query. Callers that need them keep using `watchStationReports`. New writes (post-`P1-010`) are visible to both.
  - Doc comment explicitly notes the in-memory cap and references `firebase/firestore.indexes.json` for the headroom case.
- `P1-052` — POI controller provider family:
  - `StationCommunityController` gains an optional `queryByTargetKey` constructor flag (default `false`, keeps legacy behavior) and an internally renamed field `_targetKey`. No external behavior change for the existing `stationCommunityControllerProvider`.
  - New `poiCommunityControllerProvider` — same shape (`StateNotifierProvider.autoDispose.family<…, String>`) but constructs the controller with `queryByTargetKey: true`. POI screens (`P1-053`/`P1-054`) consume this.
- `P1-055` — Composite Firestore index:
  - `firebase/firestore.indexes.json` now declares `targetKey ASC + createdAt DESC` alongside the existing `stationKey + createdAt`.
  - **Deploy step you owe:** `firebase deploy --only firestore:indexes`. Builds in production take a few minutes; queries that need it return `failed-precondition` until the build finishes (already surfaces as a `Failure.index` via the repository pattern in `community_report_repository.dart`, line `'failed-precondition' → 'index:$msg'`).
  - Note: the new query in `P1-051` doesn't actually NEED this index today because it uses no server-side `orderBy`. The index is headroom for when read volume justifies switching to server-side `orderBy('createdAt', descending: true).limit(50)`.

### Files changed

```
M  docs/ai_context/codebase_map.md
M  docs/ai_context/progress_log.md
M  docs/batches/phase_1_batches.md
M  docs/context/current_state.md
M  firebase/firestore.indexes.json
M  lib/features/community/data/repository/community_report_repository.dart
M  lib/features/community/presentation/controller/community_providers.dart
M  lib/features/community/presentation/controller/station_community_controller.dart
M  project_plan/notion_tracker.md
M  project_plan/tasks.csv
```

### Validation

- `flutter analyze` clean across the whole project.
- Existing station feed flow unchanged — the constructor default keeps `watchStationReports(stationKey)` wired for `stationCommunityControllerProvider`.
- Not driven by `flutter run` — left for you per the session-wise commit workflow.

### Suggested commit message

```
feat(phase1): community pulses read path generalized (session 4)

P1-050 Firestore community schema closeout — DTO writes targetType/targetKey
P1-051 CommunityReportRepository.watchByTargetKey — generic feed query,
       legacy watchStationReports preserved
P1-052 poiCommunityControllerProvider family (autoDispose) — POI side of
       the community feed, sharing StationCommunityController
P1-055 firestore.indexes.json — composite index targetKey + createdAt desc

NOTE: run `firebase deploy --only firestore:indexes` after merging.
```

### Open follow-ups carried to later sessions

- POI side has no UI consumer yet — that lands in session 6 (`P1-053` / `P1-054`) once `PoiCategoryScreen` exists from session 5.
- Existing `CommunityReportRepository` still uses `Either<String, …>` with prefix strings, not the typed `Failure`. Out of scope for this session; will only be migrated if a touch-the-file change requires it later.
- `firestore.indexes.json` change requires a Firebase deploy on every environment (dev / staging / prod). Not automated.

---

## Session 3 — POI data path

- **Started:** 2026-05-28
- **Finished:** 2026-05-28
- **Tasks completed (3/3):** `P1-008`, `P1-009`, `P1-010`
- **Theme:** turn last session's `PoiRepository` scaffold into a working route-aware POI data path; extend community schema so pulses can attach to any POI.

### Per-task notes

- `P1-008` — `GooglePlacesPoiSource`:
  - `lib/features/pois/data/repository/google_places_poi_source.dart` — implements `PoiRepository`. Uses Google Places **Nearby Search** for the 15 non-EV categories, mapping each `PoiCategory` to a `type` and/or `keyword` (e.g. `washroom → keyword:"public toilet"`, `pureVeg → type:restaurant + keyword:"pure veg"`).
  - Samples up to 10 polyline points (capped to limit Places-API quota burn), parallel `Future.wait`, dedupes by `place_id`.
  - Place Details for `getById`.
  - Maps Google API status codes to `Failure` variants: `OVER_QUERY_LIMIT → quota`, `REQUEST_DENIED → permission`, `INVALID_REQUEST → platform`, `ZERO_RESULTS → ok with []`, `DioException timeout/connectionError → network`.
  - **EV category explicitly refused** — returns `Failure.platform` directing callers to `RoutePoiService` (which has the EV adapter). Keeps the existing OCM + Google-EV-detection-gate pipeline untouched.
  - Initial bug fix: changed the `PoiRepository` interface (session 2) from `google_maps_flutter.LatLng` to `core/utils/polyline_decoder.dart` `LatLng`, matching the rest of the service layer.
  - `pois_providers.dart` now binds `poiRepositoryProvider` to `GooglePlacesPoiSource(googleDio)` instead of throwing.

- `P1-009` — `RoutePoiService`:
  - `lib/core/services/route_poi_service.dart` — generic route-aware POI lookup. Dispatches by `PoiCategory`:
    - `ev` → delegates to existing `RouteStationService.analyzeRoute(from, to)` (which still runs OCM + Google EV merge + gap detection). Maps `ChargingStation` → `Poi(category: ev, source: ocm/google, attributes: { operator, usage_type, connections, … })`. The "adapter" the task requires.
    - other categories → resolves origin/destination/polyline via existing `Geocoding` + `Directions`, then calls `PoiRepository.searchAlongRoute`.
  - Returns `Either<Failure, RoutePoiResult { route, pois }>`. Translates `GeocodingException` / `LocationException` / `DirectionsException` into the typed `Failure` taxonomy.
  - `findInCorridor(route, category)` variant skips re-resolution for callers that already have a `RouteInfo` (e.g. active-trip alerts in `P1-023`).
  - `RouteStationService` is **untouched** — existing PlanController + station screens keep working without churn (the "Keep existing station screens working through an adapter" requirement).
  - Wired as `routePoiServiceProvider` in `pois_providers.dart`.

- `P1-010` — Community schema generalization:
  - New enum `CommunityTargetType { station, poi }` at `lib/features/community/domain/community_target_type.dart` with `wireValue` ('station'/'poi') and `fromWire` parser.
  - `StationCommunityReport` gets `targetType` (default `station`) + `targetKey` (nullable) + a derived `effectiveTargetKey` getter that falls back to `stationKey` for old records.
  - `StationCommunitySubmitInput` gets the same two fields with same defaults.
  - DTO `toCreateMap` mirrors `stationKey` into `targetKey` for station targets — so the upcoming `P1-051` query-by-targetKey path serves both target types from a single index.
  - DTO `fromDocument` reads both fields with back-compat fallback (old docs → `targetType: station`, `targetKey: stationKey`).
  - `lib/features/pois/domain/community_poi_key.dart` — `communityPoiKey(Poi)` returns `poi_<sanitized Poi.id>`, ensuring no key-space collisions with `stationKey` (which uses `u_…` / `ocm_…` / `sid_…`).
  - **No existing Firestore docs need migration** — schema change is purely additive.

### Files changed

```
M  docs/ai_context/codebase_map.md
M  docs/ai_context/progress_log.md
M  docs/context/current_state.md
M  lib/features/community/data/dto/station_community_report_dto.dart
M  lib/features/community/domain/models/station_community_report.dart
M  lib/features/community/domain/models/station_community_submit_input.dart
M  lib/features/pois/data/repository/poi_repository.dart
M  lib/features/pois/presentation/controller/pois_providers.dart
M  project_plan/notion_tracker.md
M  project_plan/tasks.csv
A  docs/ai_context/RESUME_PROMPT.md
A  lib/core/services/route_poi_service.dart
A  lib/features/community/domain/community_target_type.dart
A  lib/features/pois/data/repository/google_places_poi_source.dart
A  lib/features/pois/domain/community_poi_key.dart
(plus regenerated .freezed.dart for the touched community models)
```

### Validation

- `dart run build_runner build --delete-conflicting-outputs` clean.
- `flutter analyze` clean across the whole project.
- No regression in existing EV flow — `RouteStationService` and `GoogleEvStationService` untouched.
- Not driven by `flutter run` — left for you per the session-wise commit workflow.

### Suggested commit message

```
feat(phase1): POI data path + community schema generalize (session 3)

P1-008 GooglePlacesPoiSource — concrete PoiRepository for 15 categories
       (EV deliberately refused — served via RoutePoiService adapter)
P1-009 RoutePoiService — dispatches by PoiCategory, EV via RouteStationService
       ChargingStation→Poi adapter; non-EV via PoiRepository
P1-010 community report schema adds targetType + targetKey (back-compat with
       stationKey); communityPoiKey helper for POI pulses
```

### Open follow-ups carried to later sessions

- `RouteStationService` is now a private dependency of `RoutePoiService`; new callers should consume `routePoiServiceProvider` not `routeStationServiceProvider`. Old PlanController still uses the station-typed one — fine, will be migrated in `P1-018`.
- Google Places **Nearby Search** is on the legacy endpoint. Migration to "Places API (New)" is a Phase 4 hardening task — out of scope now.
- No on-device cache for POI fetches yet; that's `P1-043` (corridor cache).
- `community_report_repository.dart` still only queries by `stationKey`. `P1-051` extends it to query by `targetKey` so POI pulses can read.
- `firestore.indexes.json` still has no `targetKey + createdAt` composite index — added in `P1-055`.

---

## Session 2 — Profile experience + POI scaffold

- **Started:** 2026-05-28
- **Finished:** 2026-05-28
- **Tasks completed (6/6):** `P1-007`, `P1-061`, `P1-004`, `P1-032`, `P1-033`, `P1-005`
- **Theme:** wire session-1 models into the actual app — typed `Failure` taxonomy, POI feature scaffold, profile slice with Hive + Firestore mirror, post-onboarding setup screen gating AppShell, edit screen, and per-trip vehicle/preference overrides on the plan input.

### Per-task notes

- `P1-007` — Scaffolded `lib/features/pois/`:
  - `data/repository/poi_repository.dart` — abstract `PoiRepository` with `searchAlongRoute`, `searchNearby`, `getById`. Uses `Either<Failure, T>`.
  - `presentation/controller/pois_providers.dart` — `poiRepositoryProvider` deliberately throws `UnimplementedError` so anyone touching it before `P1-008` gets a loud error.
  - Introduced canonical `Failure` sealed class at `lib/core/utils/failure.dart` with all 6 variants (`network`, `permission`, `index`, `firestore`, `platform`, `quota`) + `actionLabel` getter mapping to the UI CTA per the cursor rule.

- `P1-061` — Documented the `PoiRepository` contract with a Failure-variant table and per-method "expected failures" line. Concrete impls in `P1-008` are obligated to cover the variants the interface declares.

- `P1-004` — Profile slice:
  - `domain/profile_data.dart` — bundles `Vehicle?` + `UserPreferences`, with `isVehicleSetupComplete` getter.
  - `data/local_db/profile_box.dart` — Hive read/write helpers; box opens at app boot in `main.dart`.
  - `data/repository/profile_repository.dart` — `readLocal()` (sync from Hive), `hydrateFromFirestore(uid)` (best-effort merge), `save({uid, data})`. All errors map to `Failure` variants via `_mapFirebase`.
  - `presentation/controller/profile_ui_state.dart` — Freezed sealed `ProfileUiState` `{ idle, saving, errored }`, every variant carries the latest `data` so the UI never flickers blank.
  - `presentation/controller/profile_controller.dart` — `StateNotifier`; on init reads Hive sync, kicks off Firestore hydrate in background, exposes `updateDraftVehicle`, `updateDraftPreferences`, `save()`.
  - `presentation/controller/profile_providers.dart` — `profileBoxProvider`, `profileRepositoryProvider`, `profileControllerProvider.autoDispose` keyed implicitly by the signed-in user.

- `P1-032` — Profile setup screen:
  - Reusable widgets `widget/vehicle_picker.dart` (2x2 tile grid) and `widget/preferences_chips.dart` (flag chips + budget tier segmented row).
  - `view/profile_setup_screen.dart` — composes both widgets + "Save and continue" button; disables until vehicle is chosen.
  - `view/vehicle_setup_gate.dart` — new gate. `AuthGate` now routes `AuthReady → VehicleSetupGate → ProfileSetupScreen | AppShell` depending on `profile.isVehicleSetupComplete`.

- `P1-033` — `view/profile_edit_screen.dart` — edit-mode counterpart to setup screen (real `AppBar`, "Save changes" CTA, pops on success). Reached from the existing profile popup in `app_top_bar.dart` via a new "Trip preferences" menu entry (`_ProfileAction.tripPreferences`).

- `P1-005` — Plan input vehicle + preferences:
  - New widget `lib/features/plan/presentation/widget/trip_context_row.dart` — 4-tile vehicle row + wrap of 6 toggleable preference chips.
  - `route_input_card.dart` now requires `vehicle`, `preferences`, `onVehicleChanged`, `onPreferencesChanged` and renders the trip context above FROM/TO.
  - `plan_screen.dart` holds per-trip override state (`_tripVehicle`, `_tripPreferences`) defaulting to the saved profile; `_onReset()` clears them so each plan starts fresh. **No write-back to profile** — these are scoped to the current trip. PlanController consumption lands in `P1-018`.

### Files changed

```
M  docs/ai_context/progress_log.md
M  lib/core/widgets/app_top_bar.dart
M  lib/features/auth/presentation/view/auth_gate.dart
M  lib/features/plan/presentation/view/plan_screen.dart
M  lib/features/plan/presentation/widget/route_input_card.dart
M  lib/main.dart
M  project_plan/notion_tracker.md
M  project_plan/tasks.csv
A  lib/core/utils/failure.dart
A  lib/core/utils/failure.freezed.dart
A  lib/features/plan/presentation/widget/trip_context_row.dart
A  lib/features/pois/data/repository/poi_repository.dart
A  lib/features/pois/presentation/controller/pois_providers.dart
A  lib/features/profile/data/local_db/profile_box.dart
A  lib/features/profile/data/repository/profile_repository.dart
A  lib/features/profile/domain/profile_data.dart
A  lib/features/profile/domain/profile_data.freezed.dart
A  lib/features/profile/domain/profile_data.g.dart
A  lib/features/profile/presentation/controller/profile_controller.dart
A  lib/features/profile/presentation/controller/profile_providers.dart
A  lib/features/profile/presentation/controller/profile_ui_state.dart
A  lib/features/profile/presentation/controller/profile_ui_state.freezed.dart
A  lib/features/profile/presentation/view/profile_edit_screen.dart
A  lib/features/profile/presentation/view/profile_setup_screen.dart
A  lib/features/profile/presentation/view/vehicle_setup_gate.dart
A  lib/features/profile/presentation/widget/preferences_chips.dart
A  lib/features/profile/presentation/widget/vehicle_picker.dart
```

### Validation

- `dart run build_runner build --delete-conflicting-outputs` clean (5 new outputs across the session).
- `flutter analyze` clean across the whole project. No regressions in pre-existing features.
- Not yet test-driven by `flutter run` — left for you to verify per your session-wise commit workflow.

### Suggested commit message

```
feat(phase1): profile experience + POI scaffold (session 2)

P1-007 lib/features/pois/ scaffold + Failure sealed class
P1-061 PoiRepository documents all 6 Failure variants per method
P1-004 lib/features/profile/ slice (Hive + Firestore mirror, Either<Failure, T>)
P1-032 profile setup screen — gates AppShell via VehicleSetupGate
P1-033 profile edit screen reachable from app top bar
P1-005 plan input adds vehicle row + preference chips (per-trip overrides)
```

### Open follow-ups carried to later sessions

- `PoiRepository` has no concrete implementation; the provider throws on read. Concrete `GooglePlacesPoiSource` lands in `P1-008`.
- The per-trip vehicle/preferences in `PlanScreen` don't yet flow into `PlanController.analyzeRoute(...)` — `P1-018` extends the model + controller to consume them.
- Existing `UserProfileRepository` (auth) still uses raw exceptions, not `Either<Failure, T>` — intentional, not in scope. Will be migrated only when a real bug requires it.
- Existing `CommunityReportRepository` still uses `Either<String, T>` with prefix strings — same reason; will migrate when touched again.

---

## Session 1 — Phase 1 foundation models

- **Started:** 2026-05-28
- **Finished:** 2026-05-28
- **Tasks completed (8/8):** `P1-001`, `P1-002`, `P1-063`, `P1-003`, `P1-031`, `P1-006`, `P1-022`, `P1-029`
- **Theme:** rebrand + foundation domain models (Vehicle, UserPreferences, Poi, Alert) + product README + notification/connectivity deps.

### Per-task notes

- `P1-001` — `pubspec.yaml` description set to `"AI Highway Companion for Indian road trips"`.
- `P1-002` — `MaterialApp.title` in `lib/main.dart` set to `"TripPlus — Highway Companion"`.
- `P1-063` — Added `flutter_local_notifications: ^17.2.4` and `connectivity_plus: ^6.1.0`. `flutter pub get` succeeded; lockfile committed. **Native Android/iOS wiring still owed to `P1-027`.**
- `P1-003` — `lib/core/domain/vehicle.dart`: `VehicleType { petrol, diesel, ev, bike }` + `Vehicle` freezed (`type`, `nickname?`, `fuelEfficiencyKmpl?`, `batteryKwh?`, `connectorTypes[]`, `fastChargeOnly`). Convenience getters `isElectric`, `burnsFuel`. Full JSON support.
- `P1-031` — `lib/core/domain/user_preferences.dart`: all flag fields per spec + `BudgetTier { low, mid, high }`. Convenience getter `hasSafetyOverlay`.
- `P1-006` — `lib/core/domain/poi.dart`: 16-item `PoiCategory` with `label` + stable `wireValue` (used later for `targetKey` prefixes). `PoiSource { googlePlaces, ocm, community, curated, unknown }` with badge labels. `Poi` uses primitive `latitude`/`longitude` to match `ChargingStation` style and stay decoupled from `google_maps_flutter`. Free-form `attributes` map.
- `P1-022` — `lib/features/alerts/domain/alert.dart`: `AlertType` enum covers Phase 1 (`fuelLow`, `evGap`, `foodWindow`) **and** Phase 2 (`ghat`, `night`, `fatigue`, `weather`) so the enum doesn't need to change later. `AlertSeverity { info, warning, critical }`. Created the `alerts/domain/` folder.
- `P1-029` — Replaced default Flutter README with product README (positioning, six principles, stack, repo layout, run steps, screenshots placeholder, roadmap, contribution notes).

### Files changed

```
M  README.md
M  docs/context/current_state.md
M  lib/main.dart
M  project_plan/notion_tracker.md
M  project_plan/tasks.csv
M  pubspec.lock
M  pubspec.yaml
A  docs/ai_context/codebase_map.md
A  docs/ai_context/open_questions.md
A  docs/ai_context/progress_log.md
A  lib/core/domain/vehicle.dart
A  lib/core/domain/vehicle.freezed.dart
A  lib/core/domain/vehicle.g.dart
A  lib/core/domain/user_preferences.dart
A  lib/core/domain/user_preferences.freezed.dart
A  lib/core/domain/user_preferences.g.dart
A  lib/core/domain/poi.dart
A  lib/core/domain/poi.freezed.dart
A  lib/core/domain/poi.g.dart
A  lib/features/alerts/domain/alert.dart
A  lib/features/alerts/domain/alert.freezed.dart
A  lib/features/alerts/domain/alert.g.dart
M  macos/Flutter/GeneratedPluginRegistrant.swift   (auto from pub get)
M  windows/flutter/generated_plugin_registrant.cc  (auto from pub get)
M  windows/flutter/generated_plugins.cmake         (auto from pub get)
```

### Validation

- `dart run build_runner build --delete-conflicting-outputs` — wrote 25 outputs, no errors.
- `flutter analyze` — clean across the whole project.

### Suggested commit message

```
feat(phase1): foundation models + rebrand (session 1)

P1-001 pubspec description → AI Highway Companion
P1-002 MaterialApp title → TripPlus — Highway Companion
P1-063 add flutter_local_notifications + connectivity_plus
P1-003 lib/core/domain/vehicle.dart (VehicleType, Vehicle)
P1-031 lib/core/domain/user_preferences.dart (UserPreferences, BudgetTier)
P1-006 lib/core/domain/poi.dart (Poi, PoiCategory x16, PoiSource)
P1-022 lib/features/alerts/domain/alert.dart (Alert, AlertType, AlertSeverity)
P1-029 product README
```

### Open follow-ups carried to later sessions

- The four new Freezed types are defined but **not wired** into any feature yet — that's session 2's job.
- `flutter_local_notifications` native Android/iOS plumbing → `P1-027` (later session).
