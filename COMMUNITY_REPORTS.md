# Community station reports

## Purpose

Drivers share short, structured “pulses” about a charging stop (rating, amenities, washroom, optional photo, notes). Data lives in **Firestore** so every user who opens the **same station** (detail screen or route list tile) sees the same community signal. The app does **not** use Firebase Storage for these photos; images are **compressed JPEG** and stored as **base64** on the document (kept under a safe size for Firestore limits).

## Station identity (`stationKey`)

The same physical station must map to one community thread across OCM/Google and different screens.

- Implementation: `lib/features/community/domain/community_station_key.dart` — `communityStationKey(ChargingStation station)`.
- Prefer non-empty `station.uuid` → key like `u_<uuid>`.
- Else fallback: `ocm_<id>_<lat5>_<lng5>` (rounded coordinates).

**Always** use this function when querying or writing reports so detail, plan results, and nearby lists stay consistent.

## Architecture (feature slice)

| Layer | Role |
| --- | --- |
| **presentation/widgets/** | UI only: section, carousel, wizard steps, list “pulse” chip. |
| **presentation/controller/** | `StationCommunityController` — `StateNotifier<StationCommunityUiState>`, listens to repository stream, exposes `submit`. |
| **presentation/controller/community_providers.dart** | `communityReportRepositoryProvider`, `stationCommunityControllerProvider.family` keyed by `stationKey`. |
| **data/repository/community_report_repository.dart** | Firestore `watch` + `add`; returns `fpdart` `Either` for writes. |
| **data/dto/station_community_report_dto.dart** | `DocumentSnapshot` → `StationCommunityReport`; submit payload → create map. |
| **data/community_photo_compress.dart** | Enforces max pick size (5 MB), compresses toward `maxStoredJpegBytes`, `encodeJpegBase64`. |
| **domain/models/** | `StationCommunityReport`, `StationCommunitySubmitInput`, `StationCommunityUiState` — **freezed** models. |

## Firestore

- **Collection:** `stationCommunityReports`
- **Query (live feed):** `where('stationKey', == key)` — no composite index needed. Results are sorted by `createdAt` **in the app**, then truncated to the **50** newest.
- **Optional index (scale):** `firebase/firestore.indexes.json` defines `stationKey` + `createdAt` for a future server-side `orderBy` + `limit` if a station ever has very large report volume (fewer document reads). Deploy with `firebase deploy --only firestore:indexes`.

### Security rules

See `firebase/firestore.rules`:

- **Read:** public (`allow read: if true`) so list previews work without blocking UX.
- **Create:** authenticated user only; `reporterUserId` must equal `request.auth.uid`; basic field checks on `stationKey`, `rating`, `condition`.
- **Update / delete:** denied (immutable community log).

Deploy rules with your usual Firebase workflow (`firebase deploy --only firestore:rules`).

## UI flows

1. **Station detail — `CommunityReportsSection`**  
   Watches `stationCommunityControllerProvider(communityStationKey(station))`. Shows average rating, vertical carousel of recent reports, CTA to open the wizard.

2. **Report wizard — `showStationReportSheet`**  
   Multi-step bottom sheet (`station_report_sheet.dart` + step widgets). Submits `StationCommunitySubmitInput` through the controller. Photo: gallery only, max 5 MB pick, compress, base64 on the document.

3. **Route / station lists — `CommunityRatingPulse`**  
   Same provider family by `communityStationKey(station)`; shows compact average + count when reports exist.

## Dependencies

- `cloud_firestore`, `flutter_riverpod`, `fpdart`, `freezed`
- `image_picker`, `flutter_image_compress`

## iOS

`NSPhotoLibraryUsageDescription` is set in `ios/Runner/Info.plist` for gallery access.

## Removed legacy path

Local **Hive** box `community_reports` and model `CommunityReport` (JSON) were removed in favor of the Firestore-backed models above.
