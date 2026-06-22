# 00 · Strategic Overview

This document answers the four strategic questions before the task lists:

1. How do we align the existing `journeyplus` project with the **Smart Highway Companion** vision from the PDF?
2. Should we **restart from scratch** or **extend** the existing codebase?
3. What is the **execution plan**?
4. **Where do we start**?

---

## 1. Alignment between the existing project and the PDF idea

The PDF describes a product that is essentially a **superset** of what `journeyplus` already is. Today's app is positioned narrowly (EV charging assistant). The PDF positions it broadly (AI copilot for Indian road trips, every vehicle type, every amenity).

### What already exists that maps directly to the PDF

| PDF concept | What we already have | Reusability |
|---|---|---|
| Source / Destination input | `lib/features/plan` → `RouteInputCard`, `PlanController` | **100%** — reuse |
| Route-aware EV charger discovery | `core/services/route_station_service.dart` + `google_ev_station_service.dart` | **80%** — generalize |
| Smart route dashboard (distance, ETA) | `plan_result_view.dart` with stat cards | **60%** — extend with fuel/weather/tolls |
| Crowd intelligence / community reports | `lib/features/community` (Firestore-backed pulses, photos, ratings, reliability score, conflict timeline) | **90%** — generalize from station to POI |
| Offline-first submissions | `community_submit_queue.dart` (Hive box, retry runner) | **100%** — pattern reused |
| Safety/permissions plumbing | `permission_handler`, `geolocator` integrated | **100%** — reuse |
| Auth & profile | Firebase Auth + AuthGate + profile completion gate | **100%** — reuse |
| Reliability UX (confidence, freshness, low-confidence states) | `RELIABILITY_PHASES.md` Phase 1+2 done | **100%** — reuse as foundation |

### What is missing relative to the PDF

| PDF concept | Status | What needs to happen |
|---|---|---|
| **Vehicle profiles** (petrol / diesel / EV / bike) | ❌ Implicit EV only | New `profile` feature + vehicle model |
| **Preferences** (pure-veg, family, women-safe, fast-chargers-only, pet-friendly, etc.) | ❌ | Preference model + UI chips on plan input |
| **Smart Intelligence Grid** (fuel, restaurants, washrooms, ATMs, hotels, mechanics, scenic, temples, …) | ❌ | New `discovery` feature with grid UI + reusable POI list page |
| **Generic POI domain** (not just stations) | ❌ | Generalized `Poi` entity + `pois` feature slice |
| **Predictive alerts engine** (fuel low, no charger ahead, ghat ahead, fatigue, night) | ❌ Empty `alerts/` folder | New rule-based engine + local notifications |
| **AI Travel Assistant** (voice + chat) | ❌ | New `ai_copilot` feature + AI service abstraction |
| **Recommendation engine** (learns user preferences) | ❌ | Preference store + ranking layer |
| **Family Mode / Women-Safe / Bike Rider Mode** | ❌ | Preference overlays + filter pipelines |
| **Smart Trip Timeline** (visual vertical timeline) | ❌ | New widget + active trip state |
| **Active trip tracking** + offline corridor cache | ❌ | New `trip` feature + Hive cache |
| **Hidden Gems Discovery** (AI/curated) | ❌ | Curation pipeline + later LLM generation |
| **Monetization** (sponsored placements, premium, FASTag, hotel affiliate) | ❌ Future | Phase 4 |
| **Apple CarPlay / Android Auto / Smartwatch** | ❌ Future | Phase 4 |

### Architecture: how it already aligns

The existing code uses the exact patterns the PDF's roadmap would need:

- **Feature-slice layout** (`lib/features/<feature>/{data,domain,presentation}/`).
- **Riverpod providers** with `family` keys (already used to scope by `stationKey` — same pattern works for `poiKey`).
- **Freezed immutable models** + **`fpdart`** `Either` returns for repository writes.
- **Offline-first queue** + **error taxonomy** (`network`, `permission`, `index`, `firestore`, `platform`) — these patterns are reused as-is for every new feature.
- **Firebase backend** (Firestore + Auth + later FCM) — already wired.

This is the right architecture for the PDF idea. We don't need to redesign it.

---

## 2. Restart from scratch vs extend existing — **decision: EXTEND**

### Why extending is the correct choice

