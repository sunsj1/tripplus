# TripPlus — Master UI Generation Prompt

Use this file as the source-of-truth prompt for any AI UI generator (Stitch by Google, Figma AI, Galileo, v0, Uizard, Cursor, Lovable). Paste the relevant section verbatim — never paraphrase the design system.

---

## How to use this file

1. **Section 1 (Master Context)** is mandatory — paste it as the *first* message in any new chat with the UI tool. Pin it / save it as a system prompt if the tool supports that.
2. **Section 2 (Design System)** is mandatory in the same first message. The model needs the colors, type, components every time.
3. **Section 3 (Screen Briefs)** — paste *one* brief per generation. Don't ask for many screens in one go — each screen gets a focused turn.
4. **Section 4 (State Coverage)** — append to every screen brief so loading / empty / error / offline / low-confidence states are always produced.
5. **Section 5 (Quality Bar)** — append to every screen brief as the acceptance checklist.

For Stitch/Figma AI specifically: paste 1+2+4+5 once at the start, then iterate one screen at a time using briefs from Section 3.

---

# SECTION 1 — MASTER CONTEXT (paste first, every session)

You are a senior product designer designing **TripPlus — India's Smart Highway Companion**, a Flutter mobile app (Android + iOS, mobile-first, portrait). It is not a maps app. It is an **AI copilot for Indian road trips** that helps drivers plan, discover, and travel safely on Indian highways with multi-vehicle support (Petrol, Diesel, EV, Bike).

## Product principles (every screen must respect)

1. **Route-aware, not nearby.** Discovery is along the journey corridor, not radial distance.
2. **Predictive, not reactive.** Warn before fuel runs low, before the ghat begins, before fatigue sets in.
3. **Trustworthy under weak network.** Offline-first cues, cached states, retry CTAs.
4. **Reduce travel anxiety.** Calm visuals, generous spacing, clear hierarchy, no clutter, no jargon.
5. **India-first.** Family safety, women-safe stops, pure-veg, ghat sections, temples, FASTag are first-class concepts.
6. **Trust signals everywhere.** Every recommendation shows reliability score, sample size, freshness, and source badge (Official / Community-verified / Unverified).

## Personality and tone

- **Confident, calm, helpful.** Like a trusted local guide who has driven the route 100 times.
- **Plain Indian English.** Short sentences. No marketing fluff. Numbers are precise (e.g., "Last trusted pump for next 68 km", not "There may be a pump ahead").
- **Empathetic in alerts.** The driver might be tired, in a ghat, with kids in the back. Tone never panics them.
- **Sentence case** for headings and buttons (not Title Case, not ALL CAPS). Exception: brand wordmark.

## Target users

- Long-distance highway travelers (primary).
- EV owners.
- Families on road trips (women, kids, elderly in the car).
- Bike riders.
- Secondary: taxi drivers, tourists, logistics drivers.

## Platform constraints

- **Flutter Material 3**, light theme first (dark theme later — keep tokens themable).
- **Mobile portrait, 390 × 844 base canvas** (iPhone 13/14 reference). Layouts must adapt to 360 × 800 (small Android) and 430 × 932 (Pro Max).
- Bottom safe area for gesture bar; top safe area for notch / Dynamic Island.
- One-handed use is the norm — primary actions live in the lower 60% of the screen.

---

# SECTION 2 — DESIGN SYSTEM (paste first, every session)

This design system is locked. Do not invent new colors, type sizes, or radii. Use only the tokens below.

## 2.1 Brand identity

- **Wordmark:** "TripPlus"
- **Tagline:** "AI Copilot for Indian Road Trips"
- **Mood board keywords:** trust, calm, highway, India, premium-yet-friendly, dawn-light green.
- **Inspirations:** Google Maps' clarity, Linear's minimalism, Apple Maps' calm typography, Zomato's category icons, IRCTC's familiarity (but cleaner).

## 2.2 Color tokens (locked — use exact hex)

### Primary (deep highway green — wayfinding, primary CTAs)
- `primary`         `#1B5E20`
- `primaryLight`    `#2E7D32`
- `primaryDark`     `#0D3B10`
- `primarySurface`  `#E8F5E9`  ← chip / tag backgrounds
- `primarySurfaceLight` `#F1F8F2`

### Teal (onboarding, hero illustrations, EV accents)
- `teal`      `#00897B`
- `tealDark`  `#00695C`
- `tealLight` `#4DB6AC`

### Surfaces / background
- `background`        `#F5F7F5`  ← scaffold
- `surface`           `#FFFFFF`  ← cards, sheets
- `surfaceElevated`   `#FAFAFA`
- `cardGreenGradient` linear `#1B5E20 → #2E7D32` (top-left → bottom-right)
- `tealGradient`      linear `#00897B → #00695C` (top → bottom)
- `alertGradient`     linear `#C62828 → #B71C1C` (top-left → bottom-right)

### Status
- `success`        `#2E7D32` on `#E8F5E9`
- `warning`        `#F57F17` on `#FFF8E1`
- `error`          `#C62828` on `#FFEBEE`
- `errorDark`      `#B71C1C`

### Text
- `textPrimary`    `#1A1A1A`
- `textSecondary`  `#616161`
- `textTertiary`   `#9E9E9E`
- `textHint`       `#BDBDBD`
- `textOnPrimary`  `#FFFFFF`

### Borders / dividers
- `border`         `#E0E0E0`
- `borderLight`    `#F0F0F0`
- `divider`        `#EEEEEE`

### Bottom nav
- active `#1B5E20`, inactive `#9E9E9E`, background `#FFFFFF`

### Misc
- `shimmer`  `#E0E0E0`
- `overlay`  `#000000` at 50% opacity

## 2.3 Type scale (locked)

Font family: **SF Pro Display** (fall back to system: SF on iOS, Roboto on Android, Inter on web previews).

