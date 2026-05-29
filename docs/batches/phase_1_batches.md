# Phase 1 — Session-by-session batch plan

> **Purpose.** Phase 1 has ~50 tasks (`P1-001` … `P1-065`). This file slices
> them into commit-sized **sessions** so the work flows predictably across
> machines / AI tools / days. Each session is one commit.
>
> **How to use.**
> - Resuming with a fresh AI? Paste `docs/ai_context/RESUME_PROMPT.md`. The
>   prompt instructs the model to look up this file and pick up at the next
>   `Not started` session.
> - Want to skip ahead? Tell the AI "start session N". The AI will validate
>   that every dependency of every task in that session is `Done` first.
> - Need to re-balance? Move tasks between sessions in this file before
>   starting the new session. Don't move tasks once a session is in flight.
>
> **Rules per session.**
> 1. Mark each task `in_progress` when starting, `completed` when done.
> 2. Flip `Status` in `project_plan/tasks.csv` and tick the box in
>    `project_plan/notion_tracker.md` immediately on each completion.
> 3. Run `dart run build_runner build --delete-conflicting-outputs` after
>    any Freezed change; run `flutter analyze` after each task.
> 4. At session end: append a `## Session N — <theme>` block to the TOP of
>    `docs/ai_context/progress_log.md`; refresh `codebase_map.md` and
>    `current_state.md`.
> 5. Don't commit — the user commits per session.

---

## Status legend

- ✅ done
- 🔵 next up
- ⬜ planned

---

## ✅ Session 1 — Foundation models + rebrand

**Theme.** Internal rebrand, four foundation Freezed models, deps for the
alerts engine, product README.

**Tasks (8).**

| ID | Task |
|---|---|
| `P1-001` | pubspec description → "AI Highway Companion for Indian road trips" |
| `P1-002` | `MaterialApp.title` |
| `P1-063` | Add `flutter_local_notifications` + `connectivity_plus` |
| `P1-003` | `lib/core/domain/vehicle.dart` |
| `P1-031` | `lib/core/domain/user_preferences.dart` |
| `P1-006` | `lib/core/domain/poi.dart` (16-item `PoiCategory`) |
| `P1-022` | `lib/features/alerts/domain/alert.dart` |
| `P1-029` | Product README |

Done 2026-05-28. See `docs/ai_context/progress_log.md` for details.

---

## ✅ Session 2 — Profile experience + POI scaffold

**Theme.** Wire session-1 models into the actual app: typed `Failure` taxonomy,
POI feature scaffold, profile slice with Hive + Firestore mirror, post-onboarding
setup gate, edit screen, plan input chips.

**Tasks (6).**

| ID | Task |
|---|---|
| `P1-007` | `lib/features/pois/` scaffold + `Failure` sealed class |
| `P1-061` | `PoiRepository` documents all 6 `Failure` variants per method |
| `P1-004` | `lib/features/profile/` slice (Hive + Firestore mirror) |
| `P1-032` | `ProfileSetupScreen` + `VehicleSetupGate` gates `AppShell` |
| `P1-033` | `ProfileEditScreen` reachable from app top bar |
| `P1-005` | Plan input row: vehicle picker + preference chips |

Done 2026-05-28.

---

## ✅ Session 3 — POI data path + community schema generalize

**Theme.** Turn the `PoiRepository` scaffold into a working route-aware POI
source. Extend the community-report schema so pulses can attach to any POI.

**Tasks (3).**

| ID | Task |
|---|---|
| `P1-008` | `GooglePlacesPoiSource` — concrete `PoiRepository` for 15 categories |
| `P1-009` | `RoutePoiService` — dispatches by `PoiCategory`; EV adapter via `RouteStationService` |
| `P1-010` | `targetType` + `targetKey` on community report models + DTO; `communityPoiKey()` helper |

Done 2026-05-28.

---

## ✅ Session 4 — Community read path

**Theme.** Finish the community generalization started in session 3: extend
the repository / providers / Firestore index so anyone — station or POI — can
read pulses keyed by `targetKey`.

**Tasks (4).**

| ID | Task | Est | Depends on |
|---|---|---|---|
| `P1-050` | Verify Firestore community report schema — closeout from session 3 (DTO + index work) | 1 h | `P1-006` ✅ |
| `P1-051` | `CommunityReportRepository.watchByTargetKey(targetKey)` (keeps `watchStationReports(stationKey)` for back-compat) | 4 h | `P1-050` |
| `P1-052` | `poiCommunityControllerProvider.family.autoDispose` keyed by `targetKey` | 2 h | `P1-051` |
| `P1-055` | `firebase/firestore.indexes.json` — composite index `targetKey + createdAt desc` (note: run `firebase deploy --only firestore:indexes` after) | 1 h | `P1-050` |

