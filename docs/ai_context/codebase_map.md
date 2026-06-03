# Codebase quick-map

> File paths I (the AI) need to remember across sessions. Not exhaustive — only what I have to touch repeatedly.

## Entry points
- `lib/main.dart` — app bootstrap, Hive boxes, Firebase init.
- `pubspec.yaml` — deps + product description.
- `firebase/firestore.indexes.json` — composite indexes (extend for `targetKey + createdAt` in `P1-055`).

## Core
- `lib/core/services/` — `directions_service.dart`, `geocoding_service.dart`, `google_ev_station_service.dart`, `places_autocomplete_service.dart`, `route_station_service.dart` (EV-typed), **`route_poi_service.dart`** (`P1-009`), **`location_service.dart`** — `LocationService` + `locationServiceProvider`; `requestPermission()`, `currentPosition()`, `listenToPosition(cb)` returning `StreamSubscription` (`P1-042`), **`connectivity_service.dart`** — `connectivityStreamProvider` (`Stream<List<ConnectivityResult>>`), `isOnlineProvider` (`bool`, optimistic default true) (`P1-044`), **`local_notification_service.dart`** — trip alert channel + `showTripAlert()` (`P1-027`).
- `lib/core/utils/` — `location_helper.dart`, `polyline_decoder.dart`, `result.dart` (Freezed Result type), `station_merger.dart`, **`failure.dart`** — canonical `Failure` sealed class with 6 variants (`P1-007`/`P1-061`).
- `lib/core/theme/` — `app_theme.dart`, plus `AppColors` / `AppTextStyles`.
- `lib/core/constants/cache_constants.dart` — Hive box names (existing). Note: profile box name lives on `ProfileBox.boxName` (feature-internal).
- `lib/core/widgets/app_top_bar.dart` — global top bar; profile popup now has "Edit profile" (name/phone), **"Trip preferences"** (vehicle + prefs, `P1-033`), "Log out".
- `lib/core/domain/` — cross-feature domain models.
  - `vehicle.dart` — `VehicleType` enum + `Vehicle` freezed (created `P1-003`).
  - `user_preferences.dart` — `UserPreferences` + `BudgetTier` (created `P1-031`).
  - `poi.dart` — `Poi`, `PoiCategory` (16 items), `PoiSource` (created `P1-006`).

## Features (today)
- `auth/` `data domain presentation` — `AuthGate` routes signed-in users through `VehicleSetupGate` before AppShell (`P1-032`).
- `onboarding/`
- `shell/presentation/view/app_shell.dart` — four tabs: **Plan · Trip · Discover · Profile** (`P1-016`). `Scaffold.body` is `Column([OfflineBanner(), Expanded(IndexedStack)])` so the offline banner appears on all tabs (`P1-044`). Old `InsightsScreen` + `StationsScreen` are orphan code (still compile, not in nav).
- `plan/presentation/` — `RouteInputCard` (now takes vehicle + preferences, `P1-005`), `TripContextRow` widget, `PlanController`, `PlanState`, `PlanResultView`. `PlanScreen` holds per-trip override state for vehicle + preferences.
- `stations/presentation/` — list + map screens, station detail.
- `community/` `data domain presentation` — Firestore-backed pulses; offline queue; widgets `CommunityReportsSection`, `CommunityRatingPulse`. **Still uses `Either<String, T>` prefix strings** — not migrated to typed `Failure` yet.
  - `domain/community_target_type.dart` — `CommunityTargetType { station, poi }` (`P1-010`).
  - `domain/models/station_community_report.dart` — gained `targetType` + `targetKey` + derived `effectiveTargetKey` (`P1-010`, back-compat with old `stationKey` docs).
  - `data/dto/station_community_report_dto.dart` — read/write the new fields; station writes mirror `stationKey` into `targetKey` so the `P1-051` query-by-targetKey path serves both target types.
  - `data/repository/community_report_repository.dart` — `watchStationReports(stationKey)` (legacy) + **`watchByTargetKey(targetKey)`** (`P1-051`).
  - `presentation/controller/station_community_controller.dart` — internal field renamed to `_targetKey`; new optional `queryByTargetKey` constructor flag toggles which stream to subscribe to.
  - `presentation/controller/community_providers.dart` — `stationCommunityControllerProvider` (legacy) + **`poiCommunityControllerProvider`** family keyed by `targetKey` (`P1-052`).
  - `presentation/widgets/poi_community_rating_pulse.dart` — POI counterpart of `CommunityRatingPulse` (`P1-054`).
  - `presentation/widgets/poi_community_reports_section.dart` — POI reports + real submit CTA (`showPoiReportSheet`) + conflict timeline when reports disagree (`P1-053`, `P2-031`).
  - `presentation/widgets/poi_report_sheet.dart` — lightweight POI pulse sheet (star + comment), submits as `targetType: poi`.
  - `presentation/widgets/community_conflict_timeline.dart` — vertical newest-first timeline shown on conflict (`P2-031`).
  - `domain/community_condition.dart` — `conditionQuality()` + `isNegative/PositiveCondition()` handling EV + POI vocab (`P2-030`).
  - `domain/trust_level.dart` — `TrustLevel` enum + `fromScore()` (`P2-030`).
  - `domain/models/station_community_ui_state.dart` — `reliabilityScore`, `hasConflictInRecent`, `trustLevel` (generalized for all POIs) (`P2-030`).