| Token       | Size | Weight | Line height | Letter-spacing | Use |
|---|---|---|---|---|---|
| `h1`        | 32   | 800    | 1.15        | -0.5           | Hero / splash |
| `h2`        | 26   | 700    | 1.20        | -0.3           | Screen title |
| `h3`        | 22   | 700    | 1.25        | 0              | Section title |
| `h4`        | 18   | 600    | 1.30        | 0              | Card title |
| `titleLarge`| 20   | 600    | 1.30        | 0              | Sheet title |
| `titleMedium`| 16  | 600    | 1.35        | 0              | List item title |
| `titleSmall`| 14   | 600    | 1.40        | 0              | Chip / tag label |
| `bodyLarge` | 16   | 400    | 1.50        | 0              | Body copy |
| `bodyMedium`| 14   | 400    | 1.50        | 0              | Secondary copy |
| `bodySmall` | 12   | 400    | 1.50        | 0              | Caption |
| `labelLarge`| 14   | 600    | 1.40        | 0.5            | Button label |
| `labelMedium`| 12  | 600    | 1.40        | 0.8            | Tab label |
| `labelSmall`| 10   | 600    | 1.40        | 1.0            | Badge label |
| `stat`      | 28   | 800    | 1.10        | 0              | Stat-card big number |
| `caption`   | 11   | 500    | 1.40        | 1.2            | Tiny caption |

Body uses `textSecondary` by default; titles use `textPrimary`.

## 2.4 Spacing scale (8-pt base)

`4 · 8 · 12 · 16 · 20 · 24 · 32 · 40 · 56`

- Screen horizontal padding: **16** (default), **20** for hero screens.
- Card internal padding: **16** all sides, **20** for hero cards.
- Section vertical gap: **24** between distinct sections.
- List item vertical padding: **12** with 16 horizontal.

## 2.5 Radii

- Cards / sheets: **16**
- Inputs / buttons: **14** for inputs, **16** for buttons
- Chips: **999** (pill)
- Modal sheet top corners: **24**
- Avatar / circular badges: 50% (pill / circle)

## 2.6 Elevation

- Default cards: **flat (elevation 0)**, distinguished by surface color and 1px `border` if needed.
- Floating Action Button: **elevation 4**, soft green shadow `rgba(27, 94, 32, 0.20)` y=8 blur=24.
- Bottom sheets: subtle scrim `overlay` plus 16dp top shadow.
- Snackbars: elevation 6, dark surface `#1A1A1A` with white text.

## 2.7 Iconography

- Use **Material Symbols Rounded** (filled when active state, outlined when default).
- For categories use friendly emoji-pictograms only on hero/grid tiles (⛽ ⚡ 🍴 🥗 🚻 🏨 🏧 👨‍👩‍👧 🩺 👮 🔧 ☕ 🌄 🛕 🅿 🧒 📸).
- Icon size: 20 (in body), 24 (in app bars), 28 (in grid tiles), 32 (hero).
- Do **not** use custom SVGs that don't exist in Material Symbols.

## 2.8 Buttons

| Variant | Spec |
|---|---|
| **Filled primary** | `primary` background, white text, 56h, radius 16, full-width by default |
| **Filled tonal**   | `primarySurface` background, `primaryDark` text, 56h, radius 16 |
| **Outlined**       | transparent background, `border` 1px, `textPrimary` text, 56h, radius 16 |
| **Text**           | no bg, `primary` text, used inline only |
| **Destructive**    | `error` background, white text, used in confirmation modals |
| **Floating Action**| 56 × 56 circular, `primary` bg, white icon, position bottom-right offset 16 |

Disabled state: `border` background, `textTertiary` text, no shadow.
Pressed state: 4% darken overlay.

## 2.9 Inputs

- Filled style, `surface` bg, `borderLight` 1px border.
- Focused border: `primary` 1.5px.
- Error border: `error` 1.5px with `errorSurface` background.
- 56h, padding 16h × 16v, radius 14.
- Hint: `textHint`. Label: floats above when focused or filled, `labelMedium`.
- Trailing icon for clear / autocomplete.

## 2.10 Chips (pill 999)

- **Filter chip (off):** `surface` bg, `border` 1px, `textSecondary` text, 36h.
- **Filter chip (on):** `primarySurface` bg, `primaryDark` text, no border.
- **Mode chip (Family / Women-Safe / Bike / Night):** 40h, with leading icon.
- **Status chip (Open now / Closed):** 28h, smaller, status-color tinted surface.
- **Confidence badge (Low / Medium / High):** 24h, `labelSmall`.

## 2.11 Cards

- **Surface card:** `surface` bg, radius 16, 16 padding, no border or 1px `borderLight`.
- **Stat card:** `surface` bg + tinted left border 4px (category color), large `stat` number, label below.
- **Gradient hero card:** `cardGreenGradient`, white text, 20 padding, radius 20.
- **POI card:** photo 96 × 96 left, content right, pulse chip + distance row, action row at bottom.

## 2.12 Bottom navigation

- 4 tabs in Phase 1: **Plan · Trip · Discover · Profile**
- Height 64 + safe-area, white bg, top hairline `divider`.
- Active label color `primary`, inactive `textTertiary`.
- Icon + label always visible (no hidden labels).

## 2.13 App bar

- Transparent background, `textPrimary` foreground.
- Title `h3` (22, 700), left-aligned, not centered.
- Trailing actions: max 2 icon buttons, 24px icons.
- No elevation when scrolled to top; only show 1px `divider` line when content scrolls under.

## 2.14 Bottom sheets

- Top corners radius 24, `surface` bg.
- 4 × 36 drag handle centered top, color `border`.
- Padding 20 horizontal × 24 vertical.
- Title row: `titleLarge` left, close icon right.
- Snap points: 50% (peek), 90% (full).

## 2.15 Dialogs / alerts

- Center modal, `surface` bg, radius 24, max width 320.
- Padding 24.
- Title `titleLarge`, body `bodyMedium`.
- Action row: 2 buttons (cancel outlined + confirm filled), 56h, full width stacked or side-by-side if short.
- Destructive confirm uses `error` filled button.

## 2.16 Snackbars / toasts

- Pinned 16 from bottom-nav top edge.
- Dark surface `#1A1A1A`, white text `bodyMedium`, radius 12, 12 vertical × 16 horizontal padding.
- Single-line by default; if 2 lines, max 2.
- Optional trailing action label in `tealLight` (e.g. "Retry", "Open settings").
- Auto-dismiss 4s for info, 6s for warnings, persistent for errors with action.