Done 2026-05-28.

**Unblocks:** `P1-053`, `P1-054` (mounting community widgets on POI screens).

---

## ✅ Session 5 — Smart Intelligence Grid + Category screen

**Theme.** The iconic PDF screen. Render the 16-category grid; tap → route-aware
POI list using the session-3 data path; full error states.

**Tasks (5).**

| ID | Task | Est | Depends on |
|---|---|---|---|
| `P1-011` | `DiscoveryScreen` — 3-column grid of all `PoiCategory` items | 4 h | `P1-006` ✅ |
| `P1-013` | Wire grid taps → `PoiCategoryScreen` route | 1 h | `P1-012` |
| `P1-012` | `PoiCategoryScreen` reusable — route-aware list, distance chip, filter chips | 1 d | `P1-008` ✅, `P1-011` |
| `P1-014` | Empty / loading / error states using `Failure.actionLabel` | 3 h | `P1-012` |
| `P1-015` | Map view toggle on `PoiCategoryScreen` (reuse `station_map_screen.dart` pattern) | 4 h | `P1-012` |

Done 2026-05-28.

**Unblocks:** `P1-016` (Discover tab), `P1-053` / `P1-054` (POI community mount).

---

## ✅ Session 6 — POI community mount + AppShell tabs

**Theme.** Surface community pulses on every POI tile + detail; revise the
bottom nav from "Plan · Insights · Stations" to "Plan · Trip · Discover · Profile".

**Tasks (4).**

| ID | Task | Est | Depends on |
|---|---|---|---|
| `P1-053` | Mount `CommunityReportsSection` inside POI detail | 3 h | `P1-052`, `P1-012` |
| `P1-054` | Mount `CommunityRatingPulse` chip on every POI list tile | 2 h | `P1-052`, `P1-012` |
| `P1-016` | `AppShell` tabs → Plan · Trip · Discover · Profile (Trip can be a placeholder until `P1-017`) | 2 h | `P1-011`, `P1-033` ✅ |
| `P1-064` | Add Crashlytics dep (init only — deeper integration is Phase 2 `P2-071`) | 1 h | — |

Done 2026-05-28.

**Unblocks:** `P1-017` (Trip tab once Trip model exists).

---

## ✅ Session 7 — Trip Dashboard + Trip foundation

**Theme.** Trip control center: extend `PlanResult` with cost/time picture,
introduce `Trip` model and `ActiveTripController`, wire the Trip tab.

**Tasks (5).**

| ID | Task | Est | Depends on |
|---|---|---|---|
| `P1-018` | Extend `PlanResult` — `etaMinutes`, `tollsEstimate?`, `fuelEstimateCost?` (uses `vehicle.fuelEfficiencyKmpl`), `chargingEstimate?`, `weatherTag?`, `trafficLevel?` | 3 h | `P1-003` ✅ |
| `P1-019` | Trip Dashboard stat-card row in `plan_result_view.dart` | 4 h | `P1-018` |
| `P1-040` | `lib/features/trip/` + `Trip` freezed model + Hive box `active_trip` | 3 h | `P1-018` |
| `P1-041` | `ActiveTripController` start/pause/end + Hive persist | 6 h | `P1-040` |
| `P1-017` | Trip tab — active dashboard if any, else "Plan a trip" CTA | 4 h | `P1-040` |

Done 2026-05-30.

**Unblocks:** `P1-020` / `P1-021` (timeline), `P1-042` (foreground tracking),
`P1-043` (corridor cache), `P1-023` (alert engine needs trip context).

---

## ✅ Session 8 — Smart Trip Timeline + Active trip features

**Theme.** Visual trip plan; offline corridor cache; foreground location.

**Tasks (5/5 done).**

| ID | Task | Est | Depends on |
|---|---|---|---|
| `P1-020` ✅ | Smart Trip Timeline widget — vertical timeline of stops | 1 d | `P1-008` ✅, `P1-019` |
| `P1-021` ✅ | Timeline editor — pin/unpin POI suggestions | 6 h | `P1-020` |
| `P1-042` ✅ | Foreground location tracking (opt-in) + Android foreground service | 1 d | `P1-041` |
| `P1-043` ✅ | Offline corridor cache — polyline + station IDs in Hive box `corridor_cache` | 6 h | `P1-040`, `P1-008` ✅ |
| `P1-044` ✅ | Offline detection + degraded mode banner | 3 h | `P1-043` |

