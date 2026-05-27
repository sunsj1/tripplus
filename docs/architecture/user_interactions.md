# User Interactions

Every option / interaction a user can perform in the app, organized by surface. Use this as the **interaction inventory** when designing screens or QA-ing flows.

> Marked `🆕` items are new in Phase 1+; `(P2)`, `(P3)`, `(P4)` indicates which phase they ship.

---

## 0. Global gestures & shortcuts

| Gesture | What happens | Where |
|---|---|---|
| Swipe down on bottom sheet | Dismiss sheet | Anywhere with `showModalBottomSheet` |
| Pull to refresh | Refresh current list / stream | List screens (`StationsScreen`, `PoiCategoryScreen`) |
| Long-press POI marker on map | Open POI detail | Map views |
| Tap status bar | Scroll to top | List screens |
| Hold AI assistant FAB | Push-to-talk voice (P3) | Trip / Discover tabs |

---

## 1. Authentication & onboarding

| Action | Choices | Result |
|---|---|---|
| Sign in | Google / phone | Firebase Auth → AuthGate state changes |
| Set name | text input | Profile updated |
| Pick profile photo | gallery / skip | Profile updated |
| Grant location permission | Allow once / Allow always / Deny | Permission state persisted |
| Grant notification permission (Phase 1 `P1-027`) | Allow / Deny | Affects alert delivery in background |

---

## 2. Vehicle & Preferences setup (Phase 1 `P1-032`)

### Vehicle picker
- **Vehicle type** (single-select, required): Petrol · Diesel · EV · Bike
- **If EV**:
  - Connector types (multi-select): CCS2 · CHAdeMO · Type 2 AC · Bharat DC-001
  - Battery capacity (optional, kWh)
  - Fast chargers only? (toggle)
- **If Petrol/Diesel/Bike**:
  - Fuel efficiency (optional, kmpl)
  - Preferred fuel brand (chip select): BPCL · HPCL · IOCL · Shell · Reliance · None

### Preferences (multi-select chips)
- Pure veg
- Family mode
- Women-safe priority
- Pet friendly
- Night-safe stops only
- Scenic route preference
- Budget tier: Budget · Mid · Premium
- Dietary flags: Jain · Halal · Vegan (optional)

All changes auto-save; user can revisit from Profile tab (`P1-033`).

---

## 3. Plan tab

### Route input
- **From** location — text autocomplete (Google Places)
- **To** location — text autocomplete
- **Swap from/to** — single icon button
- **Use current location** — single tap → location services
- **Vehicle override** (chip) 🆕 — defaults to profile vehicle; tap to override for this trip
- **Trip preferences override** (chips) 🆕 — pre-checked from profile; can toggle off
- **"Plan trip"** button — disabled until both endpoints set

### Plan result view
- **Stat cards row** 🆕 — tap any card opens a detail sheet (e.g. tap Fuel → fuel-cost breakdown)
- **Smart Trip Timeline** 🆕
  - Tap a suggested stop → POI detail
  - **Pin** icon → adds to user's timeline (`P1-021`)
  - **Unpin** icon → removes
  - Drag-to-reorder pinned stops (Phase 2)
- **Quick Discover chips** 🆕 — jumps to `PoiCategoryScreen` for that category, pre-filtered to this trip's corridor
- **"Start trip"** button — transitions to Trip tab in active mode

---

## 4. Discover tab (Smart Intelligence Grid) 🆕 `P1-011`

### Grid screen
- 3-col grid of `PoiCategory` items.
- Tap any tile → `PoiCategoryScreen(category)`.
- (P2) **Hidden Gems** horizontal carousel above grid for active corridor.

### PoiCategoryScreen 🆕 `P1-012`
- **View toggle**: List ↔ Map
- **Filter chips**:
  - Common: `Open now` · `Highly rated (≥4.3)` · `With community pulses`
  - Category-specific: `Pure veg` (food), `Fast chargers` (EV), `Family-friendly` (washroom/hotel), etc.
- **Sort menu**: Distance ahead · Rating · Reliability score · Community freshness
- **List item interactions**:
  - Tap → POI detail
  - Tap pulse chip → opens community section
  - Tap pin icon → adds to current/draft trip timeline
  - Tap directions icon → external navigation (Google Maps deep link)
- **Map interactions**:
  - Tap marker → mini-card
  - Long-press marker → full POI detail
  - Cluster click → zoom in (P2 clustering: `P2-074`)

