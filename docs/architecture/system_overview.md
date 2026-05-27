# System Overview

High-level system architecture of TripPlus — what runs where, what talks to what.

> Two views below: **(A) the current architecture** as it exists today and **(B) the target Phase-3 architecture** after the AI copilot ships. Phase 4 backend-at-scale variant is a footnote.

---

## A) Current architecture (Phases 1–2)

```
┌────────────────────────────────────────────────────────────────────┐
│                         📱 Flutter app                              │
│  ┌──────────────┐  ┌──────────────┐  ┌──────────────────────────┐  │
│  │ presentation │  │   domain     │  │           data           │  │
│  │  (Riverpod   │→ │  (Freezed    │← │  Repositories            │  │
│  │  + widgets)  │  │   entities)  │  │    Either<Failure, T>    │  │
│  └──────┬───────┘  └──────────────┘  └────────┬─────────────────┘  │
│         │                                      │                   │
│  ┌──────┴─────────┐                  ┌────────┴──────────────────┐ │
│  │ Riverpod       │                  │  Local: Hive boxes        │ │
│  │ ProviderScope  │                  │  - charging               │ │
│  │ (root)         │                  │  - community_submit_queue │ │
│  └────────────────┘                  │  - user_profile (P1)      │ │
│                                      │  - active_trip (P1)       │ │
│                                      │  - corridor_cache (P1)    │ │
│                                      └───────────────────────────┘ │
└────────────┬───────────────┬──────────────────┬────────────────────┘
             │               │                  │
   ┌─────────▼────────┐  ┌───▼─────────┐  ┌────▼────────────────┐
   │  Firebase        │  │  Google     │  │   Open Charge Map   │
   │  ──────────      │  │  ──────     │  │   ────────────────  │
   │  • Auth          │  │  • Maps SDK │  │   • EV stations API │
   │  • Firestore:    │  │  • Places   │  │                     │
   │    - users       │  │  • Direc-   │  │   (Phase 2: add     │
   │    - station     │  │    tions    │  │    Open-Meteo for   │
   │      Community   │  │  • Geo-     │  │    weather)         │
   │      Reports     │  │    coding   │  │                     │
   │  • Cloud Funcs   │  │  • Auto-    │  └─────────────────────┘
   │    (Phase 3)     │  │    complete │
   │  • FCM (P2+)     │  │  • Eleva-   │
   │  • Crashlytics   │  │    tion(P2) │
   │    + Analytics   │  │             │
   │    (P2)          │  │             │
   └──────────────────┘  └─────────────┘
```

### Layers explained

| Layer | Where | Responsibility |
|---|---|---|
| **Presentation** | `lib/features/<f>/presentation/` | UI + Riverpod controllers. No business logic in widgets. |
| **Domain** | `lib/features/<f>/domain/` + `lib/core/domain/` | Freezed entities + UI state sealed unions. Pure Dart. |
| **Data** | `lib/features/<f>/data/` | Repositories (Either<Failure, T>), DTOs, local DB. Only place that touches Firestore/Dio/Hive directly. |
| **Core services** | `lib/core/services/` | Thin SDK/API clients reused across features (`directions_service`, `geocoding_service`, etc.). |

### Process model

- **Single Dart isolate** for UI + business logic (Flutter default).
- **Native foreground service** (Android, Phase 1 `P1-042`) for location during an active trip.
- **No backend** today (everything goes directly to Firestore + Google APIs).

---

## B) Target architecture (after Phase 3)

```
┌────────────────────────────────────────┐
│            📱 Flutter app              │
└────────────┬───────────────────────────┘
             │
   ┌─────────▼─────────────────┐
   │  AI Service Layer (Dart)  │   Provider-pluggable
   │  lib/core/services/       │   (OpenAI / Gemini swap)
   │  ai_service.dart          │
   └─────────┬─────────────────┘
             │ HTTPS (only the proxy URL is in the app)
   ┌─────────▼──────────────────────────────────────┐
   │  Firebase Cloud Functions (AI proxy)           │
   │  • Holds API keys (server-side env)            │
   │  • Per-uid rate limiting                       │
   │  • Prompt templating (versioned, Remote Config)│
   │  • Tool routing (find_poi, compare_routes,     │
   │    narrate_trip) → calls back to our app's     │
   │    Firestore + Places via service account      │
   └─────────┬──────────────────────────────────────┘
             │
   ┌─────────▼──────────────┐    ┌──────────────────────┐
   │  OpenAI / Gemini API   │    │  Firestore (same as  │
   │  (LLM provider, swap-  │    │  current arch)       │
   │   able)                │    │                      │
   └────────────────────────┘    └──────────────────────┘
```

Everything from architecture (A) still applies — the AI layer is **additive**.

### Phase 4 (only if scale demands)

```
Flutter app ──▶ NestJS Gateway ──▶ Postgres + PostGIS  (spatial POI search)
                       │            Redis             (hot route/POI cache)
                       │            Kafka             (community ingestion)
                       └─────────▶ AI proxy (migrated from Cloud Functions)
```

Phase 4 backend migration is *opt-in* (see ADR-001) — we only do it when Firestore reads become a top-3 cost line or queries outgrow Firestore.

---

## Key cross-cutting decisions

| Decision | Why |
|---|---|
| Feature-slice + Riverpod + Freezed + fpdart | Idiomatic, scales to dozens of features without conflict (see ADR-003) |
| `Either<Failure, T>` returns from repos | Predictable error UX (see ADR-004) |
| Photos as base64 inline on Firestore docs | Cheap reads, no Storage rules to maintain (see ADR-002) |
| Stable target identity helpers (`stationKey`, `poiKey`) | Same physical place collapses to one community thread across sources |
| Offline-first writes via Hive queue | Highway-grade reliability under weak network |
| AI keys on server proxy only | Security + rate limit (see ADR-006) |

---

## Repository hot map

The files most touched / most central:

- `lib/main.dart` — bootstrap (Firebase, Hive boxes, ProviderScope, AuthGate)
- `lib/features/auth/presentation/view/auth_gate.dart` — entry routing
- `lib/features/shell/presentation/view/app_shell.dart` — tab navigation
- `lib/features/community/data/repository/community_report_repository.dart` — the canonical "modern" repo
- `lib/features/community/presentation/controller/station_community_controller.dart` — canonical controller pattern
- `lib/features/community/domain/community_station_key.dart` — stable identity pattern (to be generalized)
- `lib/core/services/route_station_service.dart` — to be generalized to `route_poi_service.dart`
- `lib/core/utils/result.dart` — Failure taxonomy

When learning the codebase, read these in order.