- `core/widgets/source_badge.dart` — reusable colour-coded `SourceBadge(source, compact)` (`P2-032`).
- `firebase/firestore.indexes.json` — composite indexes for `stationKey + createdAt desc` AND `targetKey + createdAt desc` (`P1-055`). Run `firebase deploy --only firestore:indexes` after editing.
- `charging/`
- `insights/`
- `alerts/`
  - `domain/alert.dart` — `Alert`, `AlertType` (Phase 1+2 values), `AlertSeverity` (`P1-022`).
  - `domain/alert_engine.dart` — pure-Dart evaluator; **P2-001** pre-filters `upcomingPois` to `upcomingWindowKm` (100 km) ahead before rules run; dedupes by type (`P1-023`, `P2-001`).
  - `domain/alert_engine_input.dart` — `(route, location, vehicle, prefs, upcomingPois, upcomingWindowKm)` (`P1-023`, `P2-001`).
  - `domain/alert_route_utils.dart` — polyline projection + gap helpers; **`poisInWindow(pois, currentKm, windowKm)`** (`P1-023`, `P2-001`).
  - `domain/rules/` — `fuel_low_rule.dart` (`P1-024`), `ev_gap_rule.dart` (`P1-025`), `food_window_rule.dart` (`P1-026`), **`ghat_rule.dart`** (`P2-002`), **`night_rule.dart`** (`P2-003`), **`fatigue_rule.dart`** (`P2-004`), **`weather_rule.dart`** (`P2-005`). Rules see pre-windowed POIs + pre-fetched weather — no per-rule window logic needed.
- `weather/` (P2 Session 6)
  - `domain/route_weather_segment.dart` — plain Dart `RouteWeatherSegment` (label, distanceAlongRouteKm, temperatureC, weatherCode, precipitationMm, windKph) + `conditionLabel` / `isDrivingHazard` getters (`P2-040`).
  - `data/open_meteo_weather_service.dart` — `OpenMeteoWeatherService.sampleAlongRoute()`, free no-key endpoint, up to 4 samples (`P2-040`).
  - `presentation/controller/weather_providers.dart` — `openMeteoWeatherServiceProvider`, `routeWeatherProvider = FutureProvider.autoDispose.family<…, PlanResult>` (`P2-040`).
  - `presentation/widget/route_weather_strip.dart` — horizontal weather cards mounted on `PlanResultView` (`P2-040`).
  - `domain/ghat_dataset.dart` — `GhatSection` + `kGhatSections` (14 curated Indian ghats) (`P2-002`).
  - `presentation/controller/alerts_providers.dart` — `alertEngineProvider`, `localNotificationServiceProvider`, `alertNotifierProvider` (`P1-028`).
  - `presentation/controller/alert_notifier_controller.dart` — polls every 30s while trip active; **P2-006** per-type 20-min cooldown via `_lastFiredAt` map (replaces permanent dedup) (`P1-028`, `P2-006`).
  - `domain/alert_notifier_state.dart` — `activeBanner`, `bannerDismissed` (`P1-028`).
  - `presentation/widget/trip_alert_banner.dart` — **P2-007** severity-tiered: critical=manual×, warning=auto 8s, info=slim pill auto 5s (`P1-028`, `P2-007`).
  - `presentation/view/alert_history_screen.dart` — per-trip fired alert log (`P1-034`).
  - `presentation/view/gap_alert_screen.dart` — legacy EV gap UI (orphan).