## 2.17 Banners (in-page non-modal)

- Full-width, 12 padding, radius 12.
- Variants: `info` (teal surface), `warning` (warningSurface), `error` (errorSurface), `offline` (warningSurface with cloud-off icon).
- Leading icon 20, body text 1–2 lines, optional trailing action button (text variant).

## 2.18 Loading states

- **Skeleton loaders** preferred over spinners on lists. Shimmer color `shimmer`, animated left-to-right.
- **Inline spinner**: 20–24 dot, `primary` color, used in buttons and small areas.
- **Full-screen calculating screen**: hero illustration, animated route polyline, status text below.
- **Pull-to-refresh**: standard Material indicator, `primary` color.

## 2.19 Empty states

- Centered, vertical layout: **illustration (160h) → title `titleLarge` → body `bodyMedium` → primary CTA**.
- Illustration uses brand colors only (no random stock art). Friendly, route-trip themed.
- Always offer a way out (CTA), never a dead end.

## 2.20 Error states (taxonomy → UI mapping)

The repository surfaces 6 error categories. Each has a fixed UI treatment:

| Category | Icon | Surface | Body copy template | Primary CTA |
|---|---|---|---|---|
| `network` | `wifi_off` | warning | "You are offline. We will retry when you are back online." | "Retry now" |
| `permission` | `lock_outline` | warning | "We need {permission} to do this." | "Open settings" |
| `index` | `hourglass_top` | info | "Catching up — try again in a moment." | "Try again" |
| `firestore` | `error_outline` | error | "Could not save right now." | "Try again" |
| `platform` | `bug_report` | error | "Something unexpected happened." | "Retry" |
| `quota` | `block` | warning | "Limit reached — wait a bit." | "OK" |

## 2.21 Trust signal patterns (mandatory wherever a rating shows)

- **Reliability score** (0–10) as the headline number.
- **Sample size** in parentheses: "(24 pulses)".
- **Freshness chip**: "3d fresh", "12h fresh", "stale" (warning color).
- **Source badge**: `Official` (primarySurface) · `Community-verified` (tealLight surface) · `Unverified` (border surface).
- **Conflict indicator** when recent reports disagree: yellow warning chip "Mixed status".
- **Low-confidence badge** when sample size < 3 or stale > 7 days.

## 2.22 Motion

- Page transitions: shared-axis Z, 250ms, ease-in-out.
- Sheet open: 300ms, decelerate.
- Snackbar: 200ms slide up, 200ms fade out.
- Skeleton shimmer: 1400ms loop.
- Map camera moves: 600ms, ease-in-out.
- No bouncy springs. Calm, deterministic.

## 2.23 Accessibility (mandatory)

- All tap targets minimum **48 × 48** logical px.
- Color contrast WCAG AA: `textPrimary` on `surface` ≥ 7:1, `textSecondary` ≥ 4.5:1.
- Every interactive element has a semantic label.
- Type scales with system text-size up to **130%** without overflow.
- Status / trust never communicated by color alone — always pair with icon or text.
- Form errors announced inline, not only by color.

## 2.24 Microcopy rules

- Buttons are verbs: "Plan trip", "Add pulse", "Start trip".
- Empty-state CTAs use first-person plural where helpful: "Let's plan your first trip".
- Numbers are precise: "Last trusted pump for next 68 km" (not "soon").
- Avoid jargon: say "pulse" only with one-line tooltip if first appearance.
- All distance shows km (Phase 2 will add unit setting).
- Times in 24h short form ("4h 30m"), or absolute ("8:42 PM").
- Dates: "Today", "Yesterday", "12 May".

---

# SECTION 3 — SCREEN BRIEFS (paste one per generation)

For every screen brief below, append **Section 4 (State Coverage)** and **Section 5 (Quality Bar)** so the generator produces every state, not just the happy path.

Screens are grouped by user flow. Each brief is self-contained but assumes Section 1 + 2 are already in the conversation.

## 3.0 Screen inventory (the full list)

The app needs every screen below. Generate them in this order:

### Onboarding & auth
- 3.1 Splash
- 3.2 Onboarding carousel (3 slides)
- 3.3 Permission primer (location + notifications)
- 3.4 Sign in
- 3.5 Phone OTP
- 3.6 Profile completion
- 3.7 Vehicle setup
- 3.8 Preferences setup

### Main shell
- 3.9 App shell with bottom nav (Plan / Trip / Discover / Profile)

### Plan flow
- 3.10 Plan tab — empty state
- 3.11 Plan input (origin, destination, vehicle, preferences)
- 3.12 Calculating route (loading)
- 3.13 Plan result — trip dashboard + smart timeline
- 3.14 Plan result — alternative routes comparison

### Discover flow (Smart Intelligence Grid)
- 3.15 Discover tab — Smart Intelligence Grid
- 3.16 POI category — list view
- 3.17 POI category — map view
- 3.18 POI category — filter sheet
- 3.19 POI detail screen

### Trip flow
- 3.20 Trip tab — no active trip (CTA)
- 3.21 Trip tab — active trip dashboard
- 3.22 Active trip — alert banner (in-app)
- 3.23 Active trip — map view
- 3.24 Trip summary

### Community flow
- 3.25 Community section (embedded on POI / station detail)
- 3.26 Community report wizard — Step 1 Pulse
- 3.27 Community report wizard — Step 2 Amenities
- 3.28 Community report wizard — Step 3 Photo
- 3.29 Community report wizard — Step 4 Review
- 3.30 All pulses screen

### Profile / settings
- 3.31 Profile tab — overview
- 3.32 Edit vehicle
- 3.33 Edit preferences
- 3.34 Trip history (Phase 2 placeholder)
- 3.35 Notification preferences
- 3.36 Settings (units, theme, account)
- 3.37 Sign out / delete account

### AI Copilot (Phase 3)
- 3.38 AI chat sheet
- 3.39 Voice mode (push-to-talk)
- 3.40 What I learned (memory transparency)

