# Phase 2 — Session-by-session batch plan

> **Purpose.** Phase 2 has **36 tasks** (`P2-001` … `P2-074`). This file slices them
> into commit-sized **sessions** for work **after** Phase 1 is tested and rolled out.
>
> **Prerequisite:** Phase 1 complete — all `P1-*` `P0` tasks `Done`, Session 11 E2E
> sign-off in [`docs/PHASE_1_E2E_VERIFICATION.md`](../PHASE_1_E2E_VERIFICATION.md).
>
> **Status:** Planning only — **no Phase 2 implementation** until you say `go` on
> Session 1 here.
>
> **How to use.** Same rules as [`phase_1_batches.md`](phase_1_batches.md): paste
> `docs/ai_context/RESUME_PROMPT.md` (update STEP 2 default path to this file when
> Phase 2 starts).

---

## Status legend

- ✅ done
- 🔵 next up
- ⬜ planned

---

## ✅ Session 1 — Alert engine v2 foundation

**Theme.** Upcoming-window evaluation, deduplication, and presentation tiers.

| ID | Task | Est | Depends on |
|---|---|---|---|
| `P2-001` ✅ | Upgrade `AlertEngine` to upcoming-window rules | 1 d | `P1-023` ✅ |
| `P2-006` ✅ | Alert deduplication & cooldown | 4 h | `P2-001` |
| `P2-007` ✅ | Alert priorities + non-blocking vs critical UI | 6 h | `P2-001` |

**Plus edge-case:** active-trip POI lists now filter to stops *ahead* of the
driver's GPS position (`PoiQuerySource.aheadOnRoute`).

**Unblocks:** Sessions 2–3 (new alert rules).

---

## ✅ Session 2 — Predictive alert rules (safety)

**Theme.** Ghat, night, and fatigue rules on top of the v2 engine.

| ID | Task | Est | Depends on |
|---|---|---|---|
| `P2-002` ✅ | Ghat / risk alert (static ghat dataset) | 2 d | `P2-001` |
| `P2-003` ✅ | Night alert — safe stop suggestion | 1.5 d | `P2-001` |
| `P2-004` ✅ | Fatigue alert — 3 h driving timer | 6 h | `P2-001` |

---

## ✅ Session 3 — Personalization core

**Theme.** Preference vector + POI ranker wired into category lists.

| ID | Task | Est | Depends on |
|---|---|---|---|
| `P2-010` ✅ | `UserPreferenceVector` — explicit + behavioral weights | 1 d | `P1-031` ✅ |
| `P2-011` ✅ | `PoiRanker` score function | 1 d | `P2-010`, `P1-008` ✅ |
| `P2-012` ✅ | Apply `PoiRanker` to all `PoiCategoryScreen` lists | 4 h | `P2-011` |

**Unblocks:** Mode filters, trust explainers, environment UX that reads ranked lists.

---

## ✅ Session 4 — Trust v2 for all POIs

**Theme.** Reliability, conflict timeline, and source badges everywhere.

| ID | Task | Est | Depends on |
|---|---|---|---|
| `P2-030` ✅ | Generalize reliability score to all POIs | 1 d | `P1-052` ✅ |
| `P2-031` ✅ | Conflict-aware timeline on POIs | 6 h | `P2-030` |
| `P2-032` ✅ | Source badges: Official · Community · Unverified | 4 h | `P2-030` |

---

## ✅ Session 5 — Mode-aware filters

**Theme.** Family, women-safe, bike overlays + community tags for modes.

| ID | Task | Est | Depends on |
|---|---|---|---|
| `P2-023` ✅ | Community pulse tags (baby-friendly, women-safe, hygienic) | 6 h | `P1-052` ✅ |
| `P2-020` ✅ | Family Mode toggle + filter overlay | 1 d | `P2-012` |
| `P2-021` ✅ | Women-Safe Mode + badge | 1 d | `P2-012` |
| `P2-022` ✅ | Bike Rider Mode + bike categories | 1 d | `P2-012` |

---

## ✅ Session 6 — Weather & traffic on the trip

**Theme.** Open-Meteo on timeline + traffic-aware ETA.

| ID | Task | Est | Depends on |
|---|---|---|---|
| `P2-040` ✅ | Weather via Open-Meteo per segment | 1 d | `P1-020` ✅ |
| `P2-041` ✅ | Traffic-aware ETA (Google Directions w/ departure_time=now) | 1 d | `P1-018` ✅ |
| `P2-005` ✅ | Weather alert rule on upcoming segment | 6 h | `P2-040`, `P2-001` |

