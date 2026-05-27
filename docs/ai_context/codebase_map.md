# Codebase quick-map

> File paths I (the AI) need to remember across sessions. Not exhaustive — only what I have to touch repeatedly.

## Entry points
- `lib/main.dart` — app bootstrap, Hive boxes, Firebase init.
- `pubspec.yaml` — deps + product description.
- `firebase/firestore.indexes.json` — composite indexes (extend for `targetKey + createdAt` in `P1-055`).

## Core
- `lib/core/services/` — `directions_service.dart`, `geocoding_service.dart`, `google_ev_station_service.dart`, `places_autocomplete_service.dart`, `route_station_service.dart`.
- `lib/core/utils/` — `location_helper.dart`, `polyline_decoder.dart`, `result.dart` (Freezed Result type), `station_merger.dart`.
- `lib/core/theme/` — `app_theme.dart`, plus `AppColors` / `AppTextStyles`.
- `lib/core/constants/cache_constants.dart` — Hive box names.
- `lib/core/domain/` — cross-feature domain models.
  - `vehicle.dart` — `VehicleType` enum + `Vehicle` freezed (created `P1-003`).
  - `user_preferences.dart` — `UserPreferences` + `BudgetTier` (created `P1-031`).
  - `poi.dart` — `Poi`, `PoiCategory` (16 items), `PoiSource` (created `P1-006`).

## Features (today)
- `auth/` `data domain presentation`
- `onboarding/`
- `shell/presentation/view/app_shell.dart`
- `plan/presentation/` — `RouteInputCard`, `PlanController`, `PlanState`, `PlanResultView`.
- `stations/presentation/` — list + map screens, station detail.
- `community/` `data domain presentation` — Firestore-backed pulses; offline queue; widgets `CommunityReportsSection`, `CommunityRatingPulse`.
- `charging/`
- `insights/`
- `alerts/`
  - `domain/alert.dart` — `Alert`, `AlertType` (Phase 1+2 values), `AlertSeverity` (created `P1-022`).
  - `presentation/` — view + widget folders exist; not yet populated by Phase 1 work.

## Hive boxes already open in `main.dart`
- `CacheConstants.chargingBoxName` — existing.
- `CommunitySubmitQueue.boxName` (`community_submit_queue`) — existing.
- New boxes to open in upcoming tasks: `user_profile` (`P1-004`), `active_trip` (`P1-041`), `corridor_cache` (`P1-043`).

## Build-runner
After ANY change to a `*.freezed.dart` source class, run:

```
dart run build_runner build --delete-conflicting-outputs
```