### Cross-cutting components
- 3.41 Snackbar variants (success, info, warning, error, offline-queued)
- 3.42 Dialog variants (confirm, destructive, info)
- 3.43 Bottom sheet patterns (filter, action, picker)
- 3.44 In-app banners (offline, low-confidence, ghat warning)
- 3.45 Empty / error / loading state library

---

## 3.1 Splash

**Purpose:** First frame after app launch, while Firebase + Hive boot.
**Duration:** 600–1200ms.

**Layout:**
- Full-screen `tealGradient` background.
- Centered: TripPlus wordmark in white `h1`, then tagline "AI Copilot for Indian Road Trips" in `bodyLarge` white at 80% opacity.
- A subtle animated highway-line illustration at the bottom (white at 30% opacity), pulsing.
- No interactive elements.

**States:** single state. No skeletons (it is itself a loading screen).

---

## 3.2 Onboarding carousel (3 slides)

**Purpose:** Communicate the three product principles before sign-in.

**Layout:**
- Top: progress dots (3), `primary` filled for current.
- Hero illustration 240h, brand-colored, simple flat style:
  - Slide 1: highway with route polyline + small POI icons along it.
  - Slide 2: alert bell with "68 km" badge.
  - Slide 3: family + EV + petrol pump icons clustered on a pulse.
- Title `h2` (sentence case) below illustration:
  - Slide 1: "Smart highway intelligence"
  - Slide 2: "Predictive alerts before problems"
  - Slide 3: "Trusted by drivers like you"
- Body `bodyLarge` 2 lines max under title.
- Bottom: "Skip" text button left, "Next" filled primary right; final slide "Get started" full-width filled.
- Swipeable horizontally + dots tappable.

---

## 3.3 Permission primer

**Purpose:** Explain why we need location + notifications **before** OS dialog.

**Layout:**
- App-bar: back chevron only, no title.
- Hero icon 96 (location pin in `primary`).
- Title `h2` "We need a couple of permissions"
- Two cards stacked, each with leading icon, title, body, and an OS-permission status pill ("Not granted").
  - Location: "So we can show stops along your route, even without typing addresses."
  - Notifications: "So predictive alerts reach you while driving."
- Bottom CTA: "Continue" filled primary. "Maybe later" text button below.

---

## 3.4 Sign in

**Layout:**
- Top: logo + tagline.
- Body: vertical stack of auth buttons (each 56h, 16 gap):
  - "Continue with Google" — outlined with Google logo
  - "Continue with phone" — filled primary
- Below: tiny legal copy "By continuing you agree to our Terms and Privacy" with two inline text-button links.
- No password field anywhere.

---

## 3.5 Phone OTP

- Step 1: phone input with `intl_phone_field` country selector, "Send code" filled primary.
- Step 2: 6-digit OTP boxed input, "Resend in 0:30" countdown, "Verify" filled primary, change-number text button.
- Inline error chip if code wrong.

---

## 3.6 Profile completion

Inputs: avatar (tap to pick), name, optional bio (skipable). "Save" filled primary.

---

## 3.7 Vehicle setup

**Step indicator:** "Step 1 of 2" small label top.

**Layout:**
- Title `h2` "Pick your vehicle".
- 2 × 2 grid of large vehicle cards (each 160h):
  - ⛽ Petrol · 🛢 Diesel · ⚡ EV · 🏍 Bike
  - Selected card uses `primarySurface` bg + 2px `primary` border + check badge.
- Conditional sub-form that appears below grid based on selection:
  - **EV:** connector multi-select chips (CCS2 / CHAdeMO / Type 2 AC / Bharat DC-001), battery kWh input (optional), "Fast chargers only" toggle.
  - **Petrol/Diesel/Bike:** fuel efficiency kmpl input (optional), preferred fuel-brand chips (BPCL / HPCL / IOCL / Shell / Reliance / None).
- Bottom CTA: "Continue" filled primary.

---

## 3.8 Preferences setup

**Step indicator:** "Step 2 of 2".

**Layout:**
- Title `h2` "Tell us what matters to you".
- Subtitle `bodyLarge` "We will use these to personalize your trips. Change anytime in Profile."
- Multi-select chip cloud, grouped under tiny labels:
  - Food: 🥗 Pure veg · 🍴 Family-friendly · 🐂 Halal · 🌿 Vegan · 🪷 Jain
  - Safety: 👨‍👩‍👧 Family mode · 👩 Women-safe priority · 🌙 Night-safe stops · 🐕 Pet-friendly
  - Drive: 🌄 Scenic route · ⚡ Fast chargers only
  - Budget: 💰 Budget · ⚖ Mid · ✨ Premium (single-select segmented)
- Bottom: "Save and continue" filled primary, "Skip" text button (will use defaults).

---

## 3.9 App shell

- Bottom nav, 4 tabs: Plan (route icon) · Trip (timeline icon) · Discover (grid icon) · Profile (person icon).
- Persistent FAB on Trip + Discover tabs (Phase 3 AI assistant) — show as a floating circle with sparkle icon, off-screen for Phase 1 mockup but design the placeholder.
- Tab change uses fade + 4px upward translation.

---

## 3.10 Plan tab — empty state

- Hero illustration 200h: dotted route from "A" to "B" pin.
- Title `titleLarge` "Where to next?"
- Body "Tell us your origin and destination — we will plan a smart trip."
- Filled primary "Plan a trip" full-width. Recents row below (chips of last 3 trips) when available.

---

## 3.11 Plan input

**Layout (top to bottom):**
- App bar: title "Plan a trip", trailing close icon.
- **Route card** (radius 16, surface, 16 padding):
  - Origin field with leading green dot + autocomplete dropdown.
  - Vertical hairline connecting origin → destination dots.
  - Destination field with leading red flag + autocomplete.
  - Trailing swap-icon button between the two fields.
  - "Use current location" inline text-button under origin if empty.
- **Vehicle row** (chip group): currently selected vehicle as a leading mode chip with edit pencil; tap → opens vehicle picker bottom sheet.
- **Preferences row** (horizontally scrollable filter chips): pre-checked from profile, tap to toggle off for this trip; trailing "+ More" chip opens full preference sheet.
- Sticky bottom: "Plan trip" filled primary (disabled until both origin + destination set).

