# Hotline fixes — batch plan

> **Goal:** Fix critical route-planning accuracy issues (wrong fuel cost, wrong tolls, wrong single-route assumption) and ship a Google Maps–style **multi-route picker** — without redesigning the existing Plan / Trip / Discover shell.
>
> **How to use:** Complete **one batch at a time**. Mark batch status as you go. Run `flutter analyze` after each batch. Run `dart run build_runner build --delete-conflicting-outputs` only when Freezed models change.
>
> **UI rule:** Additive changes only — new sections/widgets above or beside existing `PlanResultView` content. Do **not** remove tabs, reorder the shell, or restyle unrelated screens.

---

## Status legend

| Symbol | Meaning |
|--------|---------|
| ✅ | Done |
| 🔵 | Next up |
| ⬜ | Not started |
| 🟡 | Partially done |

---

## Requirements map (what we're solving)

| # | Problem | Target behaviour |
|---|---------|------------------|
| R1 | Bike and car used the same fuel mileage | Vehicle-type defaults (bike ~50 km/l, car petrol/diesel separate); Car \| Bike picker on plan screen |
| R2 | Tolls shown on every route via ₹/km fallback | Real toll detection per route; **Yes / No only** in UI (no ₹ total) |
| R3 | Plan tab stuck on route details after ending trip | Reset `planController` to idle when trip ends |
| R4 | Only Google's fastest route is used | Show **2–3 alternatives** like Google Maps web; mark **Suggested** on best traffic-aware route |
| R5 | User on alternate highway sees wrong ETA/POIs/fuel | Selecting a route recomputes **all** downstream data for **that polyline only** |
| R6 | No visual route comparison | Optional map preview with multiple polylines (Phase B) |
| R7 | Release build blocked | Fix stale `GeneratedPluginRegistrant` / `flutter_native_splash` dev-dep issue |

---

## Already shipped (pre–Hotline fixes session)

| Item | Status | Notes |
|------|--------|-------|
| R1 — Vehicle-type fuel defaults + Car/Bike UI | ✅ | `vehicle.dart`, `trip_context_row.dart`, `plan_controller.dart` |
| R3 — Plan reset on trip end | ✅ | `plan_screen.dart` listens to `activeTripControllerProvider` |
| R2 — Google Routes toll API + corridor fallback | ✅ | Yes/No UI shipped in Batch 1 |
| R2 — Removed ₹1.5/km fallback | ✅ | `toll_estimator.dart` |

---

## Batch 0 — Release build unblock 🔵

**Theme:** Ship a clean release AAB before on-road testing.

| ID | Task | Files / actions |
|----|------|-----------------|
| H0-01 | Delete stale `android/app/src/main/java/io/flutter/plugins/GeneratedPluginRegistrant.java` if it references dev-only plugins | `android/app/src/main/java/...` |
| H0-02 | Run `flutter clean && flutter pub get` | — |
| H0-03 | Verify `flutter build appbundle --release` succeeds | `pubspec.yaml` version bump if needed |
| H0-04 | Confirm Maps key has **debug + upload + Play signing** SHA-1s in Google Cloud | Console (not code) |

**Acceptance**
- [ ] Release AAB builds with zero Java compile errors
- [ ] App launches on a physical device from internal testing track

**Estimated effort:** 1–2 hours

---

## Batch 1 — Toll UX: Yes / No only (no ₹ amounts) ✅

**Theme:** Match Google Maps toll *presence* display; stop showing fluctuating rupee totals.

| ID | Task | Files |
|----|------|-------|
| H1-01 | Add `hasTolls: bool?` to `PlanResult` (nullable = bike / unknown) | `plan_state.dart` → run build_runner |
| H1-02 | Replace toll ₹ logic in `PlanController` with `hasTolls` only; keep corridor/Google detection internally | `plan_controller.dart` |
| H1-03 | Update `_TripDashboardStatRow`: show **Tolls: Yes / No / —** instead of `~₹…` | `plan_result_view.dart` |
| H1-04 | Remove toll ₹ from trip share text and trip history stat grid (show Yes/No) | `trip_share_text.dart`, `trip_history_screen.dart`, `trip_tab_screen.dart` |
| H1-05 | Update `Trip` model: store `hasTolls` instead of (or alongside) `tollsEstimate` — prefer `hasTolls` for new trips | `trip.dart` → build_runner |
| H1-06 | Adjust `active_trip_controller.prepareTrip` to pass `hasTolls` | `active_trip_controller.dart` |

