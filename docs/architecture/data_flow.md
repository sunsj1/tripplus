# Data Flow

How data moves through JourneyPlus — from external sources to UI, and from user actions back to storage.

---

## 1. The general read path (any feature)

```
External API / Firestore stream
        │
        ▼
   Repository (data/)
   • Maps to domain via DTO
   • Catches errors → Failure taxonomy
   • Returns Stream<T> or Either<Failure, T>
        │
        ▼
   Riverpod provider
   • family.autoDispose keyed by stable id
   • Wraps in AsyncValue
        │
        ▼
   Controller (StateNotifier<UiState>)
   • Combines streams + user actions
   • Emits Freezed sealed union (initial/loading/data/error)
        │
        ▼
   View / Widget (ref.watch)
   • Pattern-matches on UiState
   • Renders trust signals, loading skeletons, error CTAs
```

This is the **only** read path. No widget calls Firestore directly. No service calls Hive directly without going through a repository.

---

## 2. The general write path (any feature)

```
User taps a button in a widget
        │
        ▼
   ref.read(provider.notifier).action(input)
        │
        ▼
   Controller.action(input)
   • Validates
   • Calls repository.add(...)
        │
        ▼
   Repository
   • Tries online write
   • On failure: enqueues to Hive offline queue
   • Returns Either<Failure, T>
        │
        ┌────────── Right(T): UI shows success → state refreshes via stream
        │
        └────────── Left(Failure): UI shows actionable CTA
                                   (Retry now / Open settings / Try later)
```

---

## 3. Concrete example — community pulse submission (today)

```
1. User taps "Add report" on StationDetailScreen
   └─► showStationReportSheet(...)

2. User completes the wizard (pulse → amenities → photo → review)
   └─► StationCommunitySubmitInput is built

3. Wizard calls:
      ref.read(stationCommunityControllerProvider(stationKey).notifier)
         .submit(input)

4. StationCommunityController.submit:
   a. Local pre-validate
   b. Repository.add(input):
      i.   Photo: compress JPEG → base64
      ii.  Build Firestore doc: { stationKey, targetType, targetKey,
                                  rating, condition, amenities,
                                  photoBase64, notes, reporterUserId,
                                  createdAt: serverTimestamp() }
      iii. firestore.collection('stationCommunityReports').add(doc)
      iv.  On FirebaseException → return Left(Failure.firestore(...))
      v.   On no network    → CommunitySubmitQueue.enqueue(input)
                              return Left(Failure.network('queued'))

5. UI receives Either:
   • Right → snackbar "Pulse submitted"
   • Left  → snackbar with proper CTA mapped from Failure category

6. Live feed updates automatically because the controller is listening to:
      repository.watchByStationKey(stationKey)
   which is a Firestore live stream.
```

---

## 4. Concrete example — route-aware POI discovery (Phase 1 target)

```
User on PoiCategoryScreen(category: PoiCategory.fuel)
        │
        ▼
poiCategoryControllerProvider(PoiQuery(
   category: fuel,
   tripId: <active or current draft>,
)).watch
        │
        ▼
PoiCategoryController.build():
  1. Get active route polyline from ActiveTripController (or draft plan)
  2. routePoiService.search(
       polyline: <route>,
       category: fuel,
       corridorWidthM: 3000,
       limit: 50,
     )
       └─► GooglePlacesPoiSource: sample N waypoints along polyline,
           text-search "petrol pump" with location bias, merge + dedupe
  3. For each POI:
       community = communityRepository.watchByTarget(communityPoiKey(poi))
  4. Combine into Poi + CommunitySnapshot pairs
  5. Apply ranker (Phase 2: PoiRanker; Phase 1: distance-asc)
  6. Emit UiState.data(list)
        │
        ▼
Widget renders:
   • Skeleton while loading
   • List of POI cards with CommunityRatingPulse chips
   • Empty / error states from taxonomy
```

---

## 5. Concrete example — distance-based alert (Phase 1 target)

```
ActiveTripController emits a stream of TripTick
   (currentLocation, distanceTraveled, distanceRemaining, currentSegment)
        │
        ▼
AlertEngine.evaluate(TripTick, RouteContext, Vehicle, Preferences, UpcomingPois):
   Runs all registered rules in priority order
   • FuelLowRule:   if vehicle.isCombustion && nextFuelPoi.distanceKm > threshold → Alert.fuelLow
   • EvGapRule:     if vehicle.isEv && nextChargerPoi.distanceKm > 70 → Alert.evGap
   • FoodWindowRule:if elapsedSinceLastMeal > 3h → Alert.foodAhead(nextRestaurant)
        │
        ▼
AlertNotifier filters by:
   • Cooldown (don't refire within X km / Y minutes)
   • User notification preferences
        │
        ▼
For each fired Alert:
   • Push in-app banner (always)
   • Schedule local notification (if app is backgrounded)
   • Append to trip history (Hive `active_trip` → firedAlerts[])
```

---

## 6. Offline data flow

```
Network UP:
  Write happens directly → Firestore confirms.

Network DOWN at write time:
  Repository catches network error
    → CommunitySubmitQueue.enqueue(input)   (Hive box `community_submit_queue`)
    → returns Left(Failure.network('queued'))
    → UI shows "Saved — will sync when online"

Network returns (detected by connectivity_plus listener):
  CommunitySubmitQueue.retryRunner():
    For each queued input:
      repository.add(input)
        Right → dequeue
        Left  → leave in queue, bump retry count

Read during offline (active trip):
  Repository tries Firestore → fails offline
    → falls back to CorridorCache (Hive box `corridor_cache`)
    → emits cached POIs with `cached: true` flag
    → UI shows degraded-mode banner
```

---

## 7. AI flow (Phase 3 target)

```
User says: "Find pure-veg restaurant in next 30 km"
        │
        ▼
SpeechToText → text "find pure-veg restaurant in next 30 km"
        │
        ▼
AiService.send(text, context = TripContextPacker.pack(activeTrip, profile))
        │
        ▼
Cloud Function /chat:
  1. Build prompt from versioned template + context JSON
  2. Call LLM with tool definitions:
       - find_poi(category, filter, withinKm)
       - compare_routes(criteria)
       - narrate_trip()
  3. LLM responds with tool call: find_poi(restaurant, {pureVeg: true}, 30)
  4. Cloud Function executes find_poi via service account → Firestore + Places
  5. Returns final assistant message + structured POI list to client
        │
        ▼
Chat UI renders message + inline POI cards (real, never fabricated — ADR-006)
        │
        ▼
flutter_tts speaks the spoken-summary path of the response
```

---

## 8. Schema boundaries

| Boundary | Mapper | Lives in |
|---|---|---|
| Firestore ↔ Domain | `*_dto.dart` `fromSnapshot(...)` / `toCreateMap(...)` | `lib/features/<f>/data/dto/` |
| HTTP ↔ Domain | `*_dto.dart` with json_serializable | `lib/features/<f>/data/dto/` or `lib/core/services/` for cross-feature |
| Hive ↔ Domain | Encoder/decoder in the queue/cache manager | `lib/features/<f>/data/local_db/` |

UI **only** sees domain types. Anything else is a leak.