---

## 3.12 Calculating route

**Layout:**
- Centered: animated route polyline drawing on a faint India-shape backdrop.
- Below: title "Planning your trip" `titleLarge`, then status line that updates:
  - "Finding the best route…" → "Looking for fuel stops along the corridor…" → "Checking community pulses…"
- Estimate chip "Usually takes 3–5 seconds".
- No back button (auto-pops on completion / failure).
- Failure → snackbar with retry.

---

## 3.13 Plan result — trip dashboard + smart timeline

This is one of the **two iconic screens** of the app. Treat it with care.

**Layout (top to bottom, scrollable):**
1. **Hero gradient card** (`cardGreenGradient`, 20 padding, radius 20):
   - Top row: small mode chip "🚗 Petrol · 👨‍👩‍👧 Family" in white-tinted glass.
   - Title `h2` white "Pune → Nashik"
   - Subtitle `bodyLarge` white at 80% "Sunday, 12 May · 8:42 AM"
   - Bottom row: 4 inline stats with white labels and big white numbers — Distance / ETA / Fuel cost / Tolls.
   - Trailing edit pencil top-right that returns to Plan input.
2. **Stat-cards row** (horizontally scrollable, 4 cards 140 × 96 each):
   - 215 km · 4h 30m · ₹980 fuel · ₹180 tolls
   - Phase 2: weather chip ☁ partly cloudy.
3. **Smart Trip Timeline** section title `titleLarge` "Smart timeline".
   - Vertical timeline, alternating left-icon + right-card pattern.
   - Each stop card: photo 80, name, distance from previous stop + cumulative km, pulse chip, action row (📍 Pin / 🗺 Directions).
   - First node: green start pin "Origin". Last: red flag "Destination".
   - Add-stop button between any two nodes (small + chip).
4. **Quick Discover** chips row: ⛽ Fuel · 🍴 Food · 🚻 Washrooms · 🏨 Hotels (tappable, pre-filtered to corridor).
5. Sticky bottom: "Start trip" filled primary, full width.

---

## 3.14 Plan result — alternative routes

- Tabs at top "Recommended · Fastest · Scenic · Cheapest".
- Each tab shows: small map preview (140h), 4 stat chips, "Why we picked this" explainer line, "Use this route" filled tonal button.

---

## 3.15 Discover tab — Smart Intelligence Grid

This is the **other iconic screen**.

**Layout:**
- App bar: title "Discover", trailing search icon.
- Sticky context strip below app bar: "Pune → Nashik · 215 km" with a "View trip" outlined button at right.
- Grid 3 columns, gap 12, padding 16. 16 tiles total. Each tile is square, radius 16, surface bg, 1px borderLight, padding 12:
  - Top: large emoji-pictogram (28).
  - Bottom: label `titleSmall`.
- Tap → POI category screen.
- Above grid (Phase 2 placeholder): horizontal "Hidden gems on this route" carousel with 4 mini-cards.

---

## 3.16 POI category — list view

Generate one example for Restaurants. The same template fits any category.

**Layout:**
- App bar: back, title "Restaurants on route", trailing map-toggle icon.
- Sticky filter bar below: horizontally scrolling chips (Open now · Pure veg · Highly rated · Family-friendly · With pulses) + trailing "Sort" chip with current sort label.
- List of POI cards (radius 16, padding 12):
  - Left: photo 80 × 80 radius 12.
  - Right column:
    - Title `titleMedium` (1 line, ellipsis).
    - Sub: `bodySmall` "Veg · ₹₹ · 28 km ahead".
    - Pulse row: small green dot + "8.4 reliability · 24 pulses · 3d fresh" + "Mixed status" warning chip if conflicted.
    - Action row: "📍 Pin to trip" text button + "🗺 Directions" text button.
- Tap card → POI detail.

---

## 3.17 POI category — map view

- Full-screen Google Map placeholder.
- Markers per POI in category-color.
- Bottom peek sheet (snap 30%) showing the same list, swipe up for full list.
- Top toolbar: back, title, trailing "List" toggle.
- Pinch + cluster behavior; tap marker → mini-card popover with "Open detail" CTA.

---

## 3.18 POI category — filter sheet

- Bottom sheet 90% snap, drag handle.
- Sections: "Open" toggle · "Min rating" stepper · "Distance ahead" slider 5–200 km · category-specific chips (e.g. for Food: pure veg, family ok, kids menu, women-safe).
- Sticky bottom row: "Reset" outlined left, "Apply (n)" filled primary right.

---

## 3.19 POI detail

**Layout:**
1. **Hero** — photo carousel 240h with paging dots; back + share icons floating.
2. **Header card**:
   - Title `h3` (POI name).
   - Sub `bodyMedium` "28 km ahead · 12 min via NH-60".
   - Source badge + reliability chip + freshness chip in a row.
3. **Action row** (4 icon-buttons in a row): Pin to trip · Directions · Call · Share.
4. **Community Section** (embedded — see 3.25).
5. **Attributes** card: category-specific (washroom: clean / paid / accessible / baby-change checkboxes-as-chips; EV: connector list with availability dots).
6. **About** card: address, hours table, phone, attribution to source.

---

## 3.20 Trip tab — no active trip

- Empty state. Hero illustration 200h (clock + steering wheel).
- Title "No trip in progress".
- Body "Plan a trip first to see live alerts, timeline, and stops here."
- "Plan a trip" filled primary CTA.

---

## 3.21 Trip tab — active trip dashboard

**Layout:**
- App bar: title "Live trip", trailing menu (•••).
- **Live progress card** (gradient): big km counter "78 / 215 km", thin progress bar, ETA "in 3h 02m".
- **Next stop card**: photo + name + distance "12 km" + pulse + "Skip" outlined / "Directions" filled tonal.
- **Recent alerts** stack (max 3, link to all): each is a banner-style row with icon + 1-line copy + dismiss.
- **Live timeline** (collapsed by default, expand on tap): same widget as 3.13 but shows current step glowing.
- Sticky bottom: "End trip" outlined destructive (red text on surface).