- `lib/core/telemetry/app_telemetry.dart` — structured logs for trip + alert + POI flows (`P1-060`).
- `lib/core/widgets/poi_list_skeleton.dart` — shared POI loading placeholders (`P1-062`).
- `lib/core/services/local_notification_service.dart` — `FlutterLocalNotificationsPlugin` wrapper; init in `main.dart` (`P1-027`).
- `profile/` — created in `P1-004`.
  - `domain/profile_data.dart` — `ProfileData { vehicle?, preferences }`.
  - `data/local_db/profile_box.dart` — Hive box (`user_profile`); opened in `main.dart`.
  - `data/repository/profile_repository.dart` — `readLocal`, `hydrateFromFirestore`, `save` returning `Either<Failure, _>`.
  - `presentation/controller/` — `profile_providers.dart`, `profile_controller.dart`, `profile_ui_state.dart` (`ProfileIdle/Saving/Errored`).
  - `presentation/view/` — `vehicle_setup_gate.dart`, `profile_setup_screen.dart`, `profile_edit_screen.dart`, `profile_tab_screen.dart` (`P1-016` tab).
  - `presentation/widget/` — `vehicle_picker.dart`, `preferences_chips.dart`.
- `pois/`
  - `data/repository/poi_repository.dart` — abstract `PoiRepository` interface (uses `LatLng` from `polyline_decoder.dart`).
  - `data/repository/google_places_poi_source.dart` — concrete impl using Google Places Nearby Search + Place Details (`P1-008`). 15 categories supported; EV refused (delegated).
  - `domain/community_poi_key.dart` — `communityPoiKey(Poi)` → `poi_<sanitized id>` (`P1-010`).
  - `presentation/controller/pois_providers.dart` — `poiRepositoryProvider` bound to `GooglePlacesPoiSource`; `routePoiServiceProvider`; `poiCategoryControllerProvider.family.autoDispose<PoiCategory>`. Computes `currentPositionKm` from active trip + corridor cache for ahead-filtering (`P1-012`, `P2`).
  - `presentation/controller/poi_category_ui_state.dart` — Freezed sealed `PoiCategoryUiState { loading, data(+currentPositionKm), empty, errored }`, with `PoiQuerySource { alongRoute, nearby, aheadOnRoute }` (each has `label` + `icon`) (`P1-012`, `P2`).
- `personalization/` (P2 Sessions 3 + 5)
  - `domain/user_preference_vector.dart` — `UserPreferenceVector.fromPreferences()` maps toggles → ranking weights (`P2-010`).
  - `domain/poi_ranker.dart` — pure `PoiRanker.rank()/score()`; quality + proximity + openness + preference signals (`P2-011`).
  - `domain/route_mode.dart` — `RouteMode { off, family, womenSafe, bike }` + `label/icon/accent/focusedCategories/attributeKeys` (`P2-020/021/022`).
  - `domain/mode_filter.dart` — `applyRouteModeFilter(pois, mode)` — strict-attribute first, category fallback (`P2-020/021/022`).
  - `presentation/controller/personalization_providers.dart` — `userPreferenceVectorProvider`, `poiRankerProvider` (`P2-012`).
  - `presentation/controller/route_mode_provider.dart` — `routeModeProvider` (StateProvider, default `off`) (`P2-020/021/022`).
  - `presentation/widget/route_mode_bar.dart` — horizontal mode chip strip mounted above POI lists (`P2-020/021/022`).
  - `presentation/widget/mode_badges.dart` — `PoiModeBadges` watches community state per POI to surface qualifying badges (`P2-020/021`).
- `community/` (P2-023 + P2-043 additions)
  - `domain/community_tag_aggregation.dart` — `CommunityTagAggregation.from(reports)` + `qualifiesFamily/WomenSafe/Hygienic` (≥ 2 answers, ≥ 50% yes) (`P2-023`).
  - `domain/road_condition_aggregation.dart` — `RoadConditionAggregation.from(reports)` + `dominantCondition` (construction ≥ 30%, else rough/good ≥ 50%) + `hasAdvisory` + `advisoryLabel` (`P2-043`).
  - `domain/models/station_community_submit_input.dart` + `station_community_report.dart` — nullable `babyFriendly/womenSafe/hygienic` (`P2-023`) + `roadCondition` (`P2-043`).
  - `data/dto/station_community_report_dto.dart` — read missing → null; write non-null only (`P2-023`, `P2-043`).
  - `presentation/widgets/poi_report_sheet.dart` — tri-state tag rows (`P2-023`) + single-select road-condition chips (`P2-043`).
  - `presentation/widgets/road_condition_chip.dart` — `RoadConditionChip` rendered on POI tiles when an advisory exists (`P2-043`).
