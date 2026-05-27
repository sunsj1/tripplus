# AI progress log

> Append-only, session-wise record. Each session is a self-contained commit unit.
> Format per session: header → tasks → files changed → notes / follow-ups.
> Newest at the top.

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