---

## ✅ Session 7 — Tolls & road condition

**Theme.** Richer cost picture + community road-condition hints.

| ID | Task | Est | Depends on |
|---|---|---|---|
| `P2-042` ✅ | Toll estimation v1 (static corridor dataset) | 2 d | `P1-018` ✅ |
| `P2-043` ✅ | Road-condition tags from community pulses | 6 h | `P2-030` |

---

## ✅ Session 8 — Trip lifecycle & settings

**Theme.** History, settings, one-tap re-plan.

| ID | Task | Est | Depends on |
|---|---|---|---|
| `P2-053` ✅ | Settings — units, vehicle, notification prefs | 1 d | `P1-033` ✅, `P1-028` ✅ |
| `P2-050` ✅ | Trip history list screen | 1 d | `P1-041` ✅ |
| `P2-051` ✅ | Save & reuse trip (one-tap re-plan) | 4 h | `P2-050` |

---

## ✅ Session 9 — Share trip & brand learning

**Theme.** Social share + fuel brand affinity.

| ID | Task | Est | Depends on |
|---|---|---|---|
| `P2-052` ✅ | Share trip link / text | 6 h | `P2-051` |
| `P2-013` ✅ | Brand affinity learning for fuel ranking | 6 h | `P2-010` |

---

## ✅ Session 10 — Hidden gems v1

**Theme.** Curated corridor gems on Discover.

| ID | Task | Est | Depends on |
|---|---|---|---|
| `P2-060` ✅ | Manual curation JSON per major corridor | 1 d | `P1-006` ✅ |
| `P2-062` ✅ | Tag categories (food, scenic, specialty, underrated) | 4 h | `P2-060` |
| `P2-061` ✅ | Hidden Gems carousel on `DiscoveryScreen` | 6 h | `P2-060` |

---

## ✅ Session 11 — Transparency & observability

**Theme.** “Why we recommend this”, Crashlytics/Analytics, Firestore indexes.

| ID | Task | Est | Depends on |
|---|---|---|---|
| `P2-033` ✅ | “Why we recommend this” explainer chip | 6 h | `P2-011` |
| `P2-071` ✅ | Wire Crashlytics + Analytics (native gradle plugin) | 6 h | `P1-064` ✅ |
| `P2-072` ✅ | Deploy composite Firestore indexes | 4 h | `P1-055` ✅ |

---

## ✅ Session 12 — A11y & performance

**Theme.** Accessibility pass, list perf, map clustering.

| ID | Task | Est | Depends on |
|---|---|---|---|
| `P2-070` ✅ | A11y pass — contrast, semantics, large text | 1 d | — |
| `P2-073` ✅ | List virtualization + image caching on POI lists | 6 h | `P1-012` ✅ |
| `P2-074` ✅ | Map clustering for crowded categories | 6 h | `P1-015` ✅ |

---

## ⬜ Session 13 — Phase 2 completion verification

**Theme.** No new features — E2E against `project_plan/02_phase_2_intelligence.md`
completion checklist.

**Activities.**

- Predictive alerts: ghat, night, fatigue, weather (where enabled).
- Personalized ranking visible on category screens.
- Family / Women-Safe / Bike modes change results.
- Weather + traffic on trip timeline; toll estimate where applicable.
- Hidden Gems on at least 2 corridors.
- `flutter analyze` + `flutter test` clean.
- Tag: `phase-2-intelligence-complete`.

---

## Phase 2 progress tracker

| Session | Tasks | Status |
|---|---|---|
| 1 | 3 | ✅ |
| 2 | 3 | ✅ |
| 3 | 3 | ✅ |
| 4 | 3 | ✅ |
| 5 | 4 | ✅ |
| 6 | 3 | ✅ |
| 7 | 2 | ✅ |
| 8 | 3 | ✅ |
| 9 | 2 | ✅ |
| 10 | 3 | ✅ |
| 11 | 3 | ✅ |
| 12 | 3 | ✅ |
| 13 | verify | ⬜ |
| **Total** | **36** | **35 / 36 = 97 %** |

---

## Reference

- Full task table: [`project_plan/02_phase_2_intelligence.md`](../../project_plan/02_phase_2_intelligence.md)
- Status CSV: [`project_plan/tasks.csv`](../../project_plan/tasks.csv) (filter `Phase 2`)
