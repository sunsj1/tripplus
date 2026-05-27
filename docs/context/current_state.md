# Current State (rolling snapshot)

> **Update this file** whenever a task materially changes the user-visible surface or the architecture.
> AI agents read this first to avoid re-discovering what's already built.

**Last updated:** 2026-05-28 (Phase 1 foundation batch landed — see `Phase 1 progress` below).

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

## Phase 1 progress

### Foundation batch — done (2026-05-28, session 1)

- ✅ Internal rebrand: pubspec description + MaterialApp title (`P1-001`, `P1-002`).
- ✅ Product README replaces default Flutter README (`P1-029`).
- ✅ `flutter_local_notifications` + `connectivity_plus` added to pubspec (`P1-063`). Native platform setup still owed to `P1-027`.
- ✅ `lib/core/domain/vehicle.dart` — `VehicleType` enum + `Vehicle` freezed entity (`P1-003`).
- ✅ `lib/core/domain/user_preferences.dart` — `UserPreferences` + `BudgetTier` (`P1-031`).
- ✅ `lib/core/domain/poi.dart` — `Poi` freezed entity, `PoiCategory` (16 items), `PoiSource` enum with badge labels (`P1-006`).
- ✅ `lib/features/alerts/domain/alert.dart` — `Alert`, `AlertType` (Phase 1+2 values), `AlertSeverity` (`P1-022`).

These models are **defined but not yet wired** into any feature. Wiring lands in the next batch (`P1-004`, `P1-007`, …).

### NOT implemented (remaining Phase 1 targets)

- ❌ `lib/features/profile/` feature slice + Hive persistence (`P1-004`, `P1-032`, `P1-033`).
- ❌ `lib/features/pois/` feature slice + Google Places along-route source (`P1-007`, `P1-008`).
- ❌ Generalize `route_station_service.dart` → `route_poi_service.dart` (`P1-009`).
- ❌ Smart Intelligence Grid screen (`P1-011` → `P1-015`).
- ❌ AppShell tab revision (`P1-016`, `P1-017`).
- ❌ Trip dashboard + smart trip timeline (`P1-018` → `P1-021`).
- ❌ Alert engine rules + notifier + local notification plumbing (`P1-023` → `P1-028`, `P1-034`).
- ❌ Active Trip + foreground location + corridor cache (`P1-040` → `P1-044`).
- ❌ Community schema generalization (`targetType`/`targetKey`) on POIs (`P1-050` → `P1-055`).

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
