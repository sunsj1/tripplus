# Hotline fixes — Wave 2 (live travel reliability)

> **Goal:** Make marketed trip behaviour true on real devices: predictive alerts fire while driving (phone locked / Maps open), and corridor lists (fuel, chargers, stops) show **only ahead** items based on accurate live GPS.
>
> **How to use:** Complete **one batch at a time** in the order below. Mark status in [`batches.md`](./batches.md). Run `flutter analyze` after each batch. Run `dart run build_runner` only when Freezed models change.
>
> **UI rule:** Additive / reliability fixes only. Do not redesign the Plan · Trip · Discover · Profile shell.

---

## Wave history

| Wave | Scope | Status |
|------|--------|--------|
| **Wave 1** | Multi-route picker, toll Yes/No, per-route recompute, fuel defaults | ✅ Done — old `docs/Hotline fixes.md` removed (2026-07-18) |
| **Wave 2** | Background trip tracking + live alerts + ahead-on-corridor POIs | 🔵 This folder |

---

## Status legend

| Symbol | Meaning |
|--------|---------|
| ✅ | Done |
| 🔵 | Next up |
| ⬜ | Not started |
| 🟡 | Partially done |

---

## Confidence targets (from audit)

| Surface | Today | After Wave 2 |
|---------|-------|----------------|
| Engine / rules | ~85% | **100%** |
| Foreground delivery | ~75% | **100%** |
| Real-device travel (locked / Maps) | ~5% / ~42% overall | **~95%** practical |
| Force-killed app | ~5% | Best-effort (Android FGS ≫ iOS) — not marketed as 100% |

FCM is **out of scope** for Wave 2 corridor alerts. Use on-device location + local notifications.

---

## Suggested execution order

```
A0 (GPS foundation)
  → A1 (Android FGS)
  → A2 (iOS background location)
  → A3 (alerts evaluate-on-tick + delivery polish)
  → A4 (engine / history / fatigue correctness)
  → A5 (live ahead-on-corridor POIs / stations)
  → A6 (permission & silent-failure UX)
  → A7 (device QA + marketing claim sign-off)
```

**Minimum viable (marketing claim for alerts):** **A0 → A1 → A2 → A3 → A7** (~4–6 days)

**Full travel reliability (alerts + ahead lists):** all batches **A0 → A7** (~7–10 days)

**Current:** A0 ✅ · A1/A2 🟡 (physical QA → A7) · A3–A6 ✅ · **Next:** A7 🔵 (device matrix + marketing sign-off).

---

## Files in this folder

| File | Purpose |
|------|---------|
| [`requirements.md`](./requirements.md) | Marketed promise vs gaps; done-when criteria |
| [`batches.md`](./batches.md) | Task IDs, dependencies, acceptance per batch |

---

## What we are **not** changing in Wave 2

- Bottom tab order / shell redesign
- Community report schema (immutable; add fields only if required)
- Sponsored / monetization
- FCM / Cloud Functions for re-engagement (`P4-032` stays Phase 4)
- Replacing Riverpod, Hive, or Firebase Auth/Firestore

---

*Created: 2026-07-18 · Track progress by flipping ⬜ → ✅ in `batches.md`.*
