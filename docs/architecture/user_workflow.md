# User Workflow

End-to-end journey of a user using TripPlus. Combines (a) **first-time setup**, (b) **planning a trip**, (c) **on-trip experience**, (d) **post-trip**.

> This is the *intended* workflow at end of Phase 1 (Smart Highway Companion MVP). Phase 2/3 enhancements are noted inline.

---

## 0. Install & first launch

```
[App icon tap]
   │
   ▼
[Splash]
   │
   ▼
[Onboarding screens]   ← positioning + permissions explainer
   │
   ▼
[Sign in]              ← Firebase Auth (Google / phone)
   │
   ▼
[Profile completion]   ← name, photo (existing)
   │
   ▼
[Vehicle & Preferences setup]                          🆕 P1-032
   • Vehicle type: Petrol / Diesel / EV / Bike
   • If EV: connector types, battery, fast-only?
   • If combustion: fuel efficiency (kmpl)
   • Preferences: pure-veg, family, women-safe, pet-friendly,
                  night-safe, scenic, preferred fuel brand
   │
   ▼
[AppShell — main app]   tabs: Plan · Trip · Discover · Profile   🆕 P1-016
```

---

## 1. Planning a trip (Plan tab)

```
[Plan tab]
   │
   ▼
[Route Input Card]
   • From location (autocomplete)
   • To location (autocomplete)
   • Vehicle override (defaults to profile)        🆕 P1-005
   • Trip-specific preference chips                🆕 P1-005
        e.g. "Family today", "Fastest", "Scenic"
   │
   ▼ tap "Plan trip"
   │
[Calculating screen]
   • directions_service → polyline + alternatives
   • route_poi_service for chargers (existing path)
   │
   ▼
[Plan Result View]
   ┌────────────────────────────────────────────┐
   │ 🚗 Pune → Nashik · Petrol · Family         │
   ├────────────────────────────────────────────┤
   │ Trip Dashboard (stat cards):                │
   │   • Distance: 215 km                        │
   │   • ETA: 4h 30m                             │
   │   • Fuel cost: ₹ 980  (derived from kmpl)  │
   │   • Tolls: ₹ 180 (placeholder Phase 1)     │
   │   • Weather: ☁️  partly cloudy (Phase 2)   │
   ├────────────────────────────────────────────┤
   │ Smart Trip Timeline                         │
   │   Start ─▶ Fuel @ Talegaon (45 km)         │
   │         ─▶ Breakfast Sai Restaurant         │
   │         ─▶ Scenic Pano Sangamner            │
   │         ─▶ Destination Nashik               │
   │   [+ Edit stops]                            │
   ├────────────────────────────────────────────┤
   │ Quick Discover (Phase 1 chips → Discover):  │
   │   ⛽ Fuel · 🍴 Food · 🚻 Washrooms ...      │
   ├────────────────────────────────────────────┤
   │ [Start trip]                                │
   └────────────────────────────────────────────┘
```

---

## 2. Discovering POIs (Discover tab — Smart Intelligence Grid)

This is the iconic screen from the PDF.

```
[Discover tab]
   ┌──────────────────────────────────────────┐
   │ Smart Intelligence Grid (3-col)          │
   │   ⛽       ⚡       🍴                    │
   │  Fuel    EV     Food                     │
   │                                          │
   │   🥗     🏨      🚻                      │
   │  PureVeg Hotels Washroom                 │
   │                                          │
   │   🏧     👨‍👩‍👧    🩺                    │
   │   ATM    Family Medical                  │
   │                                          │
   │   👮     🔧     ☕                       │
   │  Police Mech.  Cafe                      │
   │                                          │
   │   🌄     🛕     🅿                       │
   │  Scenic Temple Park                      │
   │                                          │
   │   🧒     📸                              │
   │  Kids   Tourist                          │
   └──────────────────────────────────────────┘
   │
   ▼ tap any tile
   │
[PoiCategoryScreen]   parameterized by PoiCategory
   • Header: 🍴 Restaurants — along route (215 km)
   • Filter chips: Open now · Pure veg · Highly rated · Family-friendly
   • Toggle: List ↔ Map
   • List items:
        ┌──────────────────────────────────────┐
        │ Hotel Sai Pure Veg                   │
        │ ⭐ 4.4 (213 reviews) · 28 km ahead   │
        │ 🟢 Community pulse: clean, family-OK │
        │ [Pin to timeline] [Directions]       │
        └──────────────────────────────────────┘
```

