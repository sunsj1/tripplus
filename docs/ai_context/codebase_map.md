# Codebase quick-map

> File paths I (the AI) need to remember across sessions. Not exhaustive — only what I have to touch repeatedly.

## Entry points
- `lib/main.dart` — app bootstrap, Hive boxes, Firebase init.
- `pubspec.yaml` — deps + product description.
- `firebase/firestore.indexes.json` — composite indexes (extend for `targetKey + createdAt` in `P1-055`).

## Core
- `lib/core/services/` — `directions_service.dart`, `geocoding_service.dart`, `google_ev_station_service.dart`, `places_autocomplete_service.dart`, `route_station_service.dart`.
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
- `shell/presentation/view/app_shell.dart` — tabs still Plan · Insights · Stations; will be revised in `P1-016`.
- `plan/presentation/` — `RouteInputCard` (now takes vehicle + preferences, `P1-005`), `TripContextRow` widget, `PlanController`, `PlanState`, `PlanResultView`. `PlanScreen` holds per-trip override state for vehicle + preferences.
- `stations/presentation/` — list + map screens, station detail.
- `community/` `data domain presentation` — Firestore-backed pulses; offline queue; widgets `CommunityReportsSection`, `CommunityRatingPulse`. **Still uses `Either<String, T>` prefix strings** — not migrated to typed `Failure` yet.
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
  - `presentation/view/` — `vehicle_setup_gate.dart`, `profile_setup_screen.dart`, `profile_edit_screen.dart`.
  - `presentation/widget/` — `vehicle_picker.dart`, `preferences_chips.dart`.
- `pois/` — scaffolded in `P1-007`. No concrete impl yet.
  - `data/repository/poi_repository.dart` — abstract `PoiRepository` (`searchAlongRoute`, `searchNearby`, `getById`).
  - `presentation/controller/pois_providers.dart` — `poiRepositoryProvider` throws until `P1-008`.

## Hive boxes already open in `main.dart`
- `CacheConstants.chargingBoxName` — existing.
- `CommunitySubmitQueue.boxName` (`community_submit_queue`) — existing.
- `ProfileBox.boxName` (`user_profile`) — opened in `P1-004`.
- New boxes still to open: `active_trip` (`P1-041`), `corridor_cache` (`P1-043`).

## Build-runner
After ANY change to a `*.freezed.dart` source class, run:

```
dart run build_runner build --delete-conflicting-outputs
```
