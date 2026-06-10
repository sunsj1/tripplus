# Phase 3 — Session-by-session batch plan

> **Purpose.** Phase 3 has **28 tasks** (`P3-001` … `P3-071`). This file slices
> them into commit-sized **sessions** for work **after** Phase 2 is signed off
> on a device.
>
> **Prerequisite:** Phase 2 complete — all `P2-*` `P0` tasks `Done`, Session 13
> verification signed in [`docs/PHASE_2_E2E_VERIFICATION.md`](../PHASE_2_E2E_VERIFICATION.md).
>
> **Status:** Sessions 1 + 2 complete (2026-06-11).
>
> **How to use.** Same rules as [`phase_2_batches.md`](phase_2_batches.md): paste
> `docs/ai_context/RESUME_PROMPT.md` (update STEP 2 default path to this file
> when Phase 3 starts).

---

## Status legend

- ✅ done
- 🔵 next up
- ⬜ planned

---

## ✅ Session 1 — AI service abstraction (client-side)

**Theme.** Pluggable interface, prompt library, trip context packer — everything
the client can ship before the server proxy exists.

| ID | Task | Est | Depends on |
|---|---|---|---|
| `P3-001` | `lib/core/services/ai_service.dart` — provider-pluggable interface | 1 d | — |
| `P3-003` | Prompt library — versioned templates in repo + Remote Config cache | 1 d | `P3-002` (interface only) |
| `P3-004` | Trip context packer — compact JSON of route + vehicle + prefs + alerts | 1 d | `P3-001` |

**Unblocks:** Sessions 3–6 (UI, intents, tools).

---

## ✅ Session 2 — Server proxy

**Theme.** The single "no API keys on device" task. Firebase Cloud Functions or
NestJS gateway; production-grade rate limits per uid.

| ID | Task | Est | Depends on |
|---|---|---|---|
| `P3-002` | Server proxy for AI calls — keys on server, rate-limit per uid, prompt templating | 3 d | `P3-001` |

**Unblocks:** every UI + intent session — without this Phase 3 is stubbed.

---

## ⬜ Session 3 — Chat UI foundation

**Theme.** Feature slice + chat screen with streaming + persistent launch FAB.

| ID | Task | Est | Depends on |
|---|---|---|---|
| `P3-010` | `lib/features/ai_copilot/` slice | 2 h | `P3-001` |
| `P3-011` | Chat screen with streaming responses (Riverpod `AsyncValue` stream) | 2 d | `P3-010`, `P3-002` |
| `P3-013` | Assistant-launch floating button on Trip + Discover tabs | 4 h | `P3-011` |

---

## ⬜ Session 4 — Chat enhancements

**Theme.** Quick-prompt chips for the top intents; rich inline cards.

| ID | Task | Est | Depends on |
|---|---|---|---|
| `P3-012` | Quick-prompt chips: "Next charger", "Pure-veg food", "Women-safe stop", "Avoid bad roads", "Scenic point" | 6 h | `P3-011` |
| `P3-014` | Rich-result cards in chat — render POI / route card from intent response | 1 d | `P3-011` |

---

## ⬜ Session 5 — Intent classifier + guardrails

**Theme.** LLM function-calling router + the "never fabricate" rules.

| ID | Task | Est | Depends on |
|---|---|---|---|
| `P3-020` | Intent classifier (tool use) — `find_poi` · `compare_routes` · `narrate_trip` · `general_qa` | 2 d | `P3-002` |
| `P3-024` | Guardrails — never fabricate POI data; cite source POIs returned by tools | 6 h | `P3-020` |

---

## ⬜ Session 6 — Intent tools

**Theme.** The three tools the classifier invokes. Each is a thin adapter
over existing Phase 1/2 services.

| ID | Task | Est | Depends on |
|---|---|---|---|
| `P3-021` | Tool: `find_poi(category, filter, withinKm)` → `PoiRepository` | 1 d | `P3-020` |
| `P3-022` | Tool: `compare_routes(criteria)` → routing service alternatives | 1 d | `P3-020` |
| `P3-023` | Tool: `narrate_trip()` → trip context packer | 6 h | `P3-020` |

---

## ⬜ Session 7 — Voice IO

**Theme.** Speech-in + speech-out so the chat works hands-free.

