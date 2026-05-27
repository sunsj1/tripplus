# Current State (rolling snapshot)

> **Update this file** whenever a task materially changes the user-visible surface or the architecture.
> AI agents read this first to avoid re-discovering what's already built.

**Last updated:** 2026-05-28 (Phase 1 sessions 1 + 2 landed — foundation models + profile experience + POI scaffold).

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

## Phase 1 progress (14/50 = 28%)

### Session 1 — foundation models (2026-05-28)

- ✅ Internal rebrand: pubspec description + MaterialApp title (`P1-001`, `P1-002`).
- ✅ Product README (`P1-029`).
- ✅ `flutter_local_notifications` + `connectivity_plus` deps (`P1-063`). Native setup still owed to `P1-027`.
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

### NOT implemented (remaining Phase 1 targets)

- ❌ `GooglePlacesPoiSource` (`P1-008`) — concrete `PoiRepository` impl.
- ❌ Generalize `route_station_service.dart` → `route_poi_service.dart` (`P1-009`).
- ❌ Smart Intelligence Grid screen (`P1-011` → `P1-015`).
- ❌ AppShell tab revision (`P1-016`, `P1-017`).
- ❌ Trip dashboard + smart trip timeline (`P1-018` → `P1-021`).
- ❌ Alert engine rules + notifier + local notification plumbing (`P1-023` → `P1-028`, `P1-034`).
- ❌ Active Trip + foreground location + corridor cache (`P1-040` → `P1-044`).
- ❌ Community schema generalization (`targetType`/`targetKey`) on POIs (`P1-050` → `P1-055`).
- ❌ Hygiene: telemetry hooks (`P1-060`), skeleton loaders (`P1-062`), Crashlytics init (`P1-064`), launch icon/splash (`P1-030`).

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
