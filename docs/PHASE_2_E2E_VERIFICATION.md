# Phase 2 — End-to-end verification checklist (Session 13)

> Run on a **real device or emulator** after `firebase_options.dart`, `.env`, and
> `android/gradle.properties` are configured. Check each box when verified.
>
> **Automated gates (CI / agent):**
> - `flutter analyze` — must be clean (zero issues)
> - `flutter test` — all suites green
> - `firebase deploy --only firestore:indexes` — composite indexes live

---

## Setup preflight

- [ ] All Phase 1 preflight items still pass (see [PHASE_1_E2E_VERIFICATION.md](PHASE_1_E2E_VERIFICATION.md))
- [ ] `flutter analyze` reports **no issues**
- [ ] `flutter test` passes
- [ ] Firebase Crashlytics gradle plugin applied (`android/app/build.gradle.kts`)
- [ ] Firestore composite indexes deployed (`stationKey+createdAt`, `targetKey+createdAt`)
- [ ] `assets/hidden_gems/corridor_gems.json` ships in the build (`pubspec.yaml` asset block)
- [ ] Hive boxes opened in `main.dart`: `app_settings`, `brand_affinity`, `corridor_cache`, `trip_history`

---

## Predictive alerts v2

- [ ] Start a real trip on a known route
- [ ] **Upcoming-window** (P2-001): alerts reference POIs ≤ 100 km ahead, not the full remaining route
- [ ] **Cooldown** (P2-006): same alert type does not re-fire within 20 min
- [ ] **Severity tiers** (P2-007):
  - [ ] Critical → red banner, manual dismiss only
  - [ ] Warning → amber banner, auto-dismiss after 8 s + "Dismisses in 8s" hint
  - [ ] Info → slim pill, auto-dismiss after 5 s
- [ ] **Ghat rule** (P2-002): drive a route through a known ghat (e.g. Bhor Ghat) → ghat alert fires before entering
- [ ] **Night rule** (P2-003): between 22:00–05:00 with a hotel/fuel within 45 km → night alert suggests it
- [ ] **Fatigue rule** (P2-004): after 3 h continuous driving → fatigue reminder fires (paused time excluded)
- [ ] **Weather rule** (P2-005): when route segment has rain/thunderstorm in `RouteWeatherSegment` → weather alert fires
- [ ] Alert history (Profile → trip detail) lists all fired alerts in chronological order

---

## Personalization & ranking

- [ ] POI category lists default to **Best match** sort with the ✨ chip
- [ ] Switching to Nearest / Top rated / Open now changes the order as expected
- [ ] Profile preference toggle (e.g. Pure veg) → re-open the Restaurants list → veg POIs are now boosted
- [ ] Open a fuel POI 3+ times → that brand's pumps move up on subsequent visits (P2-013)
- [ ] **Why we recommend this** card on the POI detail sheet shows up to 3 reasons (P2-033)
- [ ] Reasons make sense: high-rated places mention rating, near places mention km, open places say "Open now"

---

## Mode-aware filters

- [ ] `RouteModeBar` appears above each POI category list with chips: Standard / Family / Women-Safe / Bike
- [ ] **Family Mode**: list trims to family-friendly categories; the "X of Y" count reflects the filter
- [ ] **Women-Safe Mode**: list trims; women-safe community badge appears on qualifying tiles
- [ ] **Bike Mode**: list trims to mechanic / fuel / medical / parking / washroom / hotel / cafe
- [ ] Tap the active chip → mode clears, full list returns
- [ ] Mode-filtered empty state shows "Clear mode" CTA tinted to the mode's accent

---

## Trust v2 for all POIs

- [ ] Submit a POI pulse (star + comment + tag answers)
- [ ] POI condition value (`good/fair/poor`) renders with the correct tone (not "Charging looked good")
- [ ] When recent pulses disagree → `CommunityConflictTimeline` appears on detail sheet
- [ ] `SourceBadge` shows on POI tiles (Official / Community / Curated / Unverified) with correct colour

---

## Weather, traffic, tolls

- [ ] Plan a route → `RouteWeatherStrip` shows 3–4 segment cards (Origin · Midway · Destination)
- [ ] Each card shows temperature, condition label, wind (and precipitation when > 0)
- [ ] When live traffic differs from free-flow → trip overview ETA uses `duration_in_traffic` and the traffic chip changes severity
- [ ] Plan a Mumbai → Pune trip → toll estimate uses corridor dataset, not flat ₹1.5/km

---

## Trip lifecycle

- [ ] Trip history list (Profile → Trip history) shows all completed trips
- [ ] Tap a trip → detail screen with route, distance, duration, cost
- [ ] **Share trip** action on detail screen + completed-trip view → OS share sheet shows the formatted text + Google Maps URL
- [ ] **Plan again** on a past trip pre-fills the plan screen with the same from/to
- [ ] Settings screen (Profile → Settings) — units, vehicle, per-alert mutes are persisted across restart

---

## Hidden gems

- [ ] Plan a trip on a curated corridor (Mumbai-Pune Expressway, Yamuna Expressway, Bengaluru-Mysuru Expressway, or Samruddhi Mahamarg)
- [ ] `HiddenGemsCarousel` appears on Discover between Emergency tile and category grid
- [ ] Card tap → Google Maps opens with the gem's coordinates
- [ ] Plan an off-corridor trip → carousel hides itself

---

## Observability

- [ ] Trigger a non-fatal crash on a debug build → Crashlytics does **not** capture (collection disabled)
- [ ] On a release build, Crashlytics dashboard shows custom keys: `vehicle_type`, `route_mode`, `trip_active`
- [ ] Reports carry the signed-in user identifier (or `anonymous` when signed out)

---

## A11y & performance

- [ ] Bottom nav tabs announce correctly under VoiceOver / TalkBack ("Trip, tab, selected")
- [ ] Route-mode chips announce mode label + selected state
- [ ] Map control buttons (Recenter / Zoom in / Zoom out) have tooltips and semantic labels
- [ ] Scrolling a long POI list does not re-decode photos (cached after first paint)
- [ ] Map view at zoom < 12 shows cluster markers; zooming in expands to individual pins
- [ ] Tap a cluster → map zooms in to its centre

---

## Server-side query efficiency

- [ ] In Firestore console → request log → confirm community feed queries fetch ≤ 50 documents
- [ ] Indexes status (Firebase Console → Firestore → Indexes) shows both composite indexes **Enabled**
- [ ] Submitting a pulse appears live in both the station detail and the POI feed

---

## Regression — Phase 1 still works

- [ ] Auth flow + onboarding (Phase 1 unchanged)
- [ ] Plan + route analysis works
- [ ] Smart trip timeline still renders
- [ ] EV gap warnings still fire when applicable

---

## Sign-off

| Verified by | Date | Device | Notes |
|-------------|------|--------|-------|
| | | | |

When all boxes are checked, mark Phase 2 complete and tag: `phase-2-intelligence-complete`.

Generate the final report block in [`docs/PHASE_REPORTS.md`](PHASE_REPORTS.md) before opening the Phase 3 batches plan.
