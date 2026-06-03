# Phase Reports

> **Purpose.** A single chronological record of what each phase delivered, what
> changed in the architecture, and what was deliberately deferred.
>
> One report per **completed** phase. Add a new block at the **top** when the
> phase's E2E verification is signed off. Never edit older blocks except to fix
> factual errors — they are the historical record.
>
> **Format.** Each block has the same headings so future phases can be compared
> at a glance. Keep prose tight (this is a reference, not a blog post).

---

## Phase 2 — Predictive & Personalized Intelligence

- **Status:** ✅ Complete (36 / 36 tasks)
- **Duration:** Sessions 1–13 (Phase 2 batches plan)
- **Verification:** [`docs/PHASE_2_E2E_VERIFICATION.md`](PHASE_2_E2E_VERIFICATION.md)
- **Tag:** `phase-2-intelligence-complete`

### Theme

Turn the Phase 1 MVP into a *smart* highway companion — predictive alerts
beyond simple distance rules, personalised POI ranking, mode-aware filters,
weather + traffic + tolls, trust v2 for every POI category, and curated hidden
gems on Discover.

### Features delivered

| Surface | What's new |
|---|---|
| **Alert engine v2** | Upcoming-window evaluation (100 km lookahead), per-type 20 min cooldown, severity-tiered banner (critical / warning / info) with type-specific glyphs. |
| **Safety alert rules** | Ghat rule + 14-ghat curated dataset; Night rule (22:00–05:00) suggests safe stop; Fatigue rule fires every 3 h of continuous driving. |
| **Weather** | Per-segment Open-Meteo strip (origin · midway · destination) + `WeatherRule` flags rain/fog/thunderstorm ahead. |
| **Traffic-aware ETA** | Google Directions `departure_time=now` adds `duration_in_traffic`; `effectiveDurationMinutes` blends into stat-card ETA + traffic chip severity. |
| **Tolls v1** | Static corridor dataset replaces flat ₹1.5/km when the route matches a known expressway. |
| **Personalised ranking** | `UserPreferenceVector.fromPreferences()` → `PoiRanker.rank()` blends quality, proximity, openness, preference matches; "Best match" is the default sort. |
| **Brand affinity learning** | View / pulse interactions bump a per-brand affinity score (Hive-persisted); merged into preference vector on next rebuild. |
| **"Why we recommend this"** | `PoiRanker.explain()` returns a structured `RankingExplanation`; top 3 reasons render on the POI detail sheet. |
| **Mode filters** | `RouteMode { off, family, womenSafe, bike }` overlay every POI list with attribute-first + category-fallback filter, mode badges on tiles, mode-filtered empty state with "Clear mode" CTA. |
| **Trust v2** | Reliability scoring generalised across EV (`working/issues/down`) and POI (`good/fair/poor`) vocabs; conflict timeline on disagreement; reusable colour-coded `SourceBadge`. |
| **Ahead-on-route POI filter** | Active-trip POI lists trim to stops ahead of the driver's GPS position (`PoiQuerySource.aheadOnRoute`). |
| **Community pulse tags** | `babyFriendly` / `womenSafe` / `hygienic` tri-state booleans flow through DTO → aggregation → mode badges. |
| **Trip lifecycle** | History list, save & one-tap re-plan, OS share sheet for any completed trip, full Settings screen (units, vehicle, per-alert mutes). |
| **Hidden gems** | Curated corridor JSON (4 corridors × 10 gems) → `HiddenGemsCarousel` on Discover when the active plan matches a known corridor. |
| **Server-side queries** | `watchStationReports` / `watchByTargetKey` now use composite indexes for `orderBy + limit(50)` — caps reads at 50 per query. |
| **A11y** | `Semantics(button, selected, label)` on bottom nav tabs, mode chips, map controls; `Tooltip` on icon-only buttons. |
| **Performance** | `cached_network_image` for POI tile / gallery / fullscreen; `PoiMarkerClustering` zoom-based grid clustering on map. |
| **Observability** | `ObservabilityService` pipes user id / vehicle type / route mode / active-trip flag into Crashlytics; disabled in debug. |

### Architecture changes

- **New feature slices:** `weather/`, `tolls/`, `hidden_gems/`, `personalization/`, `settings/`.
- **Domain refactor:** `PoiRanker` `score()` and `explain()` share a single `_evaluate()` so scoring math has one source of truth.
- **Schema additions:** `StationCommunityReport` and `StationCommunitySubmitInput` gained nullable `babyFriendly / womenSafe / hygienic` tags; DTO reads missing → null, writes only non-null.
- **Indexes:** Composite indexes `stationKey+createdAt` and `targetKey+createdAt` now used server-side.
- **New Hive boxes:** `app_settings` (P2-053), `brand_affinity` (P2-013). Total now 7 boxes opened in `main.dart`.
- **New asset bundle:** `assets/hidden_gems/corridor_gems.json` registered.
- **Native:** Crashlytics gradle plugin verified live; native uploads work for release builds.

