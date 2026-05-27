# AGENTS.md — TripPlus

> Canonical context file for AI coding agents (Cursor, Claude, Codex, etc.) working on this repository.
> Read this **first** before doing any work. Following these rules saves tokens (no need to re-discover patterns) and keeps the codebase consistent.

---

## 1. What this project is

**TripPlus** = *India's Smart Highway Companion / AI Copilot for Road Trips*.

Flutter mobile app (Android + iOS first, Windows scaffold present) that helps road travelers:

- Plan multi-vehicle routes (Petrol / Diesel / EV / Bike).
- Discover **route-aware** POIs along the corridor — fuel pumps, EV chargers, restaurants, washrooms, hotels, ATMs, hospitals, mechanics, scenic stops, temples, etc.
- Get **predictive distance-based alerts** ("Last trusted pump for next 68 km").
- See **community-sourced trust signals** (pulses) on every stop with reliability score, freshness, conflict-aware timeline.
- (Future) Talk to an **AI travel assistant**.

We are **not** a maps app. We position as `"AI Copilot for Indian Road Trips"`.

The product vision and the canonical source for *what* we're building is the PDF at:
`/Users/surajjadhav/Documents/Work/trippluse docs/Smart_Highway_Companion_Idea.pdf`
mirrored and elaborated in `project_plan/00_overview.md` and `tripplus_notion.md`.

---

## 2. Where to look (files that answer 80% of questions)

| Question | File |
|---|---|
| What are we building right now? | `project_plan/01_phase_1_mvp.md` |
| What's the active phase / task IDs? | `project_plan/notion_tracker.md` and `project_plan/tasks.csv` |
| Why did we make decision X? | `docs/context/decisions.md` (ADR log) |
| What's the system architecture? | `docs/architecture/system_overview.md` |
| How does data flow? | `docs/architecture/data_flow.md` |
| What's the user workflow? | `docs/architecture/user_workflow.md` |
| Define X term | `docs/context/glossary.md` |
| Current product state | `docs/context/current_state.md` |
| Folder conventions | `docs/architecture/folder_structure.md` |
| Reliability UX status | `RELIABILITY_PHASES.md` |
| Community reports schema | `COMMUNITY_REPORTS.md` |

If a question isn't answered there, write the answer **into the relevant file** as you discover it. That's how we keep this repo cheap to load into context.

---

## 3. Tech stack (don't introduce alternatives without an ADR)

- **Framework:** Flutter (Material), Dart SDK `^3.11.4`
- **State management:** Riverpod (`flutter_riverpod ^2.6.x`) — *no Provider, no Bloc, no GetX, no Redux*
- **Models:** **Freezed** + **json_serializable** (always run `dart run build_runner build --delete-conflicting-outputs` after model changes)
- **Error handling:** **fpdart `Either<Failure, T>`** for repository writes; AsyncValue for reads
- **HTTP:** Dio
- **Local storage:** Hive (boxes: `charging`, `community_submit_queue`, `user_profile`, `active_trip`, `corridor_cache`)
- **Backend:** Firebase (Auth, Firestore, FCM later, Crashlytics + Analytics later)
- **Maps:** `google_maps_flutter`
- **Location:** `geolocator` (+ Android foreground service for active-trip tracking)
- **Notifications:** `flutter_local_notifications` (add when starting `P1-027`)
- **Media:** `image_picker` + `flutter_image_compress` (community photos stored as **base64 JPEG inline on Firestore docs** — NOT Firebase Storage)
- **Env:** `flutter_dotenv` from `.env` (assets-bundled)

When unsure which lib to use, prefer:
- existing repo pattern → community convention → `pub.dev` quality (likes, last update, null-safety).

---

## 4. Folder structure (feature-slice)

```
lib/
  core/                          ← cross-cutting
    constants/                   ← API keys names, cache keys
    domain/                      ← cross-feature value types (e.g. Vehicle, Poi)
    services/                    ← thin SDK/API clients
    theme/                       ← AppTheme / AppColors / AppTextStyles
    utils/                       ← pure helpers (polyline_decoder, station_merger, result.dart)
    widgets/                     ← reusable atoms (AppTopBar, GradientCard, etc.)
  features/
    <feature>/
      data/
        dto/                     ← *_dto.dart Firestore/HTTP boundary types
        repository/              ← *_repository.dart returns Either<Failure, T>
        local_db/                ← Hive box managers / queues
      domain/
        models/                  ← Freezed entities + UI state types
      presentation/
        controller/              ← Riverpod controllers + providers
        view/                    ← Full screens
        widget/                  ← Feature-private widgets (singular)
        widgets/                 ← (community uses plural; either is OK — keep consistent inside a feature)
  firebase_options.dart
  main.dart
```

**Rules:**

- One **feature folder per top-level user concept** (auth, charging, community, plan, stations, pois, discovery, profile, trip, alerts, ai_copilot, safety, …).
- A feature **never imports another feature's `data/` or `domain/` internals directly** — only its public providers or domain models via barrel-style imports.
- Anything reused by 2+ features moves to `lib/core/`.

Full spec in `docs/architecture/folder_structure.md`.

---

## 5. Code conventions (the short list)

### Naming

- File names: `snake_case.dart`.
- Classes / enums: `PascalCase`.
- Variables / methods: `camelCase`.
- Private = leading underscore. Use it liberally.
- Freezed models: `class StationCommunityReport with _$StationCommunityReport`.

### Models

