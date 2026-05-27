# Current State (rolling snapshot)

> **Update this file** whenever a task materially changes the user-visible surface or the architecture.
> AI agents read this first to avoid re-discovering what's already built.

**Last updated:** 2026-05-27 (initial baseline at start of Phase 1 planning).

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

## NOT implemented (Phase 1 targets)

These are explicitly the gap between "today" and "PDF MVP":

- ❌ Vehicle profile (Petrol / Diesel / EV / Bike).
- ❌ User preferences (pure-veg, family, women-safe, fast-chargers-only, …).
- ❌ Generic `Poi` domain (only `ChargingStation`).
- ❌ Smart Intelligence Grid screen.
- ❌ Route-aware POI discovery for non-station categories.
- ❌ Distance-based alert engine + local notifications.
- ❌ Active Trip state + offline corridor cache.
- ❌ Trip Dashboard / Smart Trip Timeline widgets.
- ❌ Community pulses on non-station POIs.

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