---

## 5. POI detail screen

- **Hero** — photo carousel (from Places + community photos)
- **Header** — name, distance ahead, rating, source badge
- **Community Section** (reused from existing `CommunityReportsSection`)
  - Reliability score + freshness + sample size
  - Conflict warning if mixed pulses (P2-031)
  - Pulse carousel
  - **"+ Add your pulse"** — opens report wizard
- **Action row**:
  - Pin to trip
  - Open in Maps
  - Call (if phone number)
  - Share
- **Attributes** — category-specific (washroom availability, EV connector list, parking type, etc.)

---

## 6. Trip tab — active trip 🆕 `P1-017`

### Active trip dashboard
- **Live progress bar** — km traveled / total
- **Next stop card** — name, distance, pulse, [Skip] [Directions]
- **Live timeline** — current step highlighted
- **Recent alerts** — scrollable list
- **"End trip"** button — opens summary

### Alert interactions
- **In-app banner**:
  - "Show on map" → centers map on triggering POI
  - "Snooze 30 min"
  - "Find alternative" → opens nearest POI of same category
  - Dismiss
- **Notification (background)**:
  - Tap → deep link to Trip tab + highlight POI

### AI Assistant FAB (P3)
- **Single tap** → chat sheet
- **Long press** → push-to-talk voice input

### Trip not active
- "Plan a trip" CTA → Plan tab

---

## 7. Community report wizard (bottom sheet, multi-step)

### Step 1 — Pulse
- Rating: 1–5 stars (tap)
- Condition: Working · Mixed · Down (toggle row)
- (P1-050+) Optional: Charge successful? Yes / No (EV only)

### Step 2 — Amenities
- Multi-select chips per category:
  - Stations: washroom · food · seating · safe at night · pet ok
  - Food: pure veg · family ok · clean washroom · women safe · kids menu
  - Washroom: clean · paid · accessible · baby change
  - Hotel: family ok · clean · safe parking · 24h reception
  - … (defined per `PoiCategory`)

### Step 3 — Photo (optional)
- Pick from gallery only (no camera capture in MVP — gallery is enough and matches existing flow)
- Hard limit: 5 MB pick → compressed → base64 (`P1-050` ensures POI photos too)
- Skip allowed

### Step 4 — Review
- Show summary
- Optional notes (text, 280-char cap)
- **Submit**

### Submission states
- ✅ Success → snackbar
- 🔴 Network → "Saved — will sync when online" (queued)
- 🔴 Permission → "Open settings"
- 🔴 Quota → "Too many recently, try later"

---

## 8. Profile tab

- View vehicle → edit
- View preferences → edit chips
- (P2) Trip history list
- (P2) Notification preferences screen
- (P2) Settings: units (km/mi)
- (P3) "What the assistant learned" → list + clear
- (P3) Privacy toggle: turn off AI memory
- (P4) Subscription status / upgrade CTA
- Sign out
- Delete account (cold path)

---

## 9. (P3) AI Copilot interactions

### Chat
- Type message → streaming response
- Quick-prompt chips above input:
  - "Next charger"
  - "Pure-veg ahead"
  - "Women-safe stop"
  - "Avoid bad roads"
  - "Scenic point"
  - "Narrate my trip"
- Tap a POI card in response → POI detail (real data, never fabricated)

### Voice
- Push-to-talk (hold FAB)
- Hands-free toggle on active trip (`P3-032`)
- Audio-only mode → assistant speaks the result

---

## 10. (P4) Premium gates

When a user hits a premium feature without subscription:
- Inline paywall sheet appears with:
  - What's included
  - Monthly / yearly toggle
  - Continue free / Upgrade

Premium gates (planned):
- Full AI assistant
- Offline maps download
- Advanced predictive alerts (Phase 2 set)
- Family-safety bundle
- Route recording / dashcam

---

## Interaction inventory checklist (for QA)

When a new feature ships, every new screen must answer:
- [ ] What does **tap** do on each visible element?
- [ ] What does **long-press** do?
- [ ] What does **swipe** do?
- [ ] What does **pull-to-refresh** do?
- [ ] What does **back gesture** do?
- [ ] What does each visible **CTA** do, including loading/error states?
- [ ] Is there an **a11y label** on every interactive element?
- [ ] Does **offline** state have a banner + degraded behavior?
