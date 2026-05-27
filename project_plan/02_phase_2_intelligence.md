# Phase 2 — Predictive & Personalized Intelligence

**Goal:** Turn the MVP into a *smart* companion — predictive alerts beyond simple distance rules, personalized rankings, mode-aware filters (family / women-safe / bike), weather + traffic + tolls, and trust-scored recommendations across all POIs.

**Target duration:** 4–6 weeks (after Phase 1).
**Prerequisite:** Phase 1 `P0` tasks all `Done`.

> Track each task by its **ID** (e.g. `P2-007`).

---

## 2.1 Predictive Alerts Engine v2

| ID | Task | Priority | Est. | Depends on | Status |
|---|---|---|---|---|---|
| `P2-001` | Upgrade `AlertEngine` to evaluate **upcoming-window** rules (look ahead N km/min) instead of pure point distance | P0 | 1d | `P1-023` | ⬜ |
| `P2-002` | **Ghat / Risk Alert** — detect mountain sections from elevation API (Google Elevation or Open-Elevation) or static dataset of known ghats; fire "No petrol pumps in upcoming mountain section" | P0 | 2d | `P2-001` | ⬜ |
| `P2-003` | **Night Alert** — low-lighting heuristic (sunset + road class + community reports of unsafe sections) → suggest the next night-safe stop | P0 | 1.5d | `P2-001` | ⬜ |
| `P2-004` | **Fatigue Alert** — 3-hour continuous driving timer (resets on a >15 min stop); suggests next rated rest stop | P0 | 6h | `P2-001` | ⬜ |
| `P2-005` | **Weather alerts** — rain / fog / heat warning on upcoming segment (depends on `P2-012`) | P1 | 6h | `P2-012` | ⬜ |
| `P2-006` | Alert deduplication & cooldown (don't refire the same alert within X km) | P0 | 4h | `P2-001` | ⬜ |
| `P2-007` | Alert priorities + non-blocking presentation (top banner, low chime) vs critical (full sheet) | P0 | 6h | `P2-001` | ⬜ |

---

## 2.2 Personalization & recommendation engine

| ID | Task | Priority | Est. | Depends on | Status |
|---|---|---|---|---|---|
| `P2-010` | `UserPreferenceVector` — derived weights from explicit preferences + observed behavior (pinned stops, dwell time, rated POIs) | P0 | 1d | `P1-031` | ⬜ |
| `P2-011` | `PoiRanker` — score function combining: distance from corridor, community reliability, recency, user-preference match, source confidence | P0 | 1d | `P2-010`, `P1-008` | ⬜ |
| `P2-012` | Apply `PoiRanker` to all `PoiCategoryScreen` lists (replace raw distance sort) | P0 | 4h | `P2-011` | ⬜ |
| `P2-013` | Brand affinity learning — when user picks the same fuel brand 3+ times, persist as preference and re-rank fuel pumps | P1 | 6h | `P2-010` | ⬜ |

---

## 2.3 Mode-aware filters (Family / Women-Safe / Bike)

| ID | Task | Priority | Est. | Depends on | Status |
|---|---|---|---|---|---|
| `P2-020` | **Family Mode** toggle — global header chip when active; filters favor baby-friendly, hygienic washrooms, kids food, safe parking, well-lit | P0 | 1d | `P2-012` | ⬜ |
| `P2-021` | **Women-Safe Mode** — surfaces only stops with women-safety community tag ≥ threshold; adds "Women-safe" badge | P0 | 1d | `P2-012` | ⬜ |
| `P2-022` | **Bike Rider Mode** — adds Bike-specific categories (helmet shops, puncture repair, biker cafes); ranks scenic routes higher | P1 | 1d | `P2-012` | ⬜ |
| `P2-023` | Add community pulse tags for the above modes (baby-friendly, women-safe, hygienic washroom) — UI in the report wizard step | P0 | 6h | `P1-052` | ⬜ |

---

## 2.4 Trust & confidence v2

| ID | Task | Priority | Est. | Depends on | Status |
|---|---|---|---|---|---|
| `P2-030` | Generalize the existing reliability-score formula from stations to all POIs | P0 | 1d | `P1-052` | ⬜ |
| `P2-031` | Extend conflict-aware timeline (already shipped for stations) to POIs | P0 | 6h | `P2-030` | ⬜ |
| `P2-032` | Source badges on every POI: `Official` · `Community-verified` · `Unverified` | P0 | 4h | `P2-030` | ⬜ |
| `P2-033` | "Why we recommend this" explainer chip on top-ranked POIs (transparency) | P1 | 6h | `P2-011` | ⬜ |

---

## 2.5 Environmental data integrations

| ID | Task | Priority | Est. | Depends on | Status |
|---|---|---|---|---|---|
| `P2-040` | Weather integration via **Open-Meteo** (free, no key) — per-segment forecast on the trip timeline | P0 | 1d | `P1-020` | ⬜ |
| `P2-041` | Traffic-aware ETA — Google Routes Compute alternatives + traffic-aware leg durations | P0 | 1d | `P1-018` | ⬜ |
| `P2-042` | Toll estimation v1 — use a static toll-plaza dataset for major Indian corridors + per-vehicle-class pricing | P1 | 2d | `P1-018` | ⬜ |
| `P2-043` | Road-condition tag aggregation from community pulses → surface on segment hints | P1 | 6h | `P2-030` | ⬜ |

---

## 2.6 Trip lifecycle UX

| ID | Task | Priority | Est. | Depends on | Status |
|---|---|---|---|---|---|
| `P2-050` | Trip history list (`lib/features/trip/.../trips_history_screen.dart`) | P1 | 1d | `P1-041` | ⬜ |
| `P2-051` | Save & reuse a trip (one-tap re-plan) | P1 | 4h | `P2-050` | ⬜ |
| `P2-052` | Share trip — generate link/text with origin/destination/preferences | P2 | 6h | `P2-051` | ⬜ |
| `P2-053` | Settings screen — units (km/mi), default vehicle, notification preferences | P0 | 1d | `P1-033`, `P1-028` | ⬜ |

---

## 2.7 Hidden gems v1 (curated, pre-AI)

| ID | Task | Priority | Est. | Depends on | Status |
|---|---|---|---|---|---|
| `P2-060` | Manual curation dataset — seed JSON of hidden-gem POIs per major corridor (Pune-Mumbai, Pune-Nashik, Bengaluru-Mysuru) | P1 | 1d | `P1-006` | ⬜ |
| `P2-061` | "Hidden Gems" surface on `DiscoveryScreen` — horizontal carousel for the active corridor | P1 | 6h | `P2-060` | ⬜ |
| `P2-062` | Tag categories: famous food, scenic, local specialty, underrated | P1 | 4h | `P2-060` | ⬜ |

---

## 2.8 Quality, A11y, Observability

| ID | Task | Priority | Est. | Depends on | Status |
|---|---|---|---|---|---|
| `P2-070` | A11y pass — large text, contrast, semantic labels on all new screens | P0 | 1d | — | ⬜ |
| `P2-071` | Crash + analytics — wire Firebase Crashlytics + Analytics (depends on `P1-064`) | P0 | 6h | `P1-064` | ⬜ |
| `P2-072` | Composite Firestore indexes deployment (POIs, conflict queries) | P0 | 4h | `P1-055` | ⬜ |
| `P2-073` | Performance pass — `PoiCategoryScreen` list virtualization + image caching | P1 | 6h | `P1-012` | ⬜ |
| `P2-074` | Map clustering for crowded POI categories | P1 | 6h | `P1-015` | ⬜ |

---

## Phase 2 completion checklist

- [ ] Predictive alerts fire for ghat, night, fatigue, weather rules.
- [ ] Personalized ranking is visible (recently picked brand surfaces first; favorite cuisine ranks higher).
- [ ] Family / Women-Safe / Bike mode toggles change which POIs appear and how they're ranked.
- [ ] Every POI shows reliability score + source badge.
- [ ] Trip timeline shows weather per segment and traffic-aware ETA.
- [ ] At least 2 corridors have curated Hidden Gems.