**Acceptance**
- [x] Mumbai → Pune shows **Tolls: Yes** on expressway route
- [x] Short intra-city route shows **Tolls: No** when Google reports none
- [x] Bike plan shows no toll stat (unchanged)
- [x] No ₹ toll amount visible anywhere in Plan or Trip tabs
- [x] Existing stat-card row layout unchanged (same cards, different toll value text)

**Estimated effort:** 0.5–1 day

---

## Batch 2 — Multi-route API foundation ✅

**Theme:** Fetch 2–3 driving alternatives with traffic-aware duration per route.

| ID | Task | Files |
|----|------|-------|
| H2-01 | Create `RouteOption` freezed model: `id`, `summary`, `distanceKm`, `durationMinutes`, `durationInTrafficMinutes`, `encodedPolyline`, `polylinePoints`, `hasTolls`, `isSuggested` | `lib/core/domain/route_option.dart` |
| H2-02 | Add `DirectionsService.getRouteAlternatives(origin, dest)` — prefer **Routes API v2** with `computeAlternativeRoutes: true` + `extraComputations: [TOLLS]` | `directions_service.dart` |
| H2-03 | Fallback: Directions API `alternatives=true` when Routes API fails | same file |
| H2-04 | Mark `isSuggested` on route with lowest `durationInTrafficMinutes` | service layer |
| H2-05 | Unit-test parsing with mocked JSON (at least 2 routes, suggested flag, toll flag) | `test/core/directions_service_test.dart` |

**Acceptance**
- [x] Service returns 2–3 `RouteOption` for Mumbai → Pune
- [x] Fastest traffic-aware route has `isSuggested: true`
- [x] Each option has independent polyline + km + minutes
- [x] Each option has `hasTolls` true/false

**Estimated effort:** 1–1.5 days

**Google Cloud:** Enable **Routes API** on the same project as Directions.

---

## Batch 3 — Plan state + route picker UI (non-breaking) ✅

**Theme:** Show route list **above** existing route details; user picks before deep analysis.

| ID | Task | Files |
|----|------|-------|
| H3-01 | Extend `PlanState.result` with `routeOptions: List<RouteOption>` + `selectedRouteIndex: int` | `plan_state.dart` |
| H3-02 | New intermediate state `PlanState.routeSelection` OR keep `calculating` → `result` with options first, details lazy-loaded | `plan_state.dart`, `plan_controller.dart` |
| H3-03 | Build `RouteOptionsList` widget — cards like Google web: summary, time (green if suggested), km, tolls Yes/No, **Suggested** chip | `lib/features/plan/presentation/widget/route_options_list.dart` |
| H3-04 | Insert list at top of plan flow **before** full `PlanResultView` dashboard (new screen or top section) | `plan_screen.dart` or new `route_selection_view.dart` |
| H3-05 | Tapping a route sets `selectedRouteIndex` and triggers detail load (Batch 4) | `plan_controller.dart` |
| H3-06 | Preserve existing `PlanResultView` layout for the detail section — only add route picker above it | `plan_result_view.dart` |

**Acceptance**
- [x] After Analyze, user sees route list first (not jumped straight to single-route dashboard)
- [x] Suggested route visually highlighted
- [x] Tapping any route selects it; previous selection deselects
- [x] Back from route list returns to plan input (existing `_onReset` behaviour)
- [x] No changes to bottom nav, Discover grid, or Profile screens

**Estimated effort:** 1.5–2 days

---

## Batch 4 — Per-route detail recalculation ✅

**Theme:** Fuel, ETA, traffic, weather, EV stations, POIs, timeline — all for **selected polyline only**.