1. **~70% of the MVP scaffolding already exists.** Auth, planning, route-aware EV stations, community trust system, offline submit queue, maps, location, theming, code-gen, build configs, iOS permissions plist — all done.
2. **The community + reliability system is the PDF's "Crowd Intelligence" USP.** This is the hardest part to build (data model, conflict timelines, reliability scoring, offline submission, low-confidence states). It already works. Rebuilding it would burn 4–6 weeks.
3. **The architecture already fits.** Feature-slice + Riverpod + Freezed + Firebase + Hive is the textbook stack for this kind of product. A rewrite would land on the same shape.
4. **Restart cost ≈ 6–8 weeks of zero new product value.** Re-bootstrap Firebase, re-do auth flow, re-do code-gen pipeline, re-do permissions, re-do theming — all for the same architecture we already have.
5. **The product changes are mostly additive.** New feature slices (`pois`, `discovery`, `alerts`, `trip`, `ai_copilot`, `safety`, `profile`) and generalization of two existing concepts (`ChargingStation` → `Poi`, `stationKey` → `targetKey` on community reports). No deep refactor.

### What we WILL refactor (small, contained)

- Rename product internally: `pubspec.yaml` description + `lib/main.dart` MaterialApp title + `README.md`.
- Generalize `community_station_key.dart` to support a `targetType` (so community pulses work for POIs too, while preserving station behavior).
- Add a `Vehicle` and `UserPreferences` domain on top of existing auth profile (no migration of existing user docs needed; new fields are optional).
- Generalize `route_station_service.dart` interface so a `RoutePoiService` can serve any category.

### What we will NOT touch

- Existing community reports schema (we add fields, never remove).
- Existing auth flow.
- Existing EV station data path.
- Existing reliability/confidence UI.

---

## 3. The execution plan (high level)

| Phase | Theme | Duration | Outcome |
|---|---|---|---|
| **Phase 1** | **Smart Highway Companion MVP** | 4–6 weeks | Multi-vehicle route planning + Smart Intelligence Grid + route-aware POIs + basic distance-based alerts + community pulses generalized to POIs |
| **Phase 2** | **Predictive & Personalized Intelligence** | 4–6 weeks | Predictive alert engine (ghat, fatigue, night), Family/Women-Safe/Bike modes, weather, tolls, recommendation engine |
| **Phase 3** | **AI Travel Copilot** | 6–8 weeks | Chat + voice assistant, hidden-gem AI curation, battery-aware EV routing, driving score |
| **Phase 4** | **Scale & Monetization** | Ongoing | Premium subscription, sponsored placements, hotel/FASTag affiliates, CarPlay/Android Auto, backend migration to NestJS + Postgres+PostGIS *only when scale demands* |

### Success criteria per phase

- **Phase 1**: A user can enter Pune → Nashik, pick "Petrol + family", and see a grid where tapping "Restaurants" gives only highway-corridor places, with a community pulse on each. App fires "Fuel low? Last trusted pump for next 68 km" type alerts during the trip.
- **Phase 2**: The same trip is personalized — favorite brand surfaces first, ghat warning fires before the climb, family-mode filters hygienic stops, weather chip per segment.
- **Phase 3**: User holds voice button and says "Find women-safe stop with clean washroom in next 30 km" → gets a ranked answer with reasoning.
- **Phase 4**: The product has revenue and runs on a scalable backend.

---

## 4. Where to start (Day 1 → Day 7)

Open `01_phase_1_mvp.md` and execute these IDs in order:

1. **`P1-001`** — Internal rebrand (pubspec description, app title, README). 30 minutes.
2. **`P1-003`** — Create `Vehicle` domain model. 1 hour.
3. **`P1-004`** — Create `profile` feature (vehicle + preferences in Hive). 4 hours.
4. **`P1-006`** — Create generic `Poi` domain model. 2 hours.
5. **`P1-007`** — Scaffold `pois` feature slice (folders + provider seams). 2 hours.
6. **`P1-009`** — Refactor `route_station_service.dart` → generalized `RoutePoiService` (keep EV path working). 1 day.
7. **`P1-008`** — Plug Google Places along-corridor as POI data source for ~3 categories (fuel, restaurant, washroom) to validate the path end-to-end. 1–2 days.

By end of Week 1 you should have the data path proven for at least 3 POI categories with route-corridor filtering — the rest of Phase 1 is largely UI + repeating the pattern for more categories + alert engine.

---

## North-star principles (do not violate)

These come straight from the PDF and existing reliability work. They are non-negotiable:

1. **Route-aware, not nearby.** All discovery is filtered by the journey corridor, not radial distance from the user.
2. **Predictive, not reactive.** The app warns *before* a problem (fuel, charger gap, ghat, fatigue, night).
3. **Trustworthy under weak network.** Offline-first everywhere — community submits queue, corridor data caches, alerts fire from local rules.
4. **Reduce travel anxiety.** Every UI choice is judged against "does this calm the driver?"
5. **India-first.** Family safety, women-safe stops, pure-veg, ghat sections, temples — these are not afterthoughts.
6. **Trust signals everywhere.** Reliability score, sample size, freshness, conflict warnings, source badges (`Official` / `Community-verified` / `Unverified`) on every recommendation.