---

## 3.22 Active trip — alert banner (in-app)

A non-modal banner that appears top of screen on top of any tab during active trip.

- 64h, full width, slides from top with bounce-free decel.
- Variants by severity:
  - **Info** (teal surface): "Highly-rated veg restaurant in 8 km."
  - **Warning** (warning surface): "Last trusted pump for next 65 km."
  - **Critical** (error surface): "No EV charger ahead for 91 km."
- Trailing actions: "Show" text + dismiss icon.
- Auto-dismiss after 8s unless critical.

---

## 3.23 Active trip — map view

Full-screen map. Active route polyline `primary`. Driver dot blue with pulse. POI markers along corridor. Bottom card collapses to a peek showing next stop. Top floating chip: "65 km to next stop".

---

## 3.24 Trip summary

End-of-trip recap.

- Header: confetti illustration + "Trip complete!" `h2`.
- Stats grid 2 × 2: distance, time, stops made, alerts received.
- Section "Rate your stops" — quick-pulse rows with 5-star tap and yes/no working.
- Section "Save trip" — "Name this trip" input + Save filled primary.

---

## 3.25 Community Section (embedded)

Used inside POI detail and station detail.

**Layout:**
- Section title `titleLarge` "Community" with right-aligned "See all" text button.
- Reliability headline row: big number `stat` "8.4" + "/ 10" small + sample chip "(24 pulses)" + freshness chip "3d fresh".
- Conflict warning banner if mixed.
- Vertical carousel of 3 most recent pulses (mini cards 280 wide if horizontal): avatar, name, time-ago, rating stars, 1-line note, optional photo thumbnail.
- "+ Add your pulse" filled tonal full-width.

---

## 3.26 Community report wizard — Step 1 Pulse

Bottom sheet 90% snap.

- Step indicator: "1 of 4" + tiny progress bar.
- Title "How is this stop right now?"
- 5-star tap row (size 40).
- Condition segmented: Working · Mixed · Down (with helper icons).
- (EV only) Toggle: "Did you successfully charge here?"
- Bottom sticky: "Back" outlined disabled · "Continue" filled primary.

---

## 3.27 Community report wizard — Step 2 Amenities

- Title "What's available?"
- Multi-select chip cloud grouped by sub-section (washroom / food / safety / family / EV-specific). Pre-checked chips from POI's known attributes.
- Same bottom action row.

---

## 3.28 Community report wizard — Step 3 Photo

- Title "Add a photo (optional)"
- Big tappable area with dashed border, "Pick from gallery" + leading image icon.
- After pick: thumbnail preview 200h with "Remove" text button + size chip "1.2 MB" + "Will be compressed to ~200 KB" helper copy.
- "Skip" text button left of "Continue".

---

## 3.29 Community report wizard — Step 4 Review

- Title "Look good?"
- Summary card: rating, condition, amenities chip cloud (compact), photo thumbnail.
- Optional notes textarea (280 chars cap, counter visible).
- Bottom: "Back" outlined · "Submit pulse" filled primary.
- After submit:
  - Success → bottom sheet collapses, success snackbar (see 3.41).
  - Network failure → "Saved — will sync when online" warning snackbar.

---

## 3.30 All pulses screen

Full screen list of every pulse for a POI.

- Sticky filter bar: Latest · Reliable users · With photos · With price.
- Each row: avatar + name, rating stars, time ago, condition chip, body text, optional photo, helpful-vote count.
- Empty: "No pulses match these filters" + "Clear filters" text button.

---

## 3.31 Profile tab — overview

**Layout:**
- Header card (gradient `tealGradient`, 20 padding):
  - Avatar 64 left.
  - Name `h3` white, vehicle line "🚗 Petrol · 18 kmpl" `bodyMedium` white 80%.
  - Trailing edit pencil.
- Section list (each 56h tappable row, leading icon, trailing chevron):
  - Vehicle
  - Preferences
  - Trip history (Phase 2 chip "Coming soon")
  - Notifications
  - What I learned (Phase 3, hidden in Phase 1)
  - Settings
- Footer: "Sign out" text button (textSecondary) and "Delete account" text button (error).
- Tiny version line at very bottom: "TripPlus v1.0.0".

---

## 3.32 Edit vehicle

Same component as 3.7 but no step indicator and a Save filled-primary at bottom.

## 3.33 Edit preferences

Same as 3.8 with no step indicator. Auto-save on toggle, with a tiny "Saved" toast.

## 3.34 Trip history (Phase 2 placeholder)

Empty placeholder for Phase 1: hero "Coming in Phase 2" with locked badge.

## 3.35 Notification preferences

List of toggles grouped:
- Trip alerts (master toggle)
  - Fuel low / EV gap / Food window / Ghat / Night / Fatigue / Weather (each with description)
- Quiet hours (range picker)
- Vibration only (toggle)

## 3.36 Settings

Sectioned list:
- Units (km / mi segmented)
- Theme (System / Light / Dark — Phase 2)
- Language (English / Hindi — Phase 2 placeholder)
- Privacy (toggles for analytics + AI memory in Phase 3)
- Account (email, sign out, delete)
- About (version, terms, privacy policy, attributions)

## 3.37 Sign out / delete account

- Sign out: dialog "Sign out?" + "Cancel" / "Sign out" destructive.
- Delete: 2-step confirmation with typed-in confirmation phrase ("DELETE"), explicit warning about data deletion timeline.

---

## 3.38 AI Chat sheet (Phase 3)

Bottom sheet 90% snap, drag handle.

- Conversation list with chat bubbles:
  - User: filled primary surface, white text.
  - Assistant: surface card, bordered, with leading sparkle icon.
  - POI cards rendered inline within assistant turns (mini POI card with pulse + "Open detail" text button).
- Sticky input bar at bottom: text field + mic icon + send arrow.
- Above input: horizontal quick-prompts chip row "Next charger · Pure-veg ahead · Women-safe stop · Avoid bad roads · Scenic point · Narrate my trip".

## 3.39 Voice mode

