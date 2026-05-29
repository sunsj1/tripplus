# Phase 1 — End-to-end verification checklist (Session 11)

> Run on a **real device or emulator** after `firebase_options.dart`, `.env`, and
> `android/gradle.properties` are configured. Check each box when verified.
>
> **Automated gate (CI / agent):** `flutter analyze` + `flutter test` must pass.

---

## Setup preflight

- [ ] `.env` has `GOOGLE_MAPS_API_KEY` and `OPEN_CHARGE_MAP_API_KEY`
- [ ] `android/gradle.properties` has the same Maps key (Android map tiles)
- [ ] `lib/firebase_options.dart` has real values (not `REPLACE_…`)
- [ ] `android/app/google-services.json` and `ios/Runner/GoogleService-Info.plist` present
- [ ] Firebase: Google Sign-In enabled, Firestore created
- [ ] GCP: Maps billing on, Directions / Geocoding / Places / Maps SDK enabled

---

## Auth & shell

- [ ] App launches without crash
- [ ] Google Sign-In completes
- [ ] Profile / vehicle setup gate works
- [ ] Four tabs visible: **Plan · Trip · Discover · Profile**
- [ ] Offline banner appears when airplane mode on (optional)

---

## Plan (all vehicle types)

For each: **Petrol**, **Diesel**, **EV**, **Bike**

- [ ] Plan route (e.g. Pune → Nashik)
- [ ] `PlanResult` shows stat cards (ETA, tolls, fuel/charging, traffic)
- [ ] Smart Trip Timeline renders
- [ ] **Start trip** → Trip tab shows ready state

---

## Discover (route-aware POIs)

After a plan exists, open **Discover** and tap each category:

- [ ] Fuel
- [ ] Restaurant
- [ ] Washroom
- [ ] ATM
- [ ] Hotel
- [ ] Mechanic

Each should show route-aware results (or clear empty state). List ⇄ map toggle works.

---

## Community

- [ ] Station detail: community section loads
- [ ] POI detail sheet: `PoiCommunityRatingPulse` / reports section visible
- [ ] Submit pulse on a **POI** (non-station); reads back via `targetKey`

---

## Trip & alerts

- [ ] Start trip from Trip tab
- [ ] Pause / resume / end trip
- [ ] While trip **running**: predictive alert banner may appear (needs location + corridor POIs)
- [ ] Local notification permission granted; notification fires for new alert type
- [ ] **Alert history** opens from Trip tab and lists fired alerts

---

## Legacy EV (no regression)

- [ ] Stations / charging flow still reachable if still in nav or deep-linked
- [ ] Station list + detail + community on station

---

## Sign-off

| Verified by | Date | Device | Notes |
|-------------|------|--------|-------|
| | | | |

When all boxes are checked, mark Phase 1 complete and tag: `phase-1-mvp-complete`.
