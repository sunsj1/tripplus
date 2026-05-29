# TripPlus — Notion Tracker

> Import this file into Notion as a **page** (not a database). The checkboxes will be live and you can tick them off as you progress.
> The same task IDs are mirrored in `tasks.csv` (for the database view) and in `01_phase_1_mvp.md` etc.

**How to update progress:**
1. When you finish a task, just tell me the ID (e.g. *"P1-007 done"*).
2. I'll set `[x]` in this file, change the `Status` column in `tasks.csv`, and update the phase markdown.

---

## Legend
- `[ ]` Not started
- `[/]` In progress
- `[x]` Done
- `[!]` Blocked
- `[-]` Cancelled

---

## Phase 1 — Smart Highway Companion MVP

### 1.1 Branding & identity
- [x] `P1-001` Update `pubspec.yaml` description to "AI Highway Companion for Indian road trips"
- [x] `P1-002` Update `MaterialApp.title` in `lib/main.dart`
- [x] `P1-029` Replace default Flutter README with product README
- [x] `P1-030` Launch icon + splash for new brand

### 1.2 Vehicle profile & preferences
- [x] `P1-003` Create `vehicle.dart` — VehicleType enum + Vehicle entity
- [x] `P1-031` `UserPreferences` model (pureVeg, family, women-safe, fastChargersOnly, etc.)
- [x] `P1-004` `lib/features/profile/` slice with Hive persistence
- [x] `P1-032` Profile setup screen (post-onboarding)
- [x] `P1-033` Profile edit screen (in AppShell)
- [x] `P1-005` Extend plan input UI with vehicle + preference chips

### 1.3 Generalized POI domain
- [x] `P1-006` Create `poi.dart` — generic `Poi` + `PoiCategory` enum
- [x] `P1-007` Scaffold `lib/features/pois/` slice
- [x] `P1-008` `GooglePlacesPoiSource` along-route POI search
- [x] `P1-009` Generalize `route_station_service.dart` → `route_poi_service.dart`
- [x] `P1-010` Community schema fields `targetType` + `targetKey` on POI

### 1.4 Smart Intelligence Grid
- [x] `P1-011` `DiscoveryScreen` 3-column grid of all PoiCategory items
- [x] `P1-012` `PoiCategoryScreen` reusable route-aware POI list
- [x] `P1-013` Wire grid items → `PoiCategoryScreen`
- [x] `P1-014` Empty / loading / error states
- [x] `P1-015` Map view toggle

### 1.5 AppShell navigation
- [x] `P1-016` Revise tabs: **Plan · Trip · Discover · Profile**
- [x] `P1-017` Trip tab — active dashboard or plan CTA

### 1.6 Smart Route Dashboard
- [x] `P1-018` Extend `PlanResult` model (ETA, tolls, fuel, charging, weather/traffic placeholders)
- [x] `P1-019` Trip Dashboard stat-card row
- [x] `P1-020` Smart Trip Timeline widget
- [x] `P1-021` Timeline editor (pin/unpin POIs)

### 1.7 Distance-based Alerts Engine (MVP)
- [x] `P1-022` Create `alert.dart` — Alert entity + AlertType enum
- [x] `P1-023` `AlertEngine` rule evaluator
- [x] `P1-024` Rule: **Fuel Low**
- [x] `P1-025` Rule: **EV Gap**
- [x] `P1-026` Rule: **Food Window**
- [x] `P1-027` Add `flutter_local_notifications` + platform setup
- [x] `P1-028` `AlertNotifier` stream + banner + notifications
- [x] `P1-034` Alert history screen per trip

### 1.8 Active Trip & offline corridor cache
- [x] `P1-040` `lib/features/trip/` + `Trip` model
- [x] `P1-041` `ActiveTripController` + Hive persist
- [x] `P1-042` Foreground location tracking (opt-in)
- [x] `P1-043` Offline corridor cache (polyline + first 50 POIs/category)
- [x] `P1-044` Offline detection + degraded mode banner

### 1.9 Community pulses → POIs
- [x] `P1-050` Schema: `targetType` + `targetKey` (back-compat with `stationKey`)
- [x] `P1-051` Update `community_report_repository.dart` for generic key
- [x] `P1-052` Add `poiCommunityControllerProvider.family`
- [x] `P1-053` Mount `CommunityReportsSection` on POI detail screens
- [x] `P1-054` Mount `CommunityRatingPulse` on POI list tiles
- [x] `P1-055` Firestore composite index `targetKey + createdAt`

### 1.10 Cross-cutting hygiene
- [x] `P1-060` Telemetry hooks on new flows
- [x] `P1-061` Error taxonomy parity for `PoiRepository`
- [x] `P1-062` Skeleton loaders for POI lists
- [x] `P1-063` Add `flutter_local_notifications` + `connectivity_plus` deps
- [x] `P1-064` Add Crashlytics dependency (init only)
- [x] `P1-065` Rolling: update `docs/context/current_state.md`

---

## Phase 2 — Predictive & Personalized Intelligence

### 2.1 Predictive Alerts v2
- [ ] `P2-001` Upcoming-window rules
- [ ] `P2-002` Ghat / Risk alert
- [ ] `P2-003` Night alert
- [ ] `P2-004` Fatigue alert
- [ ] `P2-005` Weather alerts
- [ ] `P2-006` Alert deduplication + cooldown
- [ ] `P2-007` Alert priorities + presentation