- Always `freezed` if it has > 2 fields or is on a public API boundary.
- Always provide a `fromJson` / `toJson` via `json_serializable` when it crosses the Firestore or HTTP boundary.
- Generated files: `*.freezed.dart`, `*.g.dart` — committed.

### Repositories

- Public methods return `Future<Either<Failure, T>>` for writes / one-shot reads.
- Streams (`watchX`) return `Stream<T>` directly.
- Errors map to error-taxonomy prefixes: `network`, `permission`, `index`, `firestore`, `platform`, `quota`. Never throw raw strings to the UI.

### Controllers

- `StateNotifier<UiState>` (or `AsyncNotifier` for newer code). Don't put business logic in widgets.
- UI state types are **Freezed** sealed unions (`initial`, `loading`, `data`, `error`).
- `controller_providers.dart` exposes a `family.autoDispose` where the key is the stable identity (e.g. `stationKey`, `poiKey`, `tripId`).

### Widgets

- Stateless first; only `StatefulWidget` when you have local controllers.
- Always pass `key` for list items.
- No business logic inside `build()`. Move to a controller.
- Use the existing `AppColors`, `AppTextStyles`, `AppTheme` — never raw `Colors.blue`.

### Async + Riverpod

- Read in widgets via `ref.watch(provider)` for builds, `ref.read(provider.notifier)` for actions.
- Use `AsyncValue.when(data, loading, error)` for read providers; never `provider.value!`.

### Comments

- Don't narrate code. Comments explain **non-obvious intent, trade-offs, or constraints**.

Full style notes in `.cursor/rules/flutter-style.mdc`.

---

## 6. Reliability rules (non-negotiable — from `RELIABILITY_PHASES.md`)

These are **product-level** rules. AI agents must check every new feature against them.

1. **Confidence visibility** — anywhere we show a rating, show sample size + freshness. Show a low-confidence badge if reports are stale or too few.
2. **Silent-failure proofing** — every repository surfaces actionable error categories, every UI must map them to the right CTA (`Open settings`, `Retry now`, …).
3. **Offline-first writes** — any user write that can fail (community report, trip save, preferences) goes through a local Hive queue with retry.
4. **Stable target identity** — never use raw Google/OCM ids alone. Always go through a normalized key function (`communityStationKey(station)`; in Phase 1 we add `communityPoiKey(poi)` with the same `u_<uuid>` / `<source>_<id>_<lat5>_<lng5>` pattern).
5. **Predictive, not reactive** — alerts and recommendations must look *ahead* on the corridor, not behind.
6. **No deletion of community data** — community reports are an immutable log (Firestore rules already deny update/delete).

---

## 7. Firestore conventions

- **Collections:**
  - `users/{uid}` — profile + preferences mirror
  - `stationCommunityReports` — community pulses for stations *and* (post `P1-050`) POIs (discriminator: `targetType` + `targetKey`)
- **Reads:** `where('targetKey', == k)` then sort in-app, truncate to 50. No `orderBy` unless we have the composite index deployed (`firebase/firestore.indexes.json`).
- **Photos:** base64 JPEG inline on the document. Compress to keep doc size under safe Firestore limits. **Do not use Firebase Storage** — keeps reads cheap and consistent for community feed.
- **Security rules:** public read, authenticated create only, `reporterUserId == request.auth.uid`, immutable (no update/delete). See `firebase/firestore.rules`.

---

## 8. Build & dev commands

```bash
# Get deps
flutter pub get

# Code generation (after editing freezed/json models)
dart run build_runner build --delete-conflicting-outputs

# Run
flutter run

# Tests
flutter test

# Lints
flutter analyze
```

---

## 9. How to add a new feature (the recipe)

1. Pick (or create) a task ID in `project_plan/`.
2. Create the feature slice under `lib/features/<feature>/` with `data/`, `domain/`, `presentation/` subfolders.
3. Write the **Freezed** domain models first.
4. Write the **repository interface** (abstract class) + at least one implementation that returns `Either<Failure, T>`.
5. Write the **Riverpod providers** in `presentation/controller/<feature>_providers.dart`.
6. Write the **controller** as `StateNotifier<<Feature>UiState>` watching the repository stream.
7. Write the **view** consuming the controller via `ref.watch`.
8. Write the **widget** atoms in `presentation/widget/`.
9. Run `dart run build_runner build --delete-conflicting-outputs`.
10. Update `docs/context/current_state.md` if the user-visible surface changed.
11. Mark the task IDs done in `project_plan/`.

---

## 10. What to **never** do

- ❌ Don't introduce a new state-management lib.
- ❌ Don't bypass Riverpod and call repositories from widgets.
- ❌ Don't store images in Firebase Storage for community reports (we use inline base64 by design).
- ❌ Don't break the community report schema (only **add** fields).
- ❌ Don't query Firestore with `orderBy` that requires an index unless that index is in `firestore.indexes.json` and deployed.
- ❌ Don't reach for sponsored / monetization changes — those are Phase 4.
- ❌ Don't add raw color/text-style literals; use the theme.
- ❌ Don't bypass `permission_handler` for sensitive permissions.

---

## 11. When in doubt

1. Find the closest existing pattern (community feature is the most modern reference).
2. Match it.
3. If you're genuinely picking between two paths, write a new ADR in `docs/context/decisions.md` and ship the smaller one.

---

*This file is the canonical AI context. Keep it short and current. If you add a new top-level concept (a new feature slice, a new backend, a new key dependency), update sections 2–4 in the same PR.*