### Improvements over Phase 1

- Estimates labelled "~ estimates only" (Phase 1) now have **live weather + live traffic** backing them.
- POI lists were sorted by raw distance; now ranked by personalised match score.
- Community feed used to fetch all docs and sort/slice client-side; now uses the deployed composite indexes for `orderBy + limit(50)`.
- Alerts used to fire **once per trip per type**; now use a 20 min cooldown so a renewed condition (e.g. fuel low again) re-surfaces.
- Default sort had no transparency; "Why we recommend this" explains it in plain language.
- A11y was implicit; bottom nav, mode chips, and map controls now expose semantic state.
- POI photo grid scrolled and re-decoded JPEGs; now cached on disk + memory keyed to device pixel ratio.

### Known gaps / deferred to Phase 3

- Weather data is **current** only, not forecast — Open-Meteo's hourly endpoint can be threaded through when needed for "weather at the time you'll be there" ETAs.
- Brand affinity has no time-based decay; a brand that fell out of favour will stay ranked until something else accumulates more interactions.
- A11y full contrast audit (large-text mode + AA ratios) needs a manual device sweep in pre-rollout QA.
- Firebase Analytics is **not initialised**; Crashlytics breadcrumbs cover the "user did this" need for now.
- Hidden gem coverage is intentionally narrow (4 corridors). Easy expansion by appending to JSON — no code changes needed. Phase 3 (`P3-050`) will replace with LLM-curated entries that cite sources.

### Files of interest (Phase 2 additions)

```
lib/features/
  alerts/domain/
    ghat_dataset.dart                       — P2-002
    rules/{ghat,night,fatigue,weather}_rule.dart — P2-002, P2-003, P2-004, P2-005
  weather/                                  — P2-040
  tolls/                                    — P2-042
  personalization/                          — P2-010, P2-011, P2-013, P2-020/021/022, P2-033
  hidden_gems/                              — P2-060, P2-061, P2-062
  settings/                                 — P2-053
  community/domain/
    community_condition.dart                — P2-030
    community_tag_aggregation.dart          — P2-023
    trust_level.dart                        — P2-030
core/
  services/observability_service.dart       — P2-071
  services/observability_providers.dart     — P2-071
  widgets/source_badge.dart                 — P2-032
assets/hidden_gems/corridor_gems.json       — P2-060
```

### Test posture

- Phase 1 alert engine tests still pass (4 / 4).
- Widget smoke test passes (`flutter test`).
- No new unit tests added in Phase 2 — pure-Dart additions (`PoiRanker`, `TollEstimator`, `mode_filter`) are good test candidates for Phase 3 hygiene.

---

## Phase 1 — Smart Highway Companion MVP

- **Status:** ✅ Complete (50 / 50 tasks)
- **Duration:** Sessions 1–11 (Phase 1 batches plan) + UX improvement sub-sessions 1–3
- **Verification:** [`docs/PHASE_1_E2E_VERIFICATION.md`](PHASE_1_E2E_VERIFICATION.md)
- **Tag:** `phase-1-mvp-complete`

### Theme

Ship a functional EV-and-fuel highway companion with auth, vehicle profile,
route planning, route-aware POI discovery, community pulses, the predictive
alert engine, offline degraded-mode banner, and a four-tab AppShell.

### Features delivered

