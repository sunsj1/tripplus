# Wave 2 — Requirements map

Canonical “what we marketed” vs “what code does today” for live travel reliability.

---

## Product promises (must become true)

| ID | Promise (marketing / SMART_FEATURES / DoD) | Today |
|----|--------------------------------------------|-------|
| R1 | Predictive alerts while trip is active | Engine OK; delivery only while app process is awake |
| R2 | In-app banner **+** OS tray notification | Local notif works if `_evaluateNow` runs |
| R3 | Alerts fire with app in **background** / phone locked | ❌ Timer + GPS suspend; no FGS / iOS BG modes |
| R4 | Alerts fire when user is in **Maps** / another app | ❌ Same as R3 |
| R5 | 100 km lookahead, 20 min cooldown, mute prefs | ✅ Engine + settings |
| R6 | Per-trip alert history matches what fired | ✅ Every delivery appended (HA-041) |
| R7 | Fatigue every ~3h continuous driving | ✅ Eligible after each 3h boundary; cooldown collapses spam (HA-040) |
| R8 | Tap notification opens useful trip context | ✅ Deep link → Trip tab + Alert History (HA-032) |
| R9 | During trip, corridor lists show **only ahead** stops (fuel, EV, food, …) | 🟡 Filter exists but GPS/`lastPosition` not live-reactive; dies in background |
| R10 | Ahead lists update as the driver moves | ❌ Provider snapshots position once; `lastPosition` is not Riverpod state |
| R11 | Clear UX when location / notification permission missing | 🟡 Permission requested; weak actionable CTAs |

---

## Architecture constraints (do not fight these)

1. **Corridor alerts stay on-device** — `AlertEngine` + `flutter_local_notifications`. No FCM for Wave 2.
2. **Stable trip identity** — Hive `active_trip` + corridor cache polyline remain source of truth for “along route”.
3. **Predictive, not reactive** — still look ahead on the selected polyline; GPS only answers “where am I on that polyline?”.
4. **Feature-slice imports** — background location helpers live in `lib/core/services/`; alerts/pois/trip consume public providers.

---

## Capability stack we must build

```
Trip Running
    │
    ├─► Background-capable location session (Android FGS + iOS BG location)
    │         │
    │         ▼
    │   Live PositionState (Riverpod)  ←── single source of truth
    │         │
    │         ├─► AlertNotifier: evaluate on tick (+ 30s fallback)
    │         │         └─► LocalNotification + Banner + History
    │         │
    │         └─► POI / station / discovery lists: trim to distanceAlongRouteKm > currentKm
    │
    └─► Permission + silent-failure CTAs (location, notifications, OEM battery)
```

---

## Done-when (Wave 2 exit)

- [ ] Trip running + phone locked ≥ 5 min → at least one synthetic/real alert still appears in tray (Android + iOS)
- [ ] Trip running + Google Maps in foreground → same
- [ ] Discover / POI category during active trip shows only stops ahead of live GPS; list re-trims as you move
- [x] Notification tap opens Trip / Alert History *(code — device verify in A7)*
- [x] Fatigue cannot be permanently skipped by missing a 5-minute window *(HA-040)*
- [x] Alert history contains every delivered firing (cooldown re-fires included) *(HA-041)*
- [ ] `flutter analyze` clean; alert + location unit tests green
- [ ] SMART_FEATURES / store copy matches actual behaviour (or copy softened if iOS Always denied)

---

## Explicit non-goals

| Item | Why |
|------|-----|
| FCM token / Cloud Functions for corridor alerts | Wrong tool; on-device geometry is authoritative |
| Always-on tracking when trip is idle/paused | Battery + Play/App Store policy |
| 100% alerts after user force-kills app on iOS | OS limitation; document as best-effort |
| Redesigning alert banner UI | Severity tiers already shipped (`P2-007`) |
