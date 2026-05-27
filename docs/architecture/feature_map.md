# Feature Map

A bird's-eye list of every feature slice in `lib/features/` — what it does, its status, and which task IDs touch it.

| Feature | Today | Phase 1 changes | Phase 2 changes | Phase 3 changes | Phase 4 changes |
|---|---|---|---|---|---|
| `auth` | Firebase Auth + Google Sign-In + AuthGate + profile completion gate | none | none | Privacy: opt-out controls (`P3-042`) | Sub status linked to uid (`P4-001`) |
| `onboarding` | Splash + intro screens before sign-in | Branding refresh (`P1-029`) | none | none | none |
| `shell` | Bottom-nav AppShell (Plan / Insights / Stations) | Revise tabs → Plan · Trip · Discover · Profile (`P1-016`) | Add settings entry (`P2-053`) | Floating AI FAB (`P3-013`) | Subscription pill (`P4-002`) |
| `plan` | Route input + plan controller + result view | Vehicle/pref override on input (`P1-005`), Extended `PlanResult` (`P1-018`), Trip Dashboard (`P1-019`), Trip Timeline (`P1-020`) | Weather + traffic-aware ETA + tolls (`P2-040..42`) | Battery-aware EV routing (`P3-060`) | Hotel affiliate stops (`P4-005`) |
| `stations` | EV station list + map + detail (existing, OCM + Google EV) | Continue to work as `PoiCategory.ev` specialization via adapter on top of `RoutePoiService` (`P1-009`) | Charger reliability v2 (`P2-030`) | Queue prediction (`P3-061`), Compat matcher (`P3-062`) | Sponsored stations (`P4-003`) |
| `charging` | Local cache + charging-session domain | Stays as-is | none | EV-deep features land here | none |
| `community` | Pulses for stations (Firestore-backed, offline queue, reliability scoring, conflict timeline, photos as base64) | Generalize schema `targetType` + `targetKey` (`P1-050..55`), POI pulses (`P1-052..54`) | Mode-tag pulses (`P2-023`), Conflict timeline on POIs (`P2-031`) | none | Kafka ingestion at scale (`P4-023`) |
| `insights` | Minimal placeholder screen | May fold into Trip dashboard | none | none | none |
| `alerts` | Empty folder | Domain + rule engine + 3 rules + notifications (`P1-022..028, P1-034`) | Ghat/Night/Fatigue/Weather + dedup + priorities (`P2-001..007`) | Voice spoken-summary alerts (`P3-033`) | Premium-only advanced alerts (`P4-002`) |
| `profile` 🆕 | does not exist | Create feature slice; vehicle + preferences (`P1-003..005, P1-031..033`) | Settings screen (`P2-053`) | What I learned (`P3-041`), Privacy (`P3-042`) | Premium status surface (`P4-001`) |
| `pois` 🆕 | does not exist | New slice — generic POI domain + GooglePlacesPoiSource + repository (`P1-006..010, P1-061`) | PoiRanker (`P2-011..013`) | Tool `find_poi` (`P3-021`) | Postgres+PostGIS migration (`P4-021`) |
| `discovery` 🆕 | does not exist | Smart Intelligence Grid + `PoiCategoryScreen` (`P1-011..015, P1-062`) | Hidden Gems carousel (`P2-061`), Mode filters (`P2-020..022`) | none | none |
| `trip` 🆕 | does not exist | Active trip state + foreground location + corridor cache + offline banner (`P1-040..044, P1-017`) | History + share + reuse (`P2-050..052`) | Tool `narrate_trip` (`P3-023`) | Trip recording premium (`P4-001`) |
| `ai_copilot` 🆕 (P3) | does not exist | none | none | New slice — service abstraction, chat, voice, memory, intent routing (`P3-001..042`) | NestJS proxy migration (`P4-025`) |
| `safety` 🆕 (future) | partial coverage by `alerts` | none | Women-safe overlay (`P2-021`) | none | Dashcam MVP (`P4-014`) |

---

## Dependency map (feature ↔ feature)

```
auth ─────────────┐
                  ▼
shell ◀── onboarding
   │
   ├── plan ──────────────► pois (Phase 1)
   │                          │
   ├── trip (Phase 1) ◀───────┘
   │      │
   │      ├──► alerts
   │      └──► ai_copilot (Phase 3)
   │
   ├── discovery (Phase 1) ──► pois
   │
   ├── stations (becomes pois.ev specialization)
   │      └──► community (existing)
   │
   ├── profile (Phase 1)
   │
   └── insights (fades or absorbs into trip)

community is a *shared service*: any feature that has POIs uses it via
`poiCommunityControllerProvider.family(targetKey)`.
```

---

## What gets refactored, in order

| Order | Refactor | Phase 1 ID |
|---|---|---|
| 1 | `pubspec.yaml` description + `MaterialApp.title` + README | `P1-001`, `P1-002`, `P1-029` |
| 2 | Add `Vehicle` + `UserPreferences` to `core/domain` + new `profile` feature | `P1-003`, `P1-004`, `P1-031..033` |
| 3 | Add `Poi` + `PoiCategory` to `core/domain` + new `pois` feature scaffold | `P1-006`, `P1-007` |
| 4 | Add `GooglePlacesPoiSource` (along corridor) | `P1-008` |
| 5 | Generalize `route_station_service.dart` → `route_poi_service.dart` (keep station path via adapter) | `P1-009` |
| 6 | Generalize community schema (`targetType` + `targetKey`) + repository + provider | `P1-050..055` |
| 7 | New `discovery` feature + grid + category screen | `P1-011..015` |
| 8 | New `trip` feature + active trip + corridor cache | `P1-040..044, P1-017` |
| 9 | Extend `PlanResult` + Trip Dashboard + Smart Timeline | `P1-018..021` |
| 10 | New `alerts` feature + engine + rules + local notifications | `P1-022..028, P1-034` |
| 11 | AppShell tabs revised (last — needs all above) | `P1-016` |