---

## ✅ Session 9 — Alert engine MVP — rules + platform setup

**Theme.** The "predictive, not reactive" principle becomes real. Three
distance-based rules + the engine that fires them. `flutter_local_notifications`
native plumbing.

**Tasks (5/5 done).**

| ID | Task | Est | Depends on |
|---|---|---|---|
| `P1-023` ✅ | `AlertEngine` rule evaluator (pure Dart) — `(activeRoute, currentLocation, vehicle, preferences, upcomingPois) → List<Alert>` | 1.5 d | `P1-022` ✅, `P1-008` ✅ |
| `P1-024` ✅ | Rule: **Fuel Low** — "Last trusted pump for next X km" | 4 h | `P1-023` |
| `P1-025` ✅ | Rule: **EV Gap** — "Next fast charger is X km away" | 3 h | `P1-023` |
| `P1-026` ✅ | Rule: **Food window** — "Next highly rated veg restaurant after X km" (honors `pureVeg`) | 4 h | `P1-023` |
| `P1-027` ✅ | `flutter_local_notifications` iOS + Android platform setup | 3 h | — (`P1-063` ✅ added dep) |

Done 2026-05-30.

**Unblocks:** `P1-028` (AlertNotifier delivery), `P2-001` (upgraded rules).

---

## ✅ Session 10 — Alert delivery + hygiene

**Theme.** Deliver alerts via banner + local notification; alert history per
trip; cross-cutting hygiene (telemetry, skeletons, launch icon).

**Tasks (5/5 done).**

| ID | Task | Est | Depends on |
|---|---|---|---|
| `P1-028` ✅ | `AlertNotifier` — Riverpod stream from `AlertEngine` → local notification + in-app banner | 6 h | `P1-027`, `P1-023` |
| `P1-034` ✅ | Alert history screen (per-trip log of fired alerts) | 4 h | `P1-028` |
| `P1-060` ✅ | Lightweight telemetry hooks on new flows (reuse `community_telemetry.dart` pattern) | 3 h | — |
| `P1-062` ✅ | Skeleton loaders for POI lists | 3 h | `P1-012` |
| `P1-030` ✅ | Launch icon + splash for new brand (placeholder assets OK) | 2 h | — |

Done 2026-05-30.

**Unblocks:** Session 11 end-to-end verification.

---

## 🔵 Session 11 — Phase 1 completion verification

**Theme.** No new code — verify every line item in the Phase 1 completion
checklist from `project_plan/01_phase_1_mvp.md` actually holds end-to-end.

**Activities.**

- Run the app end-to-end: plan Pune → Nashik with each `VehicleType`.
- Open Smart Intelligence Grid; tap at least 6 categories (fuel, restaurant,
  washroom, ATM, hotel, mechanic); verify each shows route-aware results
  with a community pulse on every tile.
- Trigger each of the 3 alert rules and confirm a local notification fires.
- Submit a pulse on a non-station POI; verify it reads back via `targetKey`.
- Open existing EV station detail; verify no regression in the legacy flow.
- `P1-065` final pass: `docs/context/current_state.md` reflects shipped MVP.
- Tag git: `phase-1-mvp-complete`.

---

## Ongoing across every session (`P1-065`)

`P1-065` is a rolling task — update `docs/context/current_state.md` at the
end of each session. It does NOT get its own session.

---

## Phase 1 progress tracker

| Session | Tasks | Status |
|---|---|---|
| 1 | 8 | ✅ |
| 2 | 6 | ✅ |
| 3 | 3 | ✅ |
| 4 | 4 | ✅ |
| 5 | 5 | ✅ |
| 6 | 4 | ✅ |
| 7 | 5 | ✅ |
| 8 | 5 | ✅ |
| 9 | 5 | ✅ |
| 10 | 5 | ✅ |
| 11 | verify | 🔵 next |
| **Total** | **50** | **49 / 50 = 98 %** |

When a session lands, update the row above (✅), the "Phase 1 progress tracker"
metric in `project_plan/notion_tracker.md`, and the status block in
`docs/context/current_state.md`.

---

## What comes after Phase 1

The same per-session planning pattern applies to Phase 2 / 3 / 4. When
Phase 1 finishes, create `docs/batches/phase_2_batches.md` from
`project_plan/02_phase_2_intelligence.md` using the same template.
