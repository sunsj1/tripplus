# TripPlus — Smart Features

> Demo + speech cheat sheet. Every bullet is a feature you can point to in
> the app. Organised by user journey, not by file. No jargon, no task IDs.
>
> Keep this file updated whenever a phase ships — it's the single source of
> truth for product demos, investor decks, and onboarding talks.

---

## At a glance

- **2 phases shipped** — MVP foundation + Predictive & Personalised Intelligence
- **86 features built** across 86 individual tracked tasks
- **4 navigation tabs** — Plan · Trip · Discover · Profile
- **16 POI categories** in the Smart Intelligence Grid
- **6 predictive alert rules** firing live during trips
- **14 known ghats** in the safety dataset (Maharashtra, Karnataka, Tamil Nadu)
- **4 curated highway corridors** with hand-picked hidden gems
- **Dual-source EV station data** — Open Charge Map + Google EV Stations, merged
- **Per-segment live weather** from Open-Meteo (free, no API key)
- **Real-time traffic** via Google Directions live duration

---

## 1. Planning a trip

- **Smart "From" defaults to your current GPS location** — no typing required to start a trip from where you are
- **Places autocomplete** on every input — Google-powered with a free Nominatim fallback if the API key is missing
- **Popular routes** pre-fill destination + origin from a curated India list — Mumbai → Pune, Delhi → Jaipur, Bangalore → Mysore, Chennai → Pondicherry
- **Per-trip vehicle override** without changing the saved profile — pick a different vehicle just for this trip
- **Per-trip preference toggles** — pure veg, family, women-safe, fast chargers only, pet-friendly, night-safe, scenic route
- **Fuel-brand preferences** for petrol/diesel users — pick your loyalty brand from BPCL / Indian Oil / HP / JIO-BP / Nayara / Shell

---

## 2. The route analysis surface

- **Dual-source EV station merge** — Open Charge Map (community) + Google EV Stations (official), de-duplicated by proximity
- **Route summary card** showing origin → destination, station count, distance, estimated drive time
- **Trip Overview stat row** — ETA, Tolls (~), Fuel/Charging cost (~), Traffic level (Low/Moderate/High)
- **All financial estimates labelled "~ estimates only"** so users never mistake them for live prices
- **Weather strip across the route** — 3 to 4 cards (Origin · Midway · Destination) with temperature, condition icon, wind speed, precipitation
- **Hazard count badge** if any segment has rain, fog, or thunderstorm — "2 caution" appears in the weather strip header
- **Live traffic-aware ETA** — Google Directions `departure_time=now` returns `duration_in_traffic`, blended into the ETA stat
- **Traffic level recomputed** — uses live free-flow vs traffic ratio when available, falls back to theoretical 80 km/h ratio otherwise
- **Toll estimate** uses a curated corridor dataset for major expressways; falls back to flat ₹1.5/km elsewhere
- **Smart Trip Timeline** — vertical Origin → Charging stops → Destination with distance chips, gradient connector lines, colour-coded bubbles
- **Fast Charge filter chip** on the EV station list — "Fast only" toggle live-filters fast-charging stations
- **Nearest station card** for EVs with distance, fast-charge flag, and source badge
- **Gap warning banner** when any leg exceeds the charge-range threshold

---

## 3. The Smart Intelligence Grid (Discover tab)

- **16 POI categories** in a clean 3-column grid — Fuel · EV · Restaurants · Pure Veg · Washrooms · ATMs · Hotels · Medical · Scenic · Temples · Kids Stop · Mechanic · Parking · Cafes · Tourist · Police
- **Pinned Emergency tile** above the grid — instant access to SOS shortcuts
- **"Plan a route" CTA banner** when no trip is active — tells the user the grid gets sharper with a plan
- **Hidden Gems carousel** appears between the Emergency tile and the grid when the active route matches a curated corridor
- **4 curated corridors** with hand-picked gems — Mumbai-Pune Expressway, Yamuna Expressway, Bengaluru-Mysuru Expressway, Samruddhi Mahamarg
- **Editorial gem categories** — Food, Scenic, Specialty — each gem also carries multi-valued tags including "Underrated"

---

## 4. Category lists with smart sort