- `tolls/` (P2 Session 7)
  - `domain/toll_corridor.dart` — `TollCorridor` + `kTollCorridors` static dataset of 7 major Indian expressways (`P2-042`).
  - `domain/toll_estimator.dart` — `TollEstimator.estimate(polyline, distance)` returns `TollEstimate(totalRupees, matchedCorridor, isCorridorMatch)` (`P2-042`).
- `settings/` (P2 Session 8)
  - `domain/app_settings.dart` — Freezed+JSON `AppSettings { distanceUnit, alertsEnabled, mutedAlertTypes, systemNotificationsEnabled }`; `isMuted(AlertType)` / `toggleMute()` extensions (`P2-053`).
  - `data/local_db/settings_box.dart` — Hive `app_settings` box (one JSON doc) (`P2-053`).
  - `presentation/controller/settings_controller.dart` — `SettingsController` + `settingsControllerProvider`. Reads from Hive on construction, persists on every change (`P2-053`).
  - `presentation/view/settings_screen.dart` — units segmented control + master alerts switch + system notifications switch + per-`AlertType` mute list. Mounted via Settings menu tile in `ProfileTabScreen` (`P2-053`).
- `trip/presentation/controller/trip_replan_provider.dart` — `TripReplanRequest(from, to)` + `tripReplanRequestProvider` (StateProvider, nullable). Plan screen consume-and-clears in `build` (`P2-051`).
- `trip/domain/trip_share_text.dart` — pure `buildTripShareText(trip)` → emoji-prefixed summary + Google Maps URL (`P2-052`).
- `trip/presentation/utils/share_trip.dart` — `shareTrip(context, trip)` wrapper around `SharePlus.instance.share(...)` (`P2-052`).
- `personalization/data/brand_affinity_box.dart` — Hive `brand_affinity` box (JSON-encoded `Map<wireValue, double>`) (`P2-013`).
- `personalization/presentation/controller/brand_affinity_controller.dart` — `BrandAffinityController` + `brandAffinityControllerProvider`. `registerInteraction({poi, signal: 'view'|'pulse'})` (`P2-013`).
- `personalization/presentation/controller/personalization_providers.dart` — `userPreferenceVectorProvider` now merges normalised learned brand weights into explicit selections (`P2-013`).
- `hidden_gems/` (P2 Session 10)
  - `domain/hidden_gem.dart` — `HiddenGem`, `HiddenGemCorridor`, `HiddenGemCategory { food, scenic, specialty, other }`, `HiddenGemTag { food, scenic, specialty, underrated }` (`P2-060`, `P2-062`).
  - `data/hidden_gem_dataset.dart` — `HiddenGemDataset.load()` reads `assets/hidden_gems/corridor_gems.json` via `rootBundle`, cached (`P2-060`).
  - `presentation/controller/hidden_gems_providers.dart` — `hiddenGemCorridorsProvider` (full dataset) + `activeCorridorGemsProvider` (corridor match for the active plan via the same waypoint-hit heuristic as `TollEstimator`) (`P2-061`).
  - `presentation/widget/hidden_gems_carousel.dart` — horizontal cards mounted on `DiscoveryScreen` between Emergency tile and the grid. Hides itself when no plan or no match (`P2-061`).
- `assets/hidden_gems/corridor_gems.json` — bundled curation (4 corridors, 10 gems) (`P2-060`).
- `personalization/domain/ranking_explanation.dart` — `RankingReason`/`RankingReasonKind`/`RankingExplanation` (`P2-033`).
- `personalization/domain/poi_ranker.dart` — `explain()` added; `score()` and `explain()` share private `_evaluate()` (`P2-033`).
- `personalization/presentation/widget/ranking_why_panel.dart` — "Why we recommend this" card mounted on `PoiDetailSheet` (`P2-033`).
- `core/services/observability_service.dart` — `ObservabilityService` wrapping Crashlytics (`bindUser`, `setVehicleType`, `setRouteMode`, `setActiveTrip`, `recordEvent`) (`P2-071`).
- `core/services/observability_providers.dart` — `observabilityServiceProvider` + `observabilityWiringProvider` (listeners attach in `AppShell`) (`P2-071`).
- `community/data/repository/community_report_repository.dart` — `watchStationReports` and `watchByTargetKey` now `.orderBy('createdAt', descending: true).limit(50)` server-side (`P2-072`).
- `pois/presentation/widget/poi_marker_clustering.dart` — `PoiMarkerClustering.build()` — zoom-based grid clustering, count badges drawn via `PictureRecorder` and cached by count (`P2-074`).
- `pois/presentation/widget/poi_category_map_view.dart` — `_zoom` + `_onCameraIdle` rebuilds the marker set when zoom crosses the cluster threshold; `_MapButton` accepts a `label` for `Tooltip`+`Semantics` (`P2-074`, `P2-070`).
- `core/widgets/poi_photo.dart` — `CachedNetworkImage` for tile thumb, gallery, fullscreen viewer; tile uses `memCacheWidth/Height` scaled to device pixel ratio (`P2-073`).
- `core/widgets/app_bottom_nav.dart` — tab `Semantics(button, selected, label)` (`P2-070`).
- `personalization/presentation/widget/route_mode_bar.dart` — mode chip semantics (`P2-070`).
  - `presentation/controller/poi_category_controller.dart` — decides between route-aware and nearby strategies based on `PlanController` snapshot at construction; EV without a plan → explicit empty state.
  - `presentation/view/poi_category_screen.dart` — reusable category screen with list/map toggle in app bar (`P1-012` + `P1-015`).
  - `presentation/widget/poi_list_tile.dart` — list tile; `pulseSlot` now filled by `PoiCommunityRatingPulse` (`P1-054`).
  - `presentation/widget/poi_category_map_view.dart` — Google Maps view with POI markers; same pattern as `station_map_screen.dart`.
  - `presentation/widget/poi_detail_sheet.dart` — `showPoiDetailSheet(context, poi)` modal that embeds `PoiCommunityReportsSection` (`P1-053`).
