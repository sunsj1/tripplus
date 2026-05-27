# TripPlus — AI Highway Companion for Indian Road Trips

> **TripPlus is not a maps app.** It's a travel-intelligence ecosystem for the journey, not just the route — an AI copilot that plans, predicts, and watches over every kilometer.

A driver enters origin + destination + vehicle + preferences, and gets a **trip control center** that:

1. Plans the route with full cost picture (fuel/charging, tolls, ETA, weather).
2. Surfaces a **Smart Intelligence Grid** of route-aware POIs across 16 categories (fuel, EV, restaurants, washrooms, ATMs, hotels, medical, scenic, temples, kids stops, mechanics, parking, cafes, tourist, police, pure-veg).
3. Fires **predictive distance-based alerts** before problems happen (fuel low, EV gap, food window, ghat ahead, fatigue, night).
4. Carries **community-sourced trust signals** on every recommendation (reliability score, freshness, conflict-aware timeline, source badges).
5. Lets the user **talk to the app** like a copilot (Phase 3).

---

## Six product principles (non-negotiable)

1. **Route-aware, not nearby.** Discovery is along the journey corridor, not radial.
2. **Predictive, not reactive.** Warn *before* fuel runs low, *before* the ghat begins, *before* fatigue sets in.
3. **Trustworthy under weak network.** Offline-first queues, cached corridors.
4. **Reduce travel anxiety.** Every UI choice is judged against "does this calm the driver?"
5. **India-first.** Family safety, women-safe stops, pure-veg, ghat sections, temples — first-class concepts.
6. **Trust signals on everything.** Reliability score + freshness + source badge on every POI.

---

## Tech stack

| Layer | Choice |
|---|---|
| App | Flutter 3.11.4, Dart |
| State | `flutter_riverpod` (`family.autoDispose`, `StateNotifier<UiState>`) |
| Models | `freezed` + `json_serializable` |
| Errors | `fpdart` `Either<Failure, T>` on every repository write |
| Local cache & offline queue | Hive |
| Backend | Firebase Auth + Cloud Firestore |
| Maps & routing | Google Maps + Google Directions + Open Charge Map |
| Notifications | `flutter_local_notifications` |

See [`docs/context/decisions.md`](docs/context/decisions.md) for architecture decisions.

---

## Repository layout

```
lib/
  core/
    constants/           API keys, Hive box names
    domain/              Cross-feature models (Vehicle, Poi, UserPreferences)
    services/            Directions, Geocoding, RoutePoi, EV station sources
    theme/               AppColors · AppTextStyles · AppTheme
    utils/               Polyline decoder, station merger, Result type
    widgets/             Cross-feature widgets
  features/
    <feature>/
      data/              DTOs, repositories, local DB / queues
      domain/            Freezed entities + UI state sealed unions
      presentation/
        controller/      Riverpod providers + StateNotifier controllers
        view/            Full-screen widgets
        widget/          Feature-private atoms

project_plan/            Phase-by-phase task lists (P1-001 … P4-032)
docs/context/            current_state · decisions · glossary · product_vision
docs/ai_context/         Rolling AI working notes
firebase/                Firestore rules + composite indexes
```

A feature must **not** import another feature's `data/` or `domain/` internals — only its public `*_providers.dart` and domain models.

---

## Getting started

### Prerequisites

- Flutter SDK `^3.11.4`
- A Firebase project (Auth + Firestore) configured for iOS and Android. Drop in the standard `google-services.json` / `GoogleService-Info.plist`.
- A `.env` file at the project root containing the API keys:
  ```env
  GOOGLE_MAPS_API_KEY=...
  GOOGLE_PLACES_API_KEY=...
  OPEN_CHARGE_MAP_API_KEY=...
  ```

### Run

```bash
flutter pub get
dart run build_runner build --delete-conflicting-outputs
flutter run
```

### After any Freezed model change

```bash
dart run build_runner build --delete-conflicting-outputs
```

---

## Screenshots

_(Placeholder — populated during Phase 1 UI work.)_

| Plan | Smart Intelligence Grid | Trip Dashboard | Community Pulse |
|---|---|---|---|
| _coming soon_ | _coming soon_ | _coming soon_ | _coming soon_ |

---

## Roadmap

| Phase | Theme | Duration |
|---|---|---|
| **Phase 1** | Smart Highway Companion MVP — vehicle profile, generalized POI domain, intelligence grid, distance-based alerts, community pulses on POIs | 4–6 weeks |
| **Phase 2** | Predictive & Personalized Intelligence — ghat / fatigue / night / weather alerts, recommendation ranker, Family / Women-Safe / Bike modes | 4–6 weeks |
| **Phase 3** | AI Travel Copilot — chat + voice assistant, hidden-gem AI curation, battery-aware EV routing | 6–8 weeks |
| **Phase 4** | Scale & Monetization — premium, sponsored placements, CarPlay/Android Auto, backend migration | ongoing |

Full plan: [`project_plan/00_overview.md`](project_plan/00_overview.md).

---

## Contributing

- Read [`docs/context/product_vision.md`](docs/context/product_vision.md) and [`docs/context/decisions.md`](docs/context/decisions.md) first.
- Pick a task ID from [`project_plan/tasks.csv`](project_plan/tasks.csv) (e.g. `P1-007`) and reference it in commits and PRs.
- Run `dart run build_runner build --delete-conflicting-outputs` after any model change and commit both source and generated files.
- All repository writes must return `Either<Failure, T>` using the error taxonomy: `network`, `permission`, `index`, `firestore`, `platform`, `quota`.

---

## License

Proprietary — all rights reserved.