- **"Best Match" is the default sort** with a ✨ icon — driven by the personalised ranker, not raw distance
- **Sort chips** — Best match · Nearest · Top rated · Open now
- **"Open now" honesty** — the chip dims with a tooltip when no live-hours data is loaded yet, instead of silently doing nothing
- **List ⇄ Map toggle** in the app bar
- **Map clustering at low zoom** — POIs in the same area merge into count badges; tap a cluster to zoom in 1.5 levels
- **Custom cluster icons** drawn with Skia and cached by count (green halo + count number)
- **Cached POI photos** — `cached_network_image` keeps images on disk and decoded in memory, so scrolling doesn't re-download
- **POI source badges** on every tile — colour-coded Official (blue) · Community (teal) · Curated (amber) · Unverified (grey)

---

## 5. Personalised ranking

- **PoiRanker scores every POI** by blending quality × confidence + proximity decay + openness + matched preferences
- **Quality signal** — rating × review-count confidence (saturating at /20 reviews)
- **Proximity signal** — smooth decay over ~25 km of "ahead" distance
- **Openness signal** — flat bonus for `openNow == true`
- **Preference matches** activate only when the user opts in — pure veg, family-friendly, women-safe, pet-friendly, scenic, budget tier
- **Fuel-brand match** — bonus when POI name contains the user's preferred brand
- **Brand affinity learning** — opening a fuel POI bumps that brand's score (+1.0 for view, +5.0 for a community pulse); blended back into the ranker
- **Affinity weights capped** so an explicit user selection (weight 2.0) always outranks a purely-learned brand (max 1.5)
- **Brand affinity persists across app restarts** in a Hive box, no cloud sync needed

---

## 6. "Why we recommend this" transparency

- **Top 3 personalised reasons** card on every POI detail sheet
- **Plain-language explanations** — "Open now", "4.5★ from 200 reviews", "Pure veg", "12.3 km away on your route", "Matches your standard budget"
- **Reasons gated to avoid noise** — quality only mentioned when rating ≥ 4 AND contribution > 0.5; proximity only when ≤ 30 km ahead; budget only on strong match
- **Hides itself silently** when there's nothing meaningful to say — silence beats noise

---

## 7. Mode-aware filters (Family · Women-Safe · Bike)

- **VIEW MODE bar** above every POI category list with 4 chips — Standard · Family · Women-Safe · Bike
- **Active mode shows "filtered" tag** in the bar's header
- **Family Mode** trims to hotel, restaurant, pure veg, washroom, medical, kids stop, scenic, temple, fuel — the categories families need on the road
- **Women-Safe Mode** trims to hotel, fuel, police, medical, washroom, restaurant — well-lit, staffed places
- **Bike Mode** trims to mechanic, fuel, medical, parking, washroom, hotel, cafe — bike-rider priorities
- **Tap the active chip again to clear** the mode and see everything
- **Mode-filtered empty state** with a "Clear mode" CTA tinted to the mode's accent colour
- **POI mode badges** on tiles when community pulses agree — small purple shield for Women-Safe, amber family icon for Family
- **Count updates live** — "8 of 24" reflects the filter

---

## 8. Predictive alert engine

- **Engine evaluates a 100 km upcoming window** instead of the entire remaining route — alerts always reference stops you can act on now
- **Per-type 20-minute cooldown** — same alert can re-fire after that, so a renewed condition (fuel low again) actually re-surfaces
- **Three severity tiers** — critical (red, manual dismiss only), warning (amber, auto-dismiss 8s with "Dismisses in 8s" hint), info (slim green pill, auto-dismiss 5s)
- **Type-specific glyphs** on every banner — fuel pump for fuel-low, terrain for ghat, bedtime for fatigue, EV station for charger gap
- **In-app banner + local notification** for every alert — system tray push fires even with the app in background
- **Per-trip Alert History** screen showing every alert that fired during the drive

### The 6 alert rules

- **Fuel Low** — warns when the next community-trusted fuel stop is more than 40 km away ahead
- **EV Gap** — warns when the next charger (fast charger if the user enabled "fast only") is beyond gap threshold
- **Food Window** — surfaces highly-rated meal stops within a 50 km lookahead, honoring `pureVeg` preference
- **Ghat / Risk** — fires when the route enters a known mountain pass section; warns about winding road + descent gear use
- **Night Driving** — between 22:00–05:00 local time, suggests nearest hotel (or fuel) within 45 km
- **Fatigue** — every 3 hours of continuous driving (paused time excluded), suggests a 15-minute break

### Ghat dataset

