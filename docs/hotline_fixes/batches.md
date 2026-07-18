# Wave 2 — Batches & tasks

> Complete **one batch at a time**. Flip ⬜ → 🔵 when starting, → ✅ when done.
> Task IDs: `HA-xxx` (Hotline Alerts / Ahead). Dependencies listed per batch.

---

## Dependency graph (high level)

```
A0 GPS foundation ──────────────────────────────┐
     │                                          │
     ├─► A1 Android FGS ──┐                     │
     │                    ├─► A3 Alert delivery ├─► A6 UX CTAs ─► A7 QA
     └─► A2 iOS BG loc ───┘         │           │
                                    │           │
                              A4 Engine polish  │
                                    │           │
                              A5 Ahead POIs ◄───┘
                                   (needs A0 PositionState)
```

| Batch | Depends on | Unblocks |
|-------|------------|----------|
| **A0** | — | A1, A2, A3, A5 |
| **A1** | A0 | A3, A7 (Android) |
| **A2** | A0 | A3, A7 (iOS) |
| **A3** | A0, A1 *(Android)*, A2 *(iOS)* | A4, A6, A7 |
| **A4** | A3 | A7 |
| **A5** | A0 *(can parallel A1–A4 after A0)* | A7 |
| **A6** | A3 | A7 |
| **A7** | A1–A6 (min: A0–A3) | Production claim |

**Parallel tip:** After **A0**, run **A5** in parallel with **A1/A2** if two people/agents. Do **not** start **A3** until A1 (and A2 if shipping iOS) land — otherwise “background alerts” still fail on device.

---

## Batch A0 — Live GPS foundation ✅

**Theme:** One Riverpod source of truth for “where am I on the corridor?” so alerts and ahead-lists share the same position.

**Priority:** P0 · **Effort:** 0.5–1 day · **Deps:** none

| ID | Task | Files / actions | Status |
|----|------|-----------------|--------|
| `HA-001` | Introduce `TripPosition` / expose `lastPosition` as watchable state (not a silent field) — update on every GPS tick | `active_trip_controller.dart`, `active_trip_state.dart` or new `trip_position_provider.dart` | ✅ |
| `HA-002` | Centralise `currentDistanceAlongRouteKm(position, corridorPolyline)` helper used by alerts + POIs | `alert_route_utils.dart` or `lib/core/utils/` | ✅ |
| `HA-003` | Lower / tune `distanceFilter` for active trip (e.g. 25–50 m) and document battery trade-off | `location_service.dart` | ✅ |
| `HA-004` | On trip restore (`ActiveTripRunning` from Hive), request a one-shot `currentPosition()` immediately so lists/alerts aren’t stuck until first stream event | `active_trip_controller.dart` | ✅ |
| `HA-005` | Unit tests: distance-along-route + “behind POI filtered out” pure helpers | `test/features/trip/` or `test/features/alerts/` | ✅ |

**Acceptance**
- [x] Widgets/providers can `ref.watch` live position and rebuild when GPS moves
- [x] After kill+reopen mid-trip, an immediate fix is requested alongside the stream
- [x] Helper is the single projection algorithm (station + alert duplicate removed)

---

## Batch A1 — Android foreground service (trip active) 🟡

**Theme:** Keep location + Dart work alive when screen is off or another app is open.

**Priority:** P0 · **Effort:** 1–1.5 days · **Deps:** A0

| ID | Task | Files / actions | Status |
|----|------|-----------------|--------|
| `HA-010` | Wire Geolocator `AndroidSettings` + `foregroundNotificationConfig` (“Trip active — JourneyPlus is watching your corridor”) while trip is running | `location_service.dart` | ✅ |
| `HA-011` | Start FGS session on `startTrip` / resume / Hive restore; stop on pause / end | `active_trip_controller.dart` | ✅ |
| `HA-012` | Verify manifest: `FOREGROUND_SERVICE`, `FOREGROUND_SERVICE_LOCATION`, and any plugin-required `<service>` entries | `AndroidManifest.xml` | ✅ |
| `HA-013` | Notification channel for FGS distinct from alert channel | Geolocator `geolocator_channel_01`, label “JourneyPlus trip tracking” | ✅ |
| `HA-014` | Manual: Pixel/Samsung — lock screen 5 min with trip running; confirm FGS notif stays and GPS ticks continue | Device QA note in A7 | 🟡 Emulator startup passed; physical Android unavailable |

**Acceptance**
- [x] Persistent tracking notification configured while trip running (visibility pending `HA-014`)
- [x] Tracking subscription/FGS stops when trip paused/ended (lifecycle test)
- [ ] GPS ticks continue with screen off (log/`TripPosition` updates)

---

## Batch A2 — iOS background location (trip active) 🟡

**Theme:** Same promise on iPhone — location updates while locked / in Maps.