---

## 3. On-trip experience (Trip tab)

User tapped "Start trip" — now the Trip tab is the home of action.

```
[Trip tab — active]
   ┌────────────────────────────────────────────┐
   │ 🟢 LIVE TRIP · 78 km of 215 km             │
   ├────────────────────────────────────────────┤
   │ Next stop: ⛽ HP Pump (12 km)              │
   │   Pulse: 🟢 clean, working, 18 reports     │
   │   [Skip] [Directions]                      │
   ├────────────────────────────────────────────┤
   │ Smart Trip Timeline (live, current step    │
   │   highlighted)                             │
   ├────────────────────────────────────────────┤
   │ Recent alerts                              │
   │   ⚠️  "Last trusted pump for next 65 km"   │
   │   ⚠️  "No EV charger ahead for 91 km"      │
   │   ℹ️  "Highly-rated veg restaurant in 8 km"│
   └────────────────────────────────────────────┘

   [AI assistant FAB] (Phase 3)                   🆕 P3-013
```

### Alert UX

```
Alert fires
   │
   ▼
Foreground app: top in-app banner with action buttons
                ("Show on map" · "Snooze" · "Find alternative")
   │
   ▼
Background app: local notification
                tap → opens Trip tab → highlights triggering POI
```

### Offline mode

If connectivity drops mid-trip:
```
Banner appears: "Offline — using cached corridor data"
Trip data, alerts, and pre-cached POIs still work.
Submissions queue locally → flush on reconnect.
```

---

## 4. Community contribution (anywhere)

```
[POI detail screen / Station detail screen]
   ┌────────────────────────────────────────────┐
   │  Hotel Sai Pure Veg                        │
   │  ⭐ 4.4 · 28 km ahead                      │
   │                                            │
   │  Community Section                         │
   │   Reliability: 8.1/10 (24 pulses, 3d fresh)│
   │   Latest pulses (carousel)…                │
   │   [+ Add your pulse]                       │
   └────────────────────────────────────────────┘
   │
   ▼
[Report wizard bottom sheet]
   Step 1 · Quick pulse:  rating + condition (working / down / mixed)
   Step 2 · Amenities:    washroom · food · safety tags
   Step 3 · Photo:        optional (compressed → base64)
   Step 4 · Review:       confirm + submit
   │
   ▼
Repository.add(input):
   Online → Firestore confirmation → snackbar
   Offline → CommunitySubmitQueue → "Saved — will sync"
```

---

## 5. Ending a trip

```
User taps "End trip" (or arrives at destination)
   │
   ▼
[Trip Summary Screen]
   • Distance / time / stops made / alerts fired
   • Prompts: "How was X stop?" → 1-tap pulses
   • Save / share trip (Phase 2)
   │
   ▼
Trip persisted to Hive `active_trip` archive + Firestore (Phase 2)
   │
   ▼
Back to Plan tab.
```

---

## 6. Profile / Settings

```
[Profile tab]
   • Vehicle (edit)
   • Preferences (edit chips)
   • Trip history (Phase 2)
   • Notification preferences (Phase 2)
   • What the assistant learned (Phase 3 · P3-041)
   • Account & sign out
```

---

## Workflow summary by phase

| Phase | What the user can newly do |
|---|---|
| **Phase 1 (MVP)** | Set vehicle + preferences, plan any vehicle's trip, see Smart Grid, see route-aware POIs across 6+ categories with community pulses, receive 3 distance-based alerts, run an active trip with offline corridor cache. |
| **Phase 2** | Get ghat/night/fatigue/weather alerts. Family/Women-Safe/Bike toggle changes ranking. See weather per segment + traffic-aware ETA + toll estimate. View trip history. |
| **Phase 3** | Talk or chat with assistant grounded in trip context. Battery-aware EV routing. Driving Score. |
| **Phase 4** | Premium tier, CarPlay/Android Auto, hotel bookings, FASTag, etc. |