| ID | Task | Files |
|----|------|-------|
| H4-01 | Refactor `RouteStationService.analyzeRoute` to accept optional pre-resolved `RouteInfo` / polyline (skip re-fetching directions) | `route_station_service.dart` |
| H4-02 | `PlanController.selectRoute(index)` — re-run analysis using selected `RouteOption` polyline | `plan_controller.dart` |
| H4-03 | Fuel cost uses selected route `distanceKm` + vehicle `effectiveFuelEfficiencyKmpl` | `plan_controller.dart` |
| H4-04 | Traffic level derived from **selected** route's duration ratio | same |
| H4-05 | `routeWeatherProvider` keyed on selected encoded polyline (already family — verify re-fetch on switch) | `weather_providers.dart` |
| H4-06 | `prepareTrip` / `CorridorCache` uses **selected** route polyline | `active_trip_controller.dart` |
| H4-07 | Discovery / POI / hidden-gems providers read active plan's **selected** polyline | `pois_providers.dart`, `hidden_gems_providers.dart`, `emergency_providers.dart` |
| H4-08 | Alert engine uses selected route when trip is prepared | `alert_notifier_controller.dart` |

**Acceptance**
- [x] Switching route changes km, ETA, fuel ₹, traffic label, weather strip
- [x] EV station list re-samples along new polyline
- [x] Starting trip caches the **selected** route, not always route #0
- [x] Discover tab POIs update after route switch (via updated `encodedRoutePolyline` on `PlanResult`)

**Estimated effort:** 1.5–2 days

---

## Batch 5 — Mid-drive route auto-match (smart default) ✅

**Theme:** If user opens app while already driving, pre-select the alternative closest to GPS.

| ID | Task | Files |
|----|------|-------|
| H5-01 | Add `RouteOptionMatcher.nearestToPosition(position, options)` using perpendicular distance to polylines | `lib/core/utils/route_option_matcher.dart` |
| H5-02 | On plan analyze (or trip resume), if GPS available, set `selectedRouteIndex` to best match instead of always `0` | `plan_controller.dart` |
| H5-03 | Show subtle label: **"Matched to your current road"** when auto-selected | `route_options_list.dart` |
| H5-04 | During active trip, optional: warn if GPS drifts >X km from selected polyline ("You may be on a different route — tap to switch") | `trip_tab_screen.dart` or alert rule |

**Acceptance**
- [x] Simulated GPS near NH-65 polyline pre-selects that route over expressway
- [x] User can still manually override selection

**Estimated effort:** 1 day

---

## Batch 6 — Map route preview (Phase B) ✅

**Theme:** Google Maps–style map with multiple polylines; tap line or label to select.

| ID | Task | Files |
|----|------|-------|
| H6-01 | New `RouteMapPreviewScreen` — `GoogleMap` + one `Polyline` per option | `lib/features/plan/presentation/view/route_map_preview_screen.dart` |
| H6-02 | Selected route: solid primary blue; others: faded grey (reuse `station_map_screen` patterns) | same |
| H6-03 | `LatLngBounds` camera fit to all routes on open | same |
| H6-04 | Tap polyline / floating time chip selects route and pops back to list | same |
| H6-05 | Entry point: **"Map"** text button on route selection screen (does not replace list UI) | `route_options_list.dart` |
| H6-06 | Placeholder when Maps key missing (same pattern as `StationMapScreen`) | same |

**Acceptance**
- [x] Map shows 2–3 routes simultaneously for Mumbai → Pune
- [x] Tapping a route highlights it and updates selection in list
- [x] Existing list-first UX remains default; map is optional drill-in

**Estimated effort:** 1–2 days (MVP) · +2 days for polished time labels on map

**Feasibility:** ✅ Fully possible with existing `google_maps_flutter` stack.

---

## Batch 7 — Fuel & vehicle polish ✅

**Theme:** Close remaining gaps from R1; optional profile override.