- **14 hand-curated ghat sections** with approximate centre + radius + length
- **Maharashtra coverage** — Bhor, Khandala, Kasara (Thal), Malshej, Tamhini, Varandha, Amba, Kumbharli, Amboli
- **Karnataka coverage** — Charmadi, Shiradi, Agumbe
- **Other coverage** — Nilgiri (Kallar-Coonoor), Bhimashankar
- **Match by perpendicular distance** to the polyline — route counts as traversing the ghat if it passes within the configured radius

---

## 9. Community trust

- **Firestore-backed community pulses** with offline submit queue
- **Pulse rating + condition + comment + optional photo** (base64 inline, no Firebase Storage cost)
- **POI pulse submit** — lightweight star + comment + tri-state tag sheet (different from the multi-step EV station wizard)
- **Tri-state tag UI** — tap to set ✓ or ✗, tap again to clear back to unanswered (so users don't accidentally bias aggregation)
- **Three mode-relevant tags** — baby-friendly, women-safe, hygienic. Null = unanswered, doesn't drag down the signal
- **Tag aggregation** with quality gate — needs ≥ 2 answers AND ≥ 50% yes to "qualify" a POI for the mode badge
- **Reliability score 0–100** for every POI with community pulses — weights condition × recency, dampened by review confidence
- **TrustLevel tier** — Trusted · Mixed · Low trust · Unrated — drives consistent badge colours across surfaces
- **Conflict-aware timeline** on the POI detail sheet when recent pulses disagree — newest-first chronological list with colour-coded condition dots
- **Generalised condition vocabulary** — works for both EV (`working/issues/down`) and POI (`good/fair/poor`); a 1-star POI no longer shows "Charging looked good"
- **Reusable Source Badge** on tiles, detail sheets, and station screens — Official · Community · Curated · Unverified, colour-coded

---

## 10. Trip lifecycle

- **5-state machine** — Idle · Ready · Running · Paused · Completed
- **Hive-persisted across app restarts** — kill the app mid-trip and reopen, the trip resumes
- **Foreground location tracking** auto-restarts when restoring a running trip
- **Live elapsed timer** on the dashboard, updates every second, excludes paused intervals
- **Pause / Resume / End** controls on the live dashboard
- **End-trip confirmation dialog** so a fat-finger tap doesn't abort the trip
- **Corridor cache** snapshots the route polyline and station IDs into Hive on `prepareTrip` for offline resilience
- **Per-trip alert history** captured on the Trip document for later review
- **Active-trip POI lists trim to "ahead on route"** — only stops in front of your current GPS position appear in any POI category
- **Source badge changes to "Ahead on your route"** to signal the filter is active

---

## 11. After the trip

- **Post-trip completed summary** with Duration, Distance, Stations count, Cost estimate, Tolls
- **ETA vs actual comparison banner** — "On time", "X min faster than planned", or "X min longer than planned" with colour-coded icon
- **"Share this trip" button** on the completed view and on every history entry — OS share sheet with formatted text + Google Maps URL
- **Share payload** includes route, distance, ETA, fuel/charging estimate, tolls, and a Maps directions URL anyone can tap
- **Trip history list** in Profile — every completed trip, on-device only, no GPS trails uploaded
- **One-tap "Plan again"** — opens the Plan screen pre-filled with the past trip's From / To
- **Per-trip distance + duration stat cards** on every history detail screen

---

## 12. Settings & control

- **Settings screen** under Profile with three sections
- **Units toggle** — km / mi for distance display
- **Vehicle quick-edit** — change saved vehicle without leaving settings
- **Per-alert mutes** — toggle Fuel Low / EV Gap / Food Window / Ghat / Night / Fatigue / Weather on or off independently
- **All settings Hive-persisted** — survive app restart
- **Privacy policy + About TripPlus** screens accessible from Profile

---

## 13. Offline resilience

- **Offline banner** with `wifi_off` icon appears on every tab when connectivity drops
- **Animated banner** — collapses to zero height when online (no layout shift)
- **Optimistic default** — shows online on cold start so the banner doesn't flash during startup
- **Community submit queue** — pulses submitted offline are stored in Hive and flushed when connectivity returns
- **Corridor cache** lets the trip continue rendering route + station data without network

---

## 14. Discovery & emergency

- **Emergency Pinned Tile** at the top of Discover — red, prominent, instant access
- **Emergency screen** with curated hotline shortcuts
- **POI detail sheet** opens as a draggable bottom sheet on tile tap
- **Google Place photos gallery** with attribution and full-screen swipeable viewer
- **"Open in Maps" button** on every POI detail sheet — launches Google Maps with coordinates + place ID
- **"Navigate in Maps" button** on station detail — driving directions from current location

---

## 15. Performance, A11y & observability

### Performance

- **Cached POI photos** via `cached_network_image` — tile thumbnails, gallery, and full-screen viewer all share the same disk + memory cache
- **Memory cache scaled to device pixel ratio** — a 44 × 44 tile decodes at native resolution, not 400 × 400
- **Map marker clustering** below zoom 12.5 — POIs bucket into ~90 px cells; clusters tap to expand
- **Cluster icons cached by count** — drawn once with Skia, reused on every zoom tick
- **ListView.builder everywhere** — POI lists virtualise automatically
- **Server-side query optimization** — community feeds use composite indexes for `orderBy + limit(50)`; a station with 1000 reports now costs 50 reads, not 1000

### Accessibility

- **Bottom nav tabs announce as buttons** with selected state — VoiceOver says "Trip, tab, selected"
- **Mode chips announce mode label + selected state** — "Family, mode, selected"
- **Map control buttons** (Recenter / Zoom in / Zoom out) have tooltips AND semantic labels
- **All icon-only buttons get tooltips** for sighted hover and semantic labels for screen readers

### Observability

- **Crashlytics with custom keys** — every crash report carries `vehicle_type`, `route_mode`, and `trip_active`
- **User identifier set on every report** — `userId` for signed-in users, `anonymous` otherwise
- **Disabled in debug builds** — local crashes don't pollute the dashboard
- **Non-fatal breadcrumb support** via `recordEvent(name, data)` for product analytics
- **Native gradle plugin wired** for release builds

---

## 16. Architecture invariants (the boring guarantees)

These shouldn't change without an ADR, and they're worth saying out loud in a tech talk:

- Feature-slice layout under `lib/features/`
- Riverpod for all state; controllers are `StateNotifier<UiState>`
- Freezed models for every domain type
- Repositories return `Either<Failure, T>` for writes
- Community reports are immutable (schema only adds fields)
- Community photos inline as base64 (no Storage cost)
- Stable identity helpers — never raw Google or OCM IDs
- One trip at a time; one settings doc; one corridor cache
- Hive persists everything that should survive a process kill

---

## 17. Numbers worth quoting

| Stat | Value |
|---|---|
| Tasks shipped (Phase 1 + 2) | **86** |
| Predictive alert rules | **6** |
| POI categories | **16** |
| Curated ghat sections | **14** |
| Hidden-gem corridors | **4** |
| Hand-picked gems | **10** |
| Mode overlays | **4** (incl. Standard) |
| Severity tiers | **3** |
| Community condition vocabs supported | **2** (EV + POI) |
| Hive boxes in use | **7** |
| Live data sources | **3** (Google Maps, Open Charge Map, Open-Meteo) |

---

## 18. The 30-second pitch

> TripPlus is a predictive highway companion for Indian drivers.
> Plan a route in two taps — we pull live weather, live traffic, real toll
> estimates, and merge dual-source charging data automatically.
> Start the trip and our engine watches the upcoming 100 km of road: it warns
> you about charging gaps, fuel pumps, mountain passes, late-night safety
> stops, and 3-hour fatigue breaks — before you ask.
> Every POI is personally ranked using your preferences plus what we've
> learned from your taps, with a transparent "why we recommend this" card.
> Three mode overlays — Family, Women-Safe, Bike — turn the whole app into
> a different lens with one tap.
> Community pulses keep trust scores fresh, and curated hidden gems surface
> on the four busiest expressways.
> All this works offline, runs lean (50-doc cap on every community query),
> respects accessibility (semantic labels on every control), and pipes
> contextual crash reports into Crashlytics for production confidence.

---

## How to keep this file fresh

This file lives alongside `PHASE_REPORTS.md` and is updated **at the same
time** — when a phase wraps, add the new features as bullets under the right
heading, and bump the stats table. Never delete a feature line unless the
feature was actually removed.

If a feature toggles between modes (e.g. a sort default changes), update the
bullet rather than adding a new one. The reader should be able to scan this
file top-to-bottom and walk through a fresh demo without missing anything.