| Surface | What's new |
|---|---|
| **Auth & onboarding** | Firebase Auth + Google Sign-In; `AuthGate` routes through `VehicleSetupGate` before `AppShell`. |
| **App shell** | Four tabs — **Plan · Trip · Discover · Profile**. `shellTabIndexProvider` enables programmatic tab switching. `OfflineBanner` + `TripAlertBanner` sit above the IndexedStack. |
| **Profile** | `ProfileData = (vehicle?, preferences)` persisted in Hive + Firestore mirror. Six preference toggles + budget tier + fuel brand picker. |
| **Plan** | `RouteInputCard` with Places autocomplete; default "Current location" From; popular corridors pre-fill (no auto-analyze). |
| **Plan results** | Real route via Google Directions + station merge (Open Charge Map + Google EV Stations). Trip Overview stat row (ETA / Tolls / Fuel-or-Charging / Traffic) with "~ estimates only" disclaimer. |
| **Smart Trip Timeline** | Vertical Origin → Stops → Destination. Collapsible station block, distance chips, "Fast only" filter on EV results. |
| **Discovery** | 16-category Smart Intelligence Grid + pinned Emergency tile + "Plan a route" CTA when no active plan. |
| **POI category screen** | List + map toggle. Sort chips (Best match / Nearest / Top rated / Open now). Loading skeleton, errored/empty states map to typed `Failure`. |
| **Community pulses** | `stationCommunityReports` Firestore collection with `targetType` + `targetKey` discriminator; offline submit queue (Hive); reliability score; rating pulse chips on tiles; conflict-aware timeline. |
| **Trip lifecycle** | `Trip` Freezed model (Hive-persisted), full state machine (notStarted → active → paused → completed). Live elapsed timer. Trip history (on-device, no GPS trail). |
| **Predictive alerts** | Pure-Dart `AlertEngine` with `FuelLowRule`, `EvGapRule`, `FoodWindowRule`; `AlertNotifier` polls every 30 s while a trip is active; `TripAlertBanner` in shell + local notifications. |
| **Foreground location** | `LocationService` + Android `FOREGROUND_SERVICE_LOCATION` permission; trip controller starts/stops the stream on lifecycle transitions. |
| **Offline resilience** | `OfflineBanner` (animated, auto-collapse) + `CorridorCache` Hive box (route polyline + station IDs) populated on `prepareTrip`. |
| **POI detail** | Bottom sheet with photo gallery, source badge, address, distance, rating, "Open in Maps", embedded community feed + pulse submit. |
| **Crashlytics** | Init in `main.dart`; collection disabled in debug. Android gradle plugin wired. |

### Architecture invariants established

1. Feature-slice layout under `lib/features/`.
2. Riverpod for everything; controllers are `StateNotifier<UiState>`.
3. Freezed models for all domain types.
4. Repositories return `Either<Failure, T>` for writes.
5. Community reports are immutable (schema may only **add** fields).
6. Community photos are base64 JPEG inline on the doc (no Firebase Storage).
7. Stable identity helpers always used (no raw Google / OCM IDs).

### Improvements over project inception

- Replaced a single "Plan + Insights + Stations" three-tab nav with the four-tab predictive shell.
- POI photos went from broken icons to lazy-loaded Google Place photos with attribution and fullscreen viewer.
- Community queries gained a discriminator (`targetType`) so a single collection serves both stations and POIs.

### Known gaps / deferred to Phase 2

- Personalisation: preference toggles were stored but didn't change list order. (Closed by Phase 2 `P2-010` / `P2-011` / `P2-012`.)
- Estimates (tolls / fuel / traffic) were heuristic. (Closed by Phase 2 weather + traffic-aware ETA + tolls dataset.)
- POI community submit only worked for stations. (Closed by Phase 2 `P2-023` + tri-state tag UI.)
- Alert engine fired once per trip per type. (Closed by Phase 2 `P2-006` cooldown.)
- Trip history was read-only. (Closed by Phase 2 `P2-051` save + re-plan + `P2-052` share.)

### Files of interest (Phase 1 surface)

```
lib/features/
  auth/                            — P1-001 … P1-032
  shell/presentation/view/app_shell.dart — P1-016
  plan/                            — P1-005, P1-018, P1-019, P1-020, P1-021
  trip/                            — P1-040, P1-041, P1-017, P1-042, P1-043
  alerts/                          — P1-022 … P1-028, P1-034
  community/                       — P1-010, P1-050, P1-051, P1-052, P1-055
  discovery/                       — P1-011, P1-013, P1-014, P1-015
  pois/                            — P1-008, P1-009, P1-012, P1-053, P1-054
core/widgets/offline_banner.dart   — P1-044
```

---

## How to add a new phase report

When a phase E2E sign-off is complete:

1. Read the phase's verification checklist (`docs/PHASE_N_E2E_VERIFICATION.md`).
2. Read the phase's batches file (`docs/batches/phase_N_batches.md`) for the per-session breakdown.
3. Read `docs/ai_context/progress_log.md` for the per-session theme and decisions.
4. Prepend a new block at the top of this file using the same heading structure:
   - `## Phase N — <theme>`
   - **Status / Duration / Verification / Tag**
   - **Theme** — one paragraph
   - **Features delivered** — table by surface
   - **Architecture changes** — bullet list
   - **Improvements over previous phase** — bullet list
   - **Known gaps / deferred to Phase N+1** — bullet list
   - **Files of interest** — annotated path tree
   - **Test posture** — what's covered, what isn't
5. Update `docs/context/current_state.md` TL;DR to link the new phase as complete.
6. Tag the commit: `phase-N-<theme-slug>-complete`.

This file is the **only** place where a future reader can see the cumulative
product story without spelunking through 13 session blocks per phase.
