# Architecture Decision Records (ADRs)

Each entry is a short, immutable decision record. Append new ones — do not edit old ones (mark `Superseded by ADR-N` instead).

Template:

```
## ADR-NNN — Short title
Date: YYYY-MM-DD
Status: Accepted | Superseded by ADR-N | Deprecated

### Context
What problem are we solving?

### Decision
What did we choose?

### Consequences
What is now true / harder / easier as a result?

### Alternatives considered
What else was on the table and why we rejected it.
```

---

## ADR-001 — Extend the existing `journeyplus` project instead of restarting
Date: 2026-05-27
Status: Accepted

### Context
The PDF `Smart_Highway_Companion_Idea.pdf` describes a product (multi-vehicle AI highway companion) that is a *superset* of the current `journeyplus` (EV charging assistant). Question: rewrite from scratch or extend?

### Decision
**Extend.** Build new feature slices and generalize two existing concepts (`ChargingStation` → `Poi`, `stationKey` → `targetKey`).

### Consequences
- We keep ~70% of MVP scaffolding (auth, planning, route-aware station service, community trust, offline submit queue).
- We keep the community + reliability system intact — it *is* the PDF's "Crowd Intelligence" USP.
- All changes are additive feature slices + two contained generalizations.
- Internal product rebrand needed (pubspec, README, app title) — small.

### Alternatives considered
- **Rewrite.** Rejected: 6–8 weeks of zero new product value rebuilding the same Riverpod + Firebase + Hive architecture we'd land on anyway.

---

## ADR-002 — Community photos stored as base64 JPEG inline on Firestore docs
Date: 2026-04-06 (pre-existing decision, recorded here)
Status: Accepted

### Context
Need to attach photos to community reports without paying for Firebase Storage reads and without an extra round-trip when rendering the feed.

### Decision
Compress photos to JPEG client-side (`flutter_image_compress`), encode as base64, store inline on the Firestore document. Hard cap at a safe document size; pick limit at 5 MB.

### Consequences
- Single Firestore read returns photo + metadata — fast feed render.
- No Firebase Storage cost or rules to maintain.
- Documents are larger; we counter with a small `limit(50)` on community feeds and aggressive in-app sort/truncate.

### Alternatives considered
- Firebase Storage with signed URLs. Rejected for cost + complexity.
- Cloudinary / external CDN. Rejected for vendor sprawl at MVP scale.

---

## ADR-003 — Use Riverpod (`flutter_riverpod`) for state management
Date: 2026-04-04 (pre-existing, recorded here)
Status: Accepted

### Context
The app needs scoped state per entity (per-station community feed, per-trip controllers, per-POI controllers).

### Decision
Riverpod with `family.autoDispose` for entity-scoped providers; `StateNotifier<UiState>` (Freezed sealed unions) for controllers.

### Consequences
- Idiomatic Riverpod patterns everywhere.
- No `BuildContext` for state access.
- AsyncValue gives free loading/error/data handling.

### Alternatives considered
- `provider`, BLoC, GetX — rejected for ergonomics or convention drift.

---

## ADR-004 — Error taxonomy for repositories
Date: 2026-04-08 (pre-existing, recorded here)
Status: Accepted

### Context
Silent failures degrade trust. Every repository write must produce a UI-actionable signal.

### Decision
Repository writes return `Either<Failure, T>` (fpdart). `Failure` carries one of six categories: `network`, `permission`, `index`, `firestore`, `platform`, `quota`. UI maps each to an explicit CTA (`Retry now`, `Open settings`, …).

### Consequences
- All new repositories must honor this taxonomy.
- Existing community + auth repos already do.

### Alternatives considered
- Raw exceptions. Rejected — leaks SDK details to UI and produces unactionable error states.

---

## ADR-005 — Generalize community reports from station to any POI (Phase 1)
Date: 2026-05-27
Status: Accepted (planned for `P1-050`)

### Context
The PDF requires community pulses on all POI types (restaurants, washrooms, hotels, …), not only stations.

### Decision
Extend the `stationCommunityReports` Firestore schema with two fields:
- `targetType: 'station' \| 'poi'`
- `targetKey: string`

Keep `stationKey` as a back-compat read path. New writes set both `stationKey` (when applicable) and `targetKey`.

### Consequences
- No collection split — single source of truth for community pulses.
- New composite index `targetKey + createdAt` (added to `firestore.indexes.json`).
- One generic `CommunityRepository.watchByTarget(targetKey)` that the rest of the app uses.

### Alternatives considered
- New collection `poiCommunityReports`. Rejected — duplicates the entire reliability stack and complicates the conflict-timeline logic.

---

## ADR-006 — AI API keys stay on a server proxy, never in the client (Phase 3)
Date: 2026-05-27
Status: Accepted (planned for `P3-002`)

### Context
The PDF roadmap includes OpenAI / Gemini APIs. Bundling keys in a Flutter binary leaks them.

### Decision
All AI calls go through a server proxy. Start as Firebase Cloud Functions (we're already on Firebase) with per-uid rate-limiting and prompt-template versioning via Remote Config. Migrate to NestJS gateway in Phase 4 only when scale demands.

### Consequences
- App builds never contain AI vendor keys.
- Prompt updates ship without app updates.
- Adds a small request hop — acceptable.

### Alternatives considered
- Direct OpenAI from client. Rejected — leaks key, no rate-limit, no auditability.