- Full-screen modal, dark green gradient.
- Centered animated mic with audio waveform.
- Status text: "Listening… say a request" → "Thinking…" → "Speaking".
- Tap-anywhere to cancel; bottom "Done" text button.

## 3.40 What I learned (memory)

List of learned-preferences cards: "We have noticed you prefer BPCL pumps · learned 8 May" with "Forget this" trailing icon. Top: master "Turn off learning" toggle and "Clear all" destructive button.

---

## 3.41 Snackbar variants

Generate one frame per variant, all stacked for review:

1. **Success** — "Pulse submitted" — checkmark leading, no action.
2. **Info** — "Trip saved" — info leading, "Undo" trailing action.
3. **Warning offline-queued** — "Saved — will sync when online" — cloud-off leading, no action.
4. **Error retry** — "Could not load stops" — error leading, "Retry" trailing action.
5. **Permission needed** — "Location is off" — lock leading, "Open settings" trailing action.

## 3.42 Dialog variants

1. **Confirm action** — "End trip now?" body "You have 137 km remaining." actions: Cancel / End trip (filled).
2. **Destructive** — "Delete account?" body explains consequences, action: Cancel / Delete (destructive filled).
3. **Info** — "About reliability score" with explanatory body, action: Got it (filled).
4. **Permission rationale** — re-prompt explaining a permission with primary "Open settings" + secondary "Not now".

## 3.43 Bottom sheet patterns

1. **Filter sheet** — see 3.18.
2. **Action sheet** — list of icon + label rows for "Share", "Pin to trip", "Open in Maps", "Report issue".
3. **Picker sheet** — vehicle picker (4 cards), brand picker (chip cloud).

## 3.44 In-app banners

1. **Offline** — top banner "You are offline · using cached corridor data" + Retry text action.
2. **Low confidence** — inline banner inside community section "Few pulses yet — show your driving sense and add one" + "Add pulse" tonal button.
3. **Ghat warning** (Phase 2 visual) — warning banner "Mountain section ahead — fuel up now".
4. **Fatigue warning** (Phase 2 visual) — warning banner "You have been driving 3 hours. Suggested rest stop in 6 km."

## 3.45 Empty / error / loading state library

Generate a single Figma frame that is a 4-column reference sheet:

- **Loading**: skeleton list (3 rows), full-screen calculating, inline spinner button.
- **Empty**: no trips, no POIs in category, no pulses, no search results.
- **Error**: network, permission, index, firestore, platform, quota — one frame per category.
- **Offline**: degraded list with cached chip + offline banner.

---

# SECTION 4 — STATE COVERAGE (append to every screen brief)

For the screen above, also produce these states as separate frames in the same canvas:

1. **Default / happy path** — populated with realistic Indian highway data:
   - Sample trip Pune → Nashik (215 km, 4h 30m).
   - Sample POIs: "Hotel Sai Pure Veg", "HP Petrol Pump Talegaon", "Tata Power EV Charger NH-60", "Sangamner Scenic Viewpoint", "Reliance Smart Mart Sinnar".
   - Sample user: "Suraj Jadhav", Petrol, 18 kmpl, BPCL preferred, family mode on.
2. **Loading** — skeleton placeholders matching the layout exactly (no spinners on lists).
3. **Empty** — friendly illustration + helpful CTA, never a dead end.
4. **Offline** — top offline banner + cached badge on stale items.
5. **Low confidence** — wherever ratings appear, show one with sample size 2 and stale 14d so the warning treatment is visible.
6. **Error states** — at minimum produce `network` and `permission` variants. For data screens add `firestore` and `quota`.
7. **Success snackbar overlay** — a frame showing the screen with the success snackbar from 3.41.
8. **Dark mode** — Phase 1 light only. If you do generate dark, use surfaces `#0F1410`, `#161D17`, text `#F5F7F5` / `#A8B0A9`, primary `#66BB6A`. Otherwise skip.

---

# SECTION 5 — QUALITY BAR (append to every screen brief)

The screen passes only if every item is true:

- [ ] Uses **only** color tokens from Section 2.2. No off-palette hex.
- [ ] Uses **only** type tokens from Section 2.3. No arbitrary font sizes.
- [ ] Spacing is from the 8-pt scale in Section 2.4.
- [ ] Radii are from Section 2.5 (16 cards, 14 inputs, 24 sheets, 999 chips).
- [ ] Every interactive element is at least **48 × 48** logical px.
- [ ] Every rating shows reliability score + sample size + freshness + source badge (Section 2.21).
- [ ] Errors map to one of six taxonomy categories (Section 2.20) with the exact CTA.
- [ ] Empty states include a forward CTA (no dead ends).
- [ ] Offline banner is placed and styled per Section 2.17 when relevant.
- [ ] Microcopy follows Section 2.24 — sentence case, verbs in buttons, precise numbers, no jargon.
- [ ] Layout works at 360 × 800 (small Android) and 430 × 932 (Pro Max).
- [ ] Type scales to 130% without overflow.
- [ ] No icon-only actions without a `tooltip` / aria label equivalent.
- [ ] Status / trust never communicated by color alone — always paired with icon or text.
- [ ] Components are **renamed and grouped** in the Figma layers panel using this convention:
  - Frame name: `Screen / <Flow> / <Screen Name> / <State>` e.g. `Screen / Plan / Plan Result / Default`.
  - Components: `Component / <Category> / <Name>` e.g. `Component / Card / POI Card`.
- [ ] Auto-layout is used everywhere; no free-floating absolute frames.

---

# SECTION 6 — PROMPT-CHAINING PLAYBOOK (so context never drifts)

UI generators forget context after a few turns. Use this protocol:

## A. First message in any new chat

Paste this header, then Section 1 + Section 2 + Section 4 + Section 5, then your first screen brief from Section 3.

```
ROLE
You are a senior product designer. Output: Figma frames using auto-layout, named per Section 5. Do not invent tokens. Do not hallucinate features beyond Section 1.

DESIGN BRIEF
[paste Section 1 — Master Context]
[paste Section 2 — Design System]
[paste Section 4 — State Coverage]
[paste Section 5 — Quality Bar]

FIRST SCREEN
[paste a single brief from Section 3, e.g. 3.13 Plan result]

OUTPUT
- One Figma page named "Plan / Plan Result"
- Frames: Default, Loading, Empty, Offline, LowConfidence, Error_Network, Error_Permission, SuccessSnackbar.
- All frames mobile portrait 390 × 844.
- Layers named per Section 5 convention.
```

