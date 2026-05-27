# Phase 3 — AI Travel Copilot

**Goal:** Make the app conversational — voice + chat assistant grounded in the user's trip context, AI-curated hidden gems, battery-aware EV routing, driving score.

**Target duration:** 6–8 weeks (after Phase 2).
**Prerequisite:** Phase 2 `P0` tasks `Done`. User-preference vectors and trip lifecycle stable.

> Track each task by its **ID** (e.g. `P3-005`).

---

## 3.1 AI service abstraction

| ID | Task | Priority | Est. | Depends on | Status |
|---|---|---|---|---|---|
| `P3-001` | Create `lib/core/services/ai_service.dart` — provider-pluggable interface (OpenAI / Gemini). Client never sees API keys | P0 | 1d | — | ⬜ |
| `P3-002` | **Server proxy** for AI calls — Firebase Cloud Functions (or NestJS gateway) holding API keys, rate-limiting per uid, prompt templating | P0 | 3d | `P3-001` | ⬜ |
| `P3-003` | Prompt library — versioned templates for intents (find POI, route question, narrate trip) committed to repo + cached in Remote Config | P0 | 1d | `P3-002` | ⬜ |
| `P3-004` | Trip context packer — compact JSON of current route + vehicle + preferences + recent alerts, sent with every AI call | P0 | 1d | `P3-001` | ⬜ |

---

## 3.2 Assistant UI

| ID | Task | Priority | Est. | Depends on | Status |
|---|---|---|---|---|---|
| `P3-010` | Create `lib/features/ai_copilot/` feature slice | P0 | 2h | `P3-001` | ⬜ |
| `P3-011` | Chat screen with streaming responses (Riverpod `AsyncValue` stream) | P0 | 2d | `P3-010`, `P3-002` | ⬜ |
| `P3-012` | Quick-prompt chips: "Next charger" · "Pure-veg food" · "Women-safe stop" · "Avoid bad roads" · "Scenic point" | P0 | 6h | `P3-011` | ⬜ |
| `P3-013` | Assistant-launch floating button persistent across Trip and Discover tabs | P0 | 4h | `P3-011` | ⬜ |
| `P3-014` | Inline rich-result cards in chat — render a POI card / route option directly from intent response | P0 | 1d | `P3-011` | ⬜ |

---

## 3.3 Intent routing & grounding

| ID | Task | Priority | Est. | Depends on | Status |
|---|---|---|---|---|---|
| `P3-020` | Intent classifier (LLM function calling / tool use) — maps user query to one of: `find_poi`, `compare_routes`, `narrate_trip`, `general_qa` | P0 | 2d | `P3-002` | ⬜ |
| `P3-021` | Tool: `find_poi(category, filter, withinKm)` → invokes existing `PoiRepository` | P0 | 1d | `P3-020` | ⬜ |
| `P3-022` | Tool: `compare_routes(criteria)` → invokes routing service alternatives | P0 | 1d | `P3-020` | ⬜ |
| `P3-023` | Tool: `narrate_trip()` → uses trip context packer to summarize plan | P1 | 6h | `P3-020` | ⬜ |
| `P3-024` | Guardrails — never fabricate POI data; always cite source POIs returned by tools | P0 | 6h | `P3-020` | ⬜ |

---

## 3.4 Voice

| ID | Task | Priority | Est. | Depends on | Status |
|---|---|---|---|---|---|
| `P3-030` | Add `speech_to_text` package — push-to-talk voice input | P0 | 1d | — | ⬜ |
| `P3-031` | Add `flutter_tts` — assistant voice replies | P0 | 6h | `P3-011` | ⬜ |
| `P3-032` | Hands-free mode toggle on active trip — auto-listen with wake word phrase (fallback: tap-to-speak) | P1 | 2d | `P3-030` | ⬜ |
| `P3-033` | Audio-only result mode — assistant responses include a "spoken summary" path for driving | P0 | 1d | `P3-031` | ⬜ |

---

## 3.5 Personalization memory

| ID | Task | Priority | Est. | Depends on | Status |
|---|---|---|---|---|---|
| `P3-040` | Persist long-term user-preference vectors in Firestore `users/{uid}/aiMemory` | P0 | 1d | `P2-010` | ⬜ |
| `P3-041` | "What I learned" transparency screen — user can view & delete learned preferences | P0 | 1d | `P3-040` | ⬜ |
| `P3-042` | Privacy controls — opt-out of memory + opt-out of AI assistant entirely | P0 | 6h | `P3-040` | ⬜ |

---

## 3.6 AI-curated hidden gems

| ID | Task | Priority | Est. | Depends on | Status |
|---|---|---|---|---|---|
| `P3-050` | LLM-generated hidden gem suggestions per corridor with source citation (grounded by community pulses + Places ratings) | P1 | 2d | `P3-002`, `P2-060` | ⬜ |
| `P3-051` | Editorial moderation queue — auto-generated gems require admin approval before publishing | P0 | 1d | `P3-050` | ⬜ |

---

## 3.7 EV-deep features

| ID | Task | Priority | Est. | Depends on | Status |
|---|---|---|---|---|---|
| `P3-060` | Battery-aware routing v1 — energy cost graph over alternative routes; choose lowest-energy route for EV | P0 | 3d | `P1-018` | ⬜ |
| `P3-061` | Charging queue prediction v1 — predict expected wait at fast chargers from community pulse cadence | P1 | 2d | `P2-030` | ⬜ |
| `P3-062` | Charger compatibility matcher — vehicle connector type vs charger connector list | P0 | 1d | `P1-003` | ⬜ |

---

## 3.8 Driving Score (lightweight)

| ID | Task | Priority | Est. | Depends on | Status |
|---|---|---|---|---|---|
| `P3-070` | Score = function(alerts acknowledged, breaks taken, on-time stops, route adherence) | P1 | 1d | `P1-028` | ⬜ |
| `P3-071` | Driving Score screen in Profile | P1 | 6h | `P3-070` | ⬜ |

---

## Phase 3 completion checklist

- [ ] User can chat or speak: "Find a pure-veg restaurant in the next 30 km" → grounded response with a real POI card.
- [ ] Battery-aware routing returns a different recommended route for EVs vs petrol.
- [ ] User can view and delete what the assistant has learned about them.
- [ ] Driving score reflects completed trips.