- `discovery/`
  - `presentation/view/discovery_screen.dart` — Smart Intelligence Grid (3 × ~6 of 16 categories). Tile tap pushes `PoiCategoryScreen` (`P1-011` + `P1-013`). Reachable via the Discover tab in `AppShell` (`P1-016`).

- `trip/`
  - `data/local_db/trip_box.dart` — Hive `active_trip` box; JSON-encoded single `Trip` under key `current`. API: `read()`, `save(trip)`, `clear()` (`P1-040`).
  - `domain/models/trip.dart` — `Trip` Freezed + json_serializable. Fields include lifecycle timestamps + `firedAlerts` list (`P1-028`/`P1-034`). Derived: `isTracking`, `elapsed` (`P1-040`).
  - `domain/models/trip_status.dart` — `TripStatus { notStarted, active, paused, completed }` (`P1-040`).
  - `presentation/controller/active_trip_state.dart` — Freezed sealed `ActiveTripState { idle, ready(trip), running(trip), paused(trip), completed(trip) }`. Extension `ActiveTripStateX.trip` extracts trip from any sub-state (`P1-041`).
  - `presentation/controller/active_trip_controller.dart` — `StateNotifier<ActiveTripState>`. Entry point: `prepareTrip(plan, vehicle)`. Transitions: `startTrip` / `pauseTrip` / `resumeTrip` / `endTrip` / `dismissCompleted`. All Hive-persisted. Accepts `LocationService`; starts/stops `StreamSubscription<Position>` on trip state changes; builds `CorridorCache` on `prepareTrip` (`P1-041`, `P1-042`, `P1-043`).
  - `presentation/controller/trip_providers.dart` — `activeTripControllerProvider` (NOT autoDispose); injects `locationServiceProvider` (`P1-041`, `P1-042`).
  - `domain/models/corridor_cache.dart` — plain Dart; `tripId`, `encodedPolyline`, `stationIds`, `totalDistanceKm`, `cachedAt`, `isStale`, `toJson`/`fromJson` (`P1-043`).
  - `data/local_db/corridor_cache_box.dart` — Hive `corridor_cache` box; `read()`, `save()`, `clear()`, `evictIfStale()` (`P1-043`).
  - `presentation/view/trip_tab_screen.dart` — `TripTabScreen(onPlanTrip)`. Switches on state: idle→CTA, ready→confirm+Start, running/paused→live dashboard with elapsed ticker, completed→summary. Pause/Resume/End trip buttons. End trip shows confirmation dialog (`P1-017`).

## Hive boxes already open in `main.dart`
- `CacheConstants.chargingBoxName` — existing.
- `CommunitySubmitQueue.boxName` (`community_submit_queue`) — existing.
- `ProfileBox.boxName` (`user_profile`) — `P1-004`.
- `TripBox.boxName` (`active_trip`) — `P1-040`.
- `CorridorCacheBox.boxName` (`corridor_cache`) — `P1-043`.
- `SettingsBox.boxName` (`app_settings`) — `P2-053`.
- `BrandAffinityBox.boxName` (`brand_affinity`) — `P2-013`.

## Build-runner
After ANY change to a `*.freezed.dart` source class, run:

```
dart run build_runner build --delete-conflicting-outputs
```