| ID | Task | Est | Depends on |
|---|---|---|---|
| `P3-030` | `speech_to_text` package — push-to-talk voice input | 1 d | — |
| `P3-031` | `flutter_tts` — assistant voice replies | 6 h | `P3-011` |
| `P3-033` | Audio-only result mode — "spoken summary" path for driving | 1 d | `P3-031` |

---

## ⬜ Session 8 — Hands-free + memory foundation

**Theme.** Wake-word hands-free on active trip + persistent learned vectors.

| ID | Task | Est | Depends on |
|---|---|---|---|
| `P3-032` | Hands-free mode toggle on active trip — wake-word + tap-to-speak fallback | 2 d | `P3-030` |
| `P3-040` | Persist long-term user-preference vectors in Firestore `users/{uid}/aiMemory` | 1 d | `P2-010` ✅ |

---

## ⬜ Session 9 — Memory transparency & privacy

**Theme.** The user can see and delete everything the assistant has learned.

| ID | Task | Est | Depends on |
|---|---|---|---|
| `P3-041` | "What I learned" transparency screen — view + delete learned preferences | 1 d | `P3-040` |
| `P3-042` | Privacy controls — opt-out of memory + opt-out of assistant entirely | 6 h | `P3-040` |

---

## ⬜ Session 10 — AI-curated hidden gems

**Theme.** LLM-generated gems with admin moderation.

| ID | Task | Est | Depends on |
|---|---|---|---|
| `P3-050` | LLM-generated hidden gem suggestions per corridor with source citation | 2 d | `P3-002`, `P2-060` ✅ |
| `P3-051` | Editorial moderation queue — auto-generated gems require admin approval | 1 d | `P3-050` |

---

## ⬜ Session 11 — EV-deep features

**Theme.** Battery-aware routing, queue prediction, connector compatibility.

| ID | Task | Est | Depends on |
|---|---|---|---|
| `P3-060` | Battery-aware routing v1 — energy cost graph over alternatives | 3 d | `P1-018` ✅ |
| `P3-061` | Charging queue prediction v1 — expected wait from community pulse cadence | 2 d | `P2-030` ✅ |
| `P3-062` | Charger compatibility matcher — vehicle connector type vs charger list | 1 d | `P1-003` ✅ |

---

## ⬜ Session 12 — Driving Score

**Theme.** Lightweight gamification rolled up from existing trip data.

| ID | Task | Est | Depends on |
|---|---|---|---|
| `P3-070` | Score = function(alerts acknowledged, breaks taken, on-time stops, route adherence) | 1 d | `P1-028` ✅ |
| `P3-071` | Driving Score screen in Profile | 6 h | `P3-070` |

---

## ⬜ Session 13 — Phase 3 completion verification

**Theme.** No new features — E2E against `project_plan/03_phase_3_ai_copilot.md`
completion checklist + prepend Phase 3 block to `docs/PHASE_REPORTS.md`.

**Activities.**

- ✅ `flutter analyze` clean.
- ✅ `flutter test` passes.
- ✅ Author `docs/PHASE_3_E2E_VERIFICATION.md`.
- ✅ Run the device checklist.
- ✅ Prepend a `## Phase 3 — AI Travel Copilot` block to [`docs/PHASE_REPORTS.md`](../PHASE_REPORTS.md).
- ✅ Update `docs/context/current_state.md` TL;DR.
- Tag: `phase-3-ai-copilot-complete`.

---

## Phase 3 progress tracker

| Session | Tasks | Status |
|---|---|---|
| 1 | 3 | ✅ |
| 2 | 1 | ✅ |
| 3 | 3 | ⬜ |
| 4 | 2 | ⬜ |
| 5 | 2 | ⬜ |
| 6 | 3 | ⬜ |
| 7 | 3 | ⬜ |
| 8 | 2 | ⬜ |
| 9 | 2 | ⬜ |
| 10 | 2 | ⬜ |
| 11 | 3 | ⬜ |
| 12 | 2 | ⬜ |
| 13 | verify | ⬜ |
| **Total** | **28** | **4 / 28 = 14 %** |

---

## Reference

- Full task table: [`project_plan/03_phase_3_ai_copilot.md`](../../project_plan/03_phase_3_ai_copilot.md)
- Status CSV: [`project_plan/tasks.csv`](../../project_plan/tasks.csv) (filter `Phase 3`)
- Phase rollup: [`docs/PHASE_REPORTS.md`](../PHASE_REPORTS.md)