## B. Subsequent messages in the same chat

Use the short re-anchor:

```
Continue in the same TripPlus design system. Do NOT change any tokens.

NEXT SCREEN
[paste next brief from Section 3, e.g. 3.15 Discover]

Output the same set of state frames as before plus any state-specific frames called out in the brief.
```

## C. If the model drifts

Paste this correction:

```
You drifted off the design system.
Reset to Section 2 tokens exactly. Specifically:
- Primary is #1B5E20 (not #2E7D32 alone, not blue).
- Card radius is 16, button radius 16, input radius 14, chip radius 999, sheet 24.
- Type family is SF Pro Display with the exact scale in Section 2.3.
Re-render the previous screen with these tokens.
```

## D. When asking for a component (not a screen)

Use this template:

```
Build the following component, in 4 states (default, hover/pressed, disabled, focused):

COMPONENT
[name + role from Section 2.x]

CONSTRAINTS
[paste only the relevant subsection of Section 2, e.g. 2.10 Chips]
[paste Section 5 Quality Bar]

OUTPUT
- One frame per state, all 360w max.
- Auto-layout, padding from 8-pt scale.
- Variants set up in Figma so I can swap states from the right panel.
```

## E. When you want a flow (multi-screen storyboard)

```
Build a storyboard frame for the [Plan flow] showing:
1. 3.10 Plan tab empty
2. 3.11 Plan input filled
3. 3.12 Calculating
4. 3.13 Plan result
5. 3.21 Active trip dashboard (if user taps Start trip)

Each screen 390 × 844, laid out left-to-right with 80px gap, arrow connectors between them.
Same design system as before. State frames not needed here — only the happy path.
```

---

# SECTION 7 — DELIVERABLES CHECKLIST

By the end of the design phase you should have these Figma pages:

1. **00 — Cover** (one frame, brand wordmark + summary)
2. **01 — Design system** (color tokens, type scale, spacing scale, components grid for buttons / inputs / chips / cards / sheets / banners / snackbars / dialogs)
3. **02 — Onboarding & Auth** (3.1–3.8)
4. **03 — Plan flow** (3.10–3.14)
5. **04 — Discover flow** (3.15–3.19)
6. **05 — Trip flow** (3.20–3.24)
7. **06 — Community flow** (3.25–3.30)
8. **07 — Profile & Settings** (3.31–3.37)
9. **08 — AI Copilot** (3.38–3.40, Phase 3 — can be wireframe quality)
10. **09 — States library** (3.41–3.45)
11. **10 — Storyboards** (one per flow, happy path only)

Every page uses the same set of color and text styles registered as **Figma local styles**, and components are published as a **Figma library** for reuse in v2.

---

# SECTION 8 — WHAT NOT TO DO (anti-patterns)

- ❌ Do not use raw `Colors.blue` / `red` / random Material palettes — use only Section 2 tokens.
- ❌ Do not use centered titles in app bars (we are left-aligned).
- ❌ Do not use card elevation — surfaces are flat with optional 1px borders.
- ❌ Do not use ALL CAPS labels except `caption` and `labelSmall` letter-spacing-only treatments.
- ❌ Do not use stock photos for empty states. Brand-colored vector illustrations only.
- ❌ Do not show a rating without sample size + freshness — that is a product principle, not a polish.
- ❌ Do not show "Map" or "Maps" branding language — we are not a maps app.
- ❌ Do not put primary actions in the top app bar — bottom sticky bar is canonical.
- ❌ Do not invent extra tabs in the bottom nav. Only 4: Plan / Trip / Discover / Profile.
- ❌ Do not hide labels under bottom-nav icons — labels are always visible.
- ❌ Do not use a hamburger menu. Use the Profile tab.
- ❌ Do not skip empty / error / offline states in any handoff.

---

# QUICK COPY TEMPLATES

## Template — first message of a new design session

> You are a senior product designer for **TripPlus — India's Smart Highway Companion** (Flutter mobile, multi-vehicle road-trip copilot, not a maps app).
>
> Use this design system exactly:
>
> **Colors:** primary `#1B5E20`, primarySurface `#E8F5E9`, teal `#00897B`, error `#C62828`, warning `#F57F17`, success `#2E7D32`, surface `#FFFFFF`, background `#F5F7F5`, textPrimary `#1A1A1A`, textSecondary `#616161`, border `#E0E0E0`.
>
> **Type:** SF Pro Display. h1 32/800, h2 26/700, h3 22/700, h4 18/600, titleMedium 16/600, bodyLarge 16/400, bodyMedium 14/400, labelLarge 14/600.
>
> **Radii:** cards 16, inputs 14, buttons 16, chips 999, sheets 24.
>
> **Spacing scale:** 4 / 8 / 12 / 16 / 20 / 24 / 32 / 40.
>
> **Shell:** bottom nav with 4 tabs — Plan, Trip, Discover, Profile.
>
> **Trust UX rule:** every rating shows reliability score + sample size + freshness + source badge (Official / Community-verified / Unverified).
>
> Generate the screen below in **390 × 844** mobile portrait. Produce frames for: Default, Loading, Empty, Offline, Error_Network, Error_Permission. Use auto-layout. Layer naming: `Screen / <Flow> / <Name> / <State>`.
>
> SCREEN: [paste one brief from Section 3]

## Template — single-screen request (mid-session)

> Same TripPlus design system. Same tokens.
>
> SCREEN: [paste brief]
>
> States: Default + Loading + Empty + Offline + Error_Network.

## Template — fix-up request

> Same TripPlus design system. The previous screen used wrong tokens.
> Reset:
> - primary `#1B5E20` only
> - card radius 16, button radius 16
> - SF Pro Display type scale exactly as defined
> - bottom nav 4 tabs Plan / Trip / Discover / Profile
> Re-render the previous screen.


