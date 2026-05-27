# Phase 4 — Scale & Monetization

**Goal:** Turn on revenue, expand surfaces (CarPlay, Wear, Dashcam), and migrate backend only when scale demands it.

**Target duration:** Ongoing.
**Prerequisite:** Phases 1–3 stable, real user retention signal.

> Track each task by its **ID** (e.g. `P4-005`).

---

## 4.1 Monetization

| ID | Task | Priority | Est. | Depends on | Status |
|---|---|---|---|---|---|
| `P4-001` | Premium subscription — RevenueCat (recommended) or Stripe + StoreKit/Play Billing; tier: AI assistant, offline maps, advanced alerts, family safety, route recording | P0 | 1w | — | ⬜ |
| `P4-002` | Paywall placement — assistant + offline + family safety = premium gates | P0 | 3d | `P4-001` | ⬜ |
| `P4-003` | Sponsored station placements — admin tool to mark sponsored, ranking layer surfaces them with `Sponsored` badge (legally required disclosure) | P1 | 1w | — | ⬜ |
| `P4-004` | Featured restaurants on corridor with `Featured` badge | P1 | 4d | `P4-003` | ⬜ |
| `P4-005` | Hotel booking deep-links with affiliate ID injection (e.g. MMT, Goibibo, Booking.com) | P1 | 1w | — | ⬜ |
| `P4-006` | FASTag recharge deep-link integration | P2 | 4d | — | ⬜ |
| `P4-007` | Travel insurance partnership flow | P2 | 1w | — | ⬜ |

---

## 4.2 Platform expansion

| ID | Task | Priority | Est. | Depends on | Status |
|---|---|---|---|---|---|
| `P4-010` | Apple CarPlay support — driving-safe minimal UI (assistant, alerts, next stop) | P1 | 2w | `P3-033` | ⬜ |
| `P4-011` | Android Auto support — parallel to CarPlay | P1 | 2w | `P3-033` | ⬜ |
| `P4-012` | Wear OS companion — current trip glance + next-stop card | P2 | 2w | — | ⬜ |
| `P4-013` | watchOS companion — same scope | P2 | 2w | — | ⬜ |
| `P4-014` | Dashcam integration MVP — phone-as-dashcam record on active trip | P2 | 1w | — | ⬜ |

---

## 4.3 Backend at scale (only if/when needed)

> Triggers: >100K MAU **or** Firestore read costs become a top-3 line item **or** queries become too complex for Firestore.

| ID | Task | Priority | Est. | Depends on | Status |
|---|---|---|---|---|---|
| `P4-020` | Stand up NestJS gateway in front of Firestore (read-through cache, complex queries) | P1 | 3w | — | ⬜ |
| `P4-021` | Migrate POI search to Postgres + PostGIS for true corridor/spatial queries | P1 | 4w | `P4-020` | ⬜ |
| `P4-022` | Redis cache layer for hot routes & POI lists | P1 | 1w | `P4-020` | ⬜ |
| `P4-023` | Kafka pipeline for community report ingestion at scale | P2 | 3w | `P4-020` | ⬜ |
| `P4-024` | Background ML pipeline — trust scoring, queue prediction (Phase 3 features as scheduled jobs) | P2 | 4w | `P4-020` | ⬜ |
| `P4-025` | Migrate AI proxy from Cloud Functions to NestJS gateway | P2 | 1w | `P4-020` | ⬜ |

---

## 4.4 Growth & retention

| ID | Task | Priority | Est. | Depends on | Status |
|---|---|---|---|---|---|
| `P4-030` | Referral program — invite gets 1 month premium for both | P1 | 1w | `P4-001` | ⬜ |
| `P4-031` | In-app review prompt after successful long trips | P1 | 2d | — | ⬜ |
| `P4-032` | Re-engagement notifications — "Heading to Mumbai again? Plan in one tap" | P2 | 3d | — | ⬜ |

---

## Phase 4 completion checklist

This phase is *ongoing*. Mark individual IDs done as they ship. No hard "complete" state.
