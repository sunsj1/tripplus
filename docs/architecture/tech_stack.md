# Tech Stack

What we use, what version constraint, and **why**. Anything not on this list requires an ADR before introducing.

---

## Frontend

| Layer | Choice | Version | Why |
|---|---|---|---|
| UI framework | **Flutter** (Material) | Dart SDK `^3.11.4` | Cross-platform (Android, iOS, Windows present); ships fast; great Riverpod ecosystem. |
| State management | **flutter_riverpod** | `^2.6.x` | Compile-safe DI + state, scoped `family.autoDispose` keys, no BuildContext for state access. (ADR-003) |
| Models | **freezed_annotation** + **freezed** + **json_serializable** | freezed `^2.5.x` | Immutable, sealed unions for UI state, free `fromJson`/`toJson` at API boundaries. |
| Functional errors | **fpdart** | `^1.1.x` | `Either<Failure, T>` returns enforce error-taxonomy mapping at the UI. (ADR-004) |
| HTTP | **dio** | `^5.7.x` | Interceptors, cancellation, retries cleaner than `http`. |
| Local storage | **hive** + **hive_flutter** | hive `^2.2.x` | Fast box-based KV; offline queue + corridor cache + user profile mirror. |
| Maps | **google_maps_flutter** | `^2.10.x` | Native Google Maps; matches Places + Directions consistency. |
| Location | **geolocator** | `^13.0.x` | Foreground service + permission integration. |
| Permissions | **permission_handler** | `^12.0.x` | One API across iOS/Android. |
| Images (pick) | **image_picker** | `^1.1.x` | Gallery + camera, simple API. |
| Images (compress) | **flutter_image_compress** | `^2.3.x` | Compress before base64 to fit Firestore doc size. |
| Notifications | **flutter_local_notifications** (add in `P1-027`) | latest | Local notifications for predictive alerts. |
| Connectivity | **connectivity_plus** (add in `P1-063`) | latest | Detect when to flush offline queues. |
| Env | **flutter_dotenv** | `^5.2.x` | `.env` bundled as asset (API keys at build-time). |
| Logging | **logger** | `^2.5.x` | Pretty + level-based logs. |
| Phone parsing | **intl_phone_field** + **phone_numbers_parser** | latest | Phone auth UX. |

### Phase 3 additions (AI Copilot)

| Layer | Choice | Notes |
|---|---|---|
| AI provider abstraction | hand-rolled `ai_service.dart` interface | OpenAI / Gemini swappable behind an interface |
| Speech recognition | **speech_to_text** | Push-to-talk |
| TTS | **flutter_tts** | Voice replies + audio-only mode |

### Phase 4 additions

| Layer | Choice | Notes |
|---|---|---|
| Subscriptions | **purchases_flutter** (RevenueCat) | Cross-store subscription orchestration |
| CarPlay / Android Auto | platform-channel + native modules | Driving-safe minimal UI |

---

## Backend

### Today

| Layer | Choice | Why |
|---|---|---|
| Auth | **Firebase Auth** | Google + phone, simple, secure |
| Database | **Cloud Firestore** | Live streams for community feed; cheap to start |
| Crashlytics + Analytics | **Firebase Crashlytics + Analytics** (`P1-064`, wire in `P2-071`) | Free with Firebase, default observability |
| Storage for community photos | **none** — base64 inline on Firestore docs | (ADR-002) — saves Storage costs, fewer rules |

### Phase 3

| Layer | Choice | Why |
|---|---|---|
| AI proxy | **Firebase Cloud Functions** (Node.js / TypeScript) | Keys server-side, per-uid rate limiting, prompt templates from Remote Config (ADR-006) |
| Push notifications | **Firebase Cloud Messaging** (FCM) | If we need server-pushed alerts; Phase 1 stays local |

### Phase 4 (only if scale demands)

| Layer | Choice | Trigger |
|---|---|---|
| Gateway | **NestJS** (Node.js) | Firestore reads become a top-3 cost line OR queries outgrow Firestore |
| Spatial DB | **Postgres + PostGIS** | True corridor queries on POIs at scale |
| Hot cache | **Redis** | Cache route POIs + plan results |
| Ingestion | **Kafka** | Community report ingestion at scale |
| Orchestration | **Kubernetes** | Only when traffic justifies |

---

## External APIs

| API | Used for | Cost note |
|---|---|---|
| Google Maps SDK (Android/iOS) | Map rendering | Standard MAU billing |
| Google Places API | POI text search, autocomplete | Per-request — minimize via along-route waypoint sampling and aggressive caching in `corridor_cache` |
| Google Directions API | Route polyline + alternatives | Per-request |
| Google Geocoding | "Use my current location" | Per-request |
| Google Elevation API (Phase 2) | Ghat detection | Per-request — cache per route corridor |
| Open Charge Map | EV station inventory | Free, attribution required |
| Open-Meteo (Phase 2) | Per-segment weather | Free, no key |
| OpenAI / Gemini (Phase 3) | LLM | Per-token (server-side via Cloud Function) |

---

## Code-gen pipeline

- Run after editing any `@freezed` or `@JsonSerializable` class:
  ```
  dart run build_runner build --delete-conflicting-outputs
  ```
- Generated files (`*.freezed.dart`, `*.g.dart`) are **committed** to git.
- Don't manually edit generated files.

---

## Lint & analyzer

- `analysis_options.yaml` extends `flutter_lints`.
- All warnings are errors in CI (when CI is set up).
- New rule additions go through `docs/context/decisions.md`.

---

## What we deliberately do NOT use

| ❌ Not used | Why not |
|---|---|
| Provider / Bloc / GetX / Redux | Riverpod is the chosen path (ADR-003) |
| Firebase Storage for community photos | Base64 inline is cheaper and faster (ADR-002) |
| Auto-generated route packages (`go_router`, `auto_route`) | Tab-based shell is simple enough; revisit only if deep linking grows |
| `http` package | `dio` chosen for interceptors + cancellation |
| GraphQL clients | REST + Firestore streams are sufficient |
| ORM | Hive + Firestore — no ORM needed |