**Priority:** P0 · **Effort:** 1–1.5 days · **Deps:** A0

| ID | Task | Files / actions | Status |
|----|------|-----------------|--------|
| `HA-020` | Set `UIBackgroundModes` → `location` (and only what we need) | `ios/Runner/Info.plist` | ✅ |
| `HA-021` | Update location usage strings to trip-corridor purpose (not only “EV charging”) | `Info.plist` | ✅ |
| `HA-022` | Use `AppleSettings` with `allowBackgroundLocationUpdates` / appropriate accuracy while trip running | `location_service.dart` | ✅ |
| `HA-023` | Permission UX: When-In-Use first; explain Always upgrade with plain-language Settings CTA | `start_trip_with_location.dart` | ✅ |
| `HA-024` | Manual: iPhone — lock + Maps foreground; confirm position + alerts still evaluate | Device QA in A7 | 🟡 Native build passed; connected iPhone requires Developer Mode |

**Acceptance**
- [x] Background modes declared and App Store purpose strings accurate
- [ ] With When-In-Use + trip active, updates continue while app is backgrounded (physical verification blocked)
- [x] Always permission path implemented if When-In-Use is insufficient when locked

---

## Batch A3 — Alert delivery on real devices 🔵

**Theme:** Evaluation + notification path matches the marketed “banner + tray while traveling”.

**Priority:** P0 · **Effort:** 1–1.5 days · **Deps:** A0, A1, A2

| ID | Task | Files / actions | Status |
|----|------|-----------------|--------|
| `HA-030` | Evaluate alerts on **every position tick** (debounced), keep 30s timer only as fallback | `alert_notifier_controller.dart` | ⬜ |
| `HA-031` | Share one `LocalNotificationService` instance from `main.dart` into Riverpod (stop creating a second uninitialised instance) | `main.dart`, `alerts_providers.dart` | ⬜ |
| `HA-032` | Wire notification tap → Trip tab / Alert History (payload with `alertType` / `tripId`) | `local_notification_service.dart`, shell routing | ⬜ |
| `HA-033` | Skip evaluation cleanly when trip paused; resume without duplicate storm (respect cooldown) | `alert_notifier_controller.dart` | ⬜ |
| `HA-034` | Telemetry: `alert_eval_ok`, `alert_eval_skipped_no_gps`, `alert_fired_background` (or equivalent) | `app_telemetry.dart` | ⬜ |
| `HA-035` | Expand unit tests for delivery gate (mute + cooldown + systemNotificationsEnabled) in production-shared helper | `test/features/alerts/` | ⬜ |

**Acceptance**
- [ ] With FGS/BG location on, locking phone still allows a tray alert when a rule fires
- [ ] Notification tap opens Trip / history
- [ ] Single notification plugin instance; no double-init races

---

## Batch A4 — Engine / history / fatigue correctness ⬜

**Theme:** Push engine confidence from ~85% → 100%; history matches user experience.

**Priority:** P1 · **Effort:** 0.5–1 day · **Deps:** A3 (can start after A0 if needed)

| ID | Task | Files / actions | Status |
|----|------|-----------------|--------|
| `HA-040` | Fatigue: fire on first evaluation **after** each 3h boundary (not only a 5-minute band) | `fatigue_rule.dart` | ⬜ |
| `HA-041` | `recordFiredAlert` appends every delivery (or stores occurrence list); cooldown re-fires appear in history | `active_trip_controller.dart`, `trip.dart` if schema add | ⬜ |
| `HA-042` | Ghat rule fixture test with real polyline near a `kGhatSections` centre | `test/features/alerts/` | ⬜ |
| `HA-043` | Document rule thresholds in one table (fuel 40 km, food 50 km, night 22–05, fatigue 3h, window 100 km) | `requirements.md` or `docs/context/glossary.md` | ⬜ |

**Acceptance**
- [ ] Fatigue cannot be skipped solely because the 30s poll missed minutes 180–185
- [ ] Second fuel alert after 20 min appears in history
- [ ] All alert scenario tests green

---

## Batch A5 — Live ahead-on-corridor lists ⬜

**Theme:** Marketed “only stops ahead of you” works in real time for fuel, chargers, food, and other corridor categories.

**Priority:** P0 (product) · **Effort:** 1–1.5 days · **Deps:** A0 (parallel-safe with A1–A4)