| ID | Task | Files |
|----|------|-------|
| H7-01 | Profile edit: optional "My mileage (km/l)" field for petrol/diesel/bike | `profile` feature |
| H7-02 | Show "Using default X km/l" hint on fuel stat when no custom value | `plan_result_view.dart` |
| H7-03 | Persist per-trip vehicle override through route switch + trip prepare | `plan_screen.dart`, `active_trip_controller.dart` |
| H7-04 | QA matrix: bike vs petrol car vs diesel car on same 150 km route — fuel ₹ must differ significantly | `test/core/vehicle_fuel_estimate_test.dart` |

**Acceptance**
- [x] Bike fuel estimate < car estimate on identical route/distance
- [x] Custom mileage in profile overrides defaults

**Estimated effort:** 0.5–1 day

---

## Batch 8 — End-to-end verification & docs ✅

**Theme:** Sign off Hotline fixes before production push.

| ID | Task | Files |
|----|------|-------|
| H8-01 | Manual test: Mumbai → Pune — 3 routes, different km/time/tolls Yes/No | this file checklist below |
| H8-02 | Manual test: end trip → Plan tab shows input screen (not route details) | — |
| H8-03 | `flutter analyze` clean | — |
| H8-04 | `flutter test` pass | — |
| H8-05 | Update `docs/context/current_state.md` — multi-route + toll Yes/No | `current_state.md` |
| H8-06 | Append session note to `docs/ai_context/progress_log.md` | progress log |
| H8-07 | Play Console: Routes API billing enabled; data safety unchanged | Console *(manual — verify before release)* |

### Device checklist *(manual sign-off before Play push)*

- [ ] **Plan input:** Car \| Bike + fuel type visible; no layout regression
- [ ] **Route list:** ≥2 alternatives; Suggested badge on fastest
- [ ] **Route switch:** km, ETA, fuel, traffic, tolls Yes/No all update
- [ ] **Tolls:** expressway = Yes; local city = No; no ₹ toll anywhere
- [ ] **Fuel:** bike ≪ car cost on same route
- [ ] **Trip end:** Plan tab resets to "Where to next?"
- [ ] **Map preview (if Batch 6 done):** polylines render; tap selects route
- [ ] **Release AAB:** installs from Play internal track

### Automated gates (Batch 8)

- [x] `flutter analyze` — clean
- [x] `flutter test` — 12/12 pass (includes `vehicle_fuel_estimate_test`)

**Estimated effort:** 0.5 day

---

## Suggested execution order

```
Batch 0 (release) → Batch 1 (toll Yes/No) → Batch 2 (API) → Batch 3 (UI list)
    → Batch 4 (per-route recompute) → Batch 5 (GPS match) → Batch 6 (map)
    → Batch 7 (fuel polish) → Batch 8 (verify)
```

**Minimum viable Hotline fix (skip map):** Batches **0 → 1 → 2 → 3 → 4 → 8** (~5–7 days)

**Full Google Maps parity:** Add Batches **5 + 6 + 7** (+3–5 days)

---

## Files touched (summary)

| Area | Primary files |
|------|----------------|
| Directions / routes | `directions_service.dart`, `route_option.dart` |
| Plan flow | `plan_controller.dart`, `plan_state.dart`, `plan_screen.dart`, `route_options_list.dart`, `plan_result_view.dart` |
| Toll | `toll_estimator.dart`, `plan_controller.dart` |
| Trip lifecycle | `plan_screen.dart`, `active_trip_controller.dart`, `trip.dart` |
| Map preview | `route_map_preview_screen.dart` |
| Downstream | `route_station_service.dart`, `pois_providers.dart`, `hidden_gems_providers.dart`, `alert_notifier_controller.dart` |
| Vehicle / fuel | `vehicle.dart`, `trip_context_row.dart`, profile screens |

---

## What we are **not** changing

- Bottom tab order (Plan · Trip · Discover · Profile)
- Community report schema (add fields only if ever needed — not in this scope)
- Discovery grid categories
- Sponsored / monetization surfaces
- Replacing Riverpod, Hive, or Firebase stack

---

*Created: 2026-06-24 · Track batch completion by changing ⬜ → ✅ in this file.*
