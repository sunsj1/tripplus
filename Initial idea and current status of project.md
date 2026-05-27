# TripPlus — Initial idea and current status

## What this project is

**TripPlus** is a Flutter application described in `pubspec.yaml` as an **EV Charging Station Assistant**. It helps drivers discover charging stations, plan routes with charging stops, and stay informed during a trip through insights and community-sourced station conditions.

The app targets **iOS**, **Android**, **Windows**, and uses a typical layered structure under `lib/features/` (auth, charging, stations, plan, insights, community, alerts, onboarding, shell).

## Initial idea (product vision)

- **Planning**: Help users plan journeys with EV charging in mind (`PlanScreen`, route input, plan results).
- **Stations**: Browse and inspect charging locations (`StationsScreen`, map, station detail).
- **Trip insights**: Surface navigation-oriented information during travel (`InsightsScreen`).
- **Charging session awareness**: Track or relate to charging context (`charging` feature, Hive local cache).
- **Trust in the network**: Community “pulse” reports on stations (ratings, amenities, photos, freshness) so drivers see not only *where* to charge but *how reliable* a stop feels right now.

Authentication uses **Firebase** (Auth, Firestore, Google Sign-In) with an **AuthGate** flow: onboarding when signed out, profile completion when needed, then the main **AppShell** with bottom navigation (Plan · Insights · Stations).

## Technical stack (high level)

| Area | Choice |
|------|--------|
| UI / framework | Flutter (Material), Dart SDK ^3.11 |
| State | Riverpod |
| Backend / identity | Firebase (Core, Auth, Firestore), Google Sign-In |
| HTTP | Dio |
| Local storage | Hive (charging cache, community submit queue) |
| Maps / location | Google Maps Flutter, Geolocator |
| Models | Freezed + JSON serialization, fpdart |
| Media | Image picker, image compression |

Environment secrets load from `.env` (not committed in typical setups).

## Where we are now (current progress)

### Implemented product surface

- **Onboarding and auth** gated before the main app.
- **Main shell** with three tabs: **Plan**, **Insights**, **Stations**.
- **Station detail** and map/list flows for discovering stops.
- **Community reporting** UI and data path: report sheet wizard, list/snippet views, ratings, steps for pulse/amenities/photo/review, controllers and repositories wired toward Firestore.
- **Offline-first community submit**: local **Hive** queue (`community_submit_queue`) so failed submits can retry when connectivity returns; queue initialized in `main.dart`.
- **Reliability-oriented UX** (documented in `RELIABILITY_PHASES.md`): confidence near ratings (sample size, freshness, low-confidence states), clearer error categories and actionable retry/settings messaging, station key normalization to reduce identity drift.

### Work in progress / active branch of development

From the current repository state, **community and reliability** are the most active areas: new or updated files include submit queue, telemetry hooks, DTOs and domain models for community reports, controllers/providers, and several presentation widgets (e.g. report sheet, pulse steps, list screen, plan/station integration touchpoints). The root `README.md` is still the default Flutter template and does not yet describe TripPlus-specific behavior.

### Roadmap note (internal doc)

`RELIABILITY_PHASES.md` splits work into **Phase 1** (described as implemented: confidence UI, error taxonomy, offline queue, station key hardening) and **Phase 2** (listed as “next” with items such as report quality scoring, conflict-aware timelines, charge-success signals, filters on an “all pulses” view, route/planning risk hints, and lightweight telemetry). Treat Phase 2 as planned or partially in flight depending on what is merged versus still local.

## Summary

| Item | Status |
|------|--------|
| Core app shell (Plan / Insights / Stations) | In place |
| Firebase auth + profile gate | In place |
| Stations + planning + insights features | In place at feature-folder level |
| Community pulses + submit pipeline + offline queue | Advanced; recent focus |
| Reliability UX phases | Phase 1 documented as done; Phase 2 documented as follow-on |
| Public README / marketing docs | Minimal (default Flutter README) |

**Bottom line:** TripPlus is a functional EV charging assistant app with auth, navigation shell, stations, planning, and insights. Current momentum is on **community station reports**, **offline-safe submission**, and **reliability-minded presentation** of community data, with a written roadmap for deeper trust and planning integration.

---

*This file was generated from the repository layout, `pubspec.yaml`, `lib/main.dart`, `RELIABILITY_PHASES.md`, and recent change areas. Update it as milestones ship.*