| ID | Task | Files / actions | Status |
|----|------|-----------------|--------|
| `HA-050` | `poiCategoryControllerProvider` **watches** live trip position (not one-shot `read` at create) and recomputes `currentPositionKm` | `pois_providers.dart` | ⬜ |
| `HA-051` | Harden ahead trim: `distanceAlongRouteKm > currentKm` with small hysteresis (e.g. 0.3 km) to avoid list flicker | `poi_category_controller.dart` | ⬜ |
| `HA-052` | Apply same live ahead filter to EV/station corridor lists used on Trip / Plan downstream during active trip | `route_station_service` consumers / trip POI panels | ⬜ |
| `HA-053` | Discover / emergency / hidden-gems: when trip running, prefer ahead-only ordering and hide clearly behind items | discovery controllers | ⬜ |
| `HA-054` | Source badge / empty state: keep “Ahead on your route”; if GPS missing show “Waiting for GPS to filter ahead stops” | POI UI | ⬜ |
| `HA-055` | Widget/unit tests: POI behind `currentKm` excluded; crosses threshold → appears/disappears correctly | `test/features/pois/` | ⬜ |

**Acceptance**
- [ ] During active trip, driving past a pump removes it from the fuel list without leaving/re-entering the screen
- [ ] Behind-corridor items never shown as “ahead” when GPS is fresh
- [ ] Without GPS, UI explains degraded mode (full corridor or waiting) — no silent wrong list

---

## Batch A6 — Permissions & silent-failure UX ⬜

**Theme:** Foreground delivery polish; never fail silently when marketed features can’t run.

**Priority:** P1 · **Effort:** 0.5–1 day · **Deps:** A3

| ID | Task | Files / actions | Status |
|----|------|-----------------|--------|
| `HA-060` | Trip start: actionable sheets for location denied / notifications denied (`Open settings`) | trip start / settings | ⬜ |
| `HA-061` | In-trip banner when `TripPosition` is stale (>N seconds) — “Location paused — alerts & ahead lists may be outdated” | trip / alerts banner | ⬜ |
| `HA-062` | Optional Android OEM battery tip (Xiaomi/Oppo/Vivo) link in Settings → Alerts help | `settings` feature | ⬜ |
| `HA-063` | Settings copy: explain that trip tracking notification is required for background alerts | settings / trip | ⬜ |

**Acceptance**
- [ ] Denied permissions never look like “app is fine but quiet”
- [ ] Stale GPS surfaces a visible degraded state

---

## Batch A7 — Device QA & marketing claim sign-off ⬜

**Theme:** Prove real devices match what we feature; soft-copy if a platform can’t meet Always/background.

**Priority:** P0 (gate to “ready”) · **Effort:** 1 day · **Deps:** A0–A6 (min A0–A3 + A5)

| ID | Task | Files / actions | Status |
|----|------|-----------------|--------|
| `HA-070` | Device matrix: Pixel, Samsung, one Xiaomi/Oppo if available, one iPhone | checklist below | ⬜ |
| `HA-071` | Scripted drive or GPS mock: fuel-low / ahead-list trim / lock screen alert | — | ⬜ |
| `HA-072` | `flutter analyze` + `flutter test` (alerts + pois + location) green | CI / local | ⬜ |
| `HA-073` | Update `docs/context/current_state.md` + `progress_log.md` | docs | ⬜ |
| `HA-074` | Align `docs/presentation/SMART_FEATURES.md` with verified behaviour (no oversell) | SMART_FEATURES.md | ⬜ |
| `HA-075` | Privacy policy / Play Data safety: background location purpose text if Always used | `docs/legal/`, Play Console | ⬜ |

### Device checklist (sign-off)

- [ ] **Android:** Trip running → lock 5 min → tray alert still possible
- [ ] **Android:** Trip running → open Google Maps 5 min → tray alert still possible
- [ ] **Android:** Pause trip → tracking FGS stops; no further alerts
- [ ] **iOS:** Trip running → background/lock → alert or documented Always requirement
- [ ] **Both:** Ahead fuel/EV list drops stops after you pass them (live)
- [ ] **Both:** Notification tap → Trip / Alert History
- [ ] **Both:** Mute + system-notification toggle respected
- [ ] **Both:** Kill app → reopen → trip + tracking resume (Hive restore)

**Acceptance**
- [ ] All applicable checklist boxes ticked for at least one Android + one iOS device
- [ ] Marketing copy matches signed-off behaviour

---

## Suggested calendar (solo)

| Day | Batch |
|-----|--------|
| 1 | A0 + start A1 |
| 2 | Finish A1 + A2 |
| 3 | A3 |
| 4 | A4 + A5 |
| 5 | A6 + A7 device QA |

**Two-track split:** Track 1 = A0→A1→A2→A3→A4 · Track 2 (after A0) = A5→A6 · Merge at A7.

---

## Out of scope (explicit)

| ID | Item | Defer to |
|----|------|----------|
| — | FCM / server push corridor alerts | Not planned (wrong architecture) |
| — | Re-engagement notifications | `P4-032` |
| — | Voice spoken alerts | `P3-033` |
| — | CarPlay | `P4-010` |

---

*Created: 2026-07-18 · Next up: **Batch A0** (`HA-001`…).*