### 2.2 Personalization & ranking
- [ ] `P2-010` `UserPreferenceVector`
- [ ] `P2-011` `PoiRanker` scoring
- [ ] `P2-012` Apply ranker to all POI lists
- [ ] `P2-013` Brand affinity learning

### 2.3 Mode-aware filters
- [ ] `P2-020` Family Mode
- [ ] `P2-021` Women-Safe Mode + badge
- [ ] `P2-022` Bike Rider Mode
- [ ] `P2-023` Community pulse tags for mode attributes

### 2.4 Trust v2
- [ ] `P2-030` Generalize reliability score to POIs
- [ ] `P2-031` Conflict-aware timeline on POIs
- [ ] `P2-032` Source badges on every POI
- [ ] `P2-033` "Why we recommend this" explainer

### 2.5 Environmental integrations
- [ ] `P2-040` Weather (Open-Meteo) per segment
- [ ] `P2-041` Traffic-aware ETA
- [ ] `P2-042` Toll estimation v1
- [ ] `P2-043` Road-condition tag aggregation

### 2.6 Trip lifecycle
- [ ] `P2-050` Trip history list
- [ ] `P2-051` Save & reuse trip
- [ ] `P2-052` Share trip
- [ ] `P2-053` Settings screen

### 2.7 Hidden gems v1 (curated)
- [ ] `P2-060` Curation dataset
- [ ] `P2-061` Hidden Gems carousel
- [ ] `P2-062` Tag categories

### 2.8 Quality, A11y, Observability
- [ ] `P2-070` A11y pass
- [ ] `P2-071` Crashlytics + Analytics
- [ ] `P2-072` Composite index deployment
- [ ] `P2-073` List virtualization + image cache
- [ ] `P2-074` Map clustering

---

## Phase 3 — AI Travel Copilot

### 3.1 AI service abstraction
- [ ] `P3-001` `ai_service.dart` provider-pluggable
- [ ] `P3-002` Server proxy (Cloud Functions / NestJS)
- [ ] `P3-003` Prompt library versioned
- [ ] `P3-004` Trip context packer

### 3.2 Assistant UI
- [ ] `P3-010` `lib/features/ai_copilot/` slice
- [ ] `P3-011` Chat screen w/ streaming
- [ ] `P3-012` Quick-prompt chips
- [ ] `P3-013` Floating launch button
- [ ] `P3-014` Inline rich-result cards

### 3.3 Intent routing
- [ ] `P3-020` Intent classifier (tool calling)
- [ ] `P3-021` Tool `find_poi`
- [ ] `P3-022` Tool `compare_routes`
- [ ] `P3-023` Tool `narrate_trip`
- [ ] `P3-024` Guardrails (no fabrication)

### 3.4 Voice
- [ ] `P3-030` `speech_to_text` push-to-talk
- [ ] `P3-031` `flutter_tts` replies
- [ ] `P3-032` Hands-free mode
- [ ] `P3-033` Audio-only result mode

### 3.5 Memory
- [ ] `P3-040` Long-term preference vectors in Firestore
- [ ] `P3-041` "What I learned" screen
- [ ] `P3-042` Opt-out controls

### 3.6 AI hidden gems
- [ ] `P3-050` LLM-generated gems w/ citation
- [ ] `P3-051` Moderation queue

### 3.7 EV deep
- [ ] `P3-060` Battery-aware routing v1
- [ ] `P3-061` Charging queue prediction v1
- [ ] `P3-062` Charger compatibility matcher

### 3.8 Driving Score
- [ ] `P3-070` Score function
- [ ] `P3-071` Score screen in Profile

---

## Phase 4 — Scale & Monetization

### 4.1 Monetization
- [ ] `P4-001` Premium subscription (RevenueCat)
- [ ] `P4-002` Paywall placement
- [ ] `P4-003` Sponsored stations + admin
- [ ] `P4-004` Featured restaurants
- [ ] `P4-005` Hotel affiliate deep-links
- [ ] `P4-006` FASTag deep-link
- [ ] `P4-007` Travel insurance partnership

### 4.2 Platform expansion
- [ ] `P4-010` Apple CarPlay
- [ ] `P4-011` Android Auto
- [ ] `P4-012` Wear OS
- [ ] `P4-013` watchOS
- [ ] `P4-014` Dashcam MVP

### 4.3 Backend at scale (only if needed)
- [ ] `P4-020` NestJS gateway
- [ ] `P4-021` Postgres + PostGIS migration for POIs
- [ ] `P4-022` Redis hot cache
- [ ] `P4-023` Kafka community ingestion
- [ ] `P4-024` Background ML pipeline
- [ ] `P4-025` AI proxy migration to NestJS

### 4.4 Growth & retention
- [ ] `P4-030` Referral program
- [ ] `P4-031` In-app review prompt
- [ ] `P4-032` Re-engagement notifications

---

## Quick metrics — fill as we go

| Phase | Total Tasks | Done | % |
|---|---|---|---|
| Phase 1 — MVP | 50 | 50 | 100% |
| Phase 2 — Intelligence | 36 | 0 | 0% |
| Phase 3 — AI Copilot | 30 | 0 | 0% |
| Phase 4 — Scale | 18 | 0 | 0% |
| **Total** | **134** | **0** | **0%** |
