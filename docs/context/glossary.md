# Glossary

Plain-English definitions of terms that appear across the codebase, plan, and docs.

| Term | Definition |
|---|---|
| **Corridor** | The polyline-defined journey from origin to destination plus a bounded width (default ~2–5 km either side). All discovery is bounded to this corridor. |
| **POI** | Point of Interest. A `Poi` domain entity covers any roadside place we surface — fuel pump, charger, restaurant, washroom, ATM, hotel, mechanic, scenic stop, temple, etc. |
| **`PoiCategory`** | Enum of the 16 grid categories from the PDF: `fuel`, `ev`, `restaurant`, `pureVeg`, `washroom`, `atm`, `hotel`, `medical`, `scenic`, `temple`, `kidsStop`, `mechanic`, `parking`, `cafe`, `tourist`, `police`. |
| **Pulse / Community report** | A short structured snapshot from a user about a stop — rating, condition, amenities, optional photo, optional notes. Stored in Firestore (`stationCommunityReports`). Immutable. |
| **Reliability score** | Weighted score over recent pulses (recency + reporter trust). Replaces plain average for prominent display. |
| **Confidence** | Sample size + freshness on a rating. Low-confidence badge fires when reports are stale or too few. |
| **Conflict-aware timeline** | UI that shows when recent pulses disagree (e.g. "working" vs "down") with a "mixed status" warning. |
| **Source badge** | One of `Official` · `Community-verified` · `Unverified` shown on every POI. |
| **`stationKey`** | Stable identity for community-keyed station data. Prefer `u_<uuid>`; else fallback `ocm_<id>_<lat5>_<lng5>`. Defined in `lib/features/community/domain/community_station_key.dart`. |
| **`poiKey`** | (Phase 1 `P1-010`) Stable identity for any POI, using the same pattern as `stationKey`. |
| **`targetKey`** | (Phase 1 `P1-050`) Generic name for either `stationKey` or `poiKey` in the community report schema, paired with `targetType: 'station' \| 'poi'`. |
| **Error taxonomy** | The 6 prefixes any repository must surface: `network`, `permission`, `index`, `firestore`, `platform`, `quota`. UI maps each to an actionable CTA. |
| **Offline submit queue** | Hive box that holds user writes (community report, preferences, trip save) that failed due to network; replayed by a retry runner. |
| **Foreground location tracking** | (Phase 1 `P1-042`) Opt-in location updates during an active trip via `geolocator` + Android foreground service. |
| **Corridor cache** | (Phase 1 `P1-043`) Hive cache of route polyline + first ~50 POIs per category for the active trip, so weak-network legs still work. |
| **Predictive alert** | Distance-or-time-ahead rule that fires *before* a problem. Phase 1 rules: fuel low, EV gap, food window. Phase 2: ghat, night, fatigue, weather. |
| **Alert thresholds (Wave 2)** | Fuel/EV gap **40 km**; food lookahead **50 km**; engine window **100 km**; night **22:00–05:00** local with stop ≤ **45 km**; fatigue every **3 h** continuous driving; per-type cooldown **20 min**. |
| **Family Mode / Women-Safe Mode / Bike Rider Mode** | (Phase 2) Global preference overlays that re-rank and filter POIs by mode-specific criteria. |
| **Hidden Gem** | Curated (or AI-curated in Phase 3) noteworthy stop per corridor — famous food, scenic, local specialty, underrated. |
| **Trip context packer** | (Phase 3 `P3-004`) The compact JSON of route + vehicle + preferences + recent alerts sent to the AI service on every call. |
| **AI Copilot** | (Phase 3) Chat + voice assistant that grounds answers in the trip context using tool-calling to the same `PoiRepository` and routing services the app uses. |
| **ADR** | Architecture Decision Record. One short markdown entry per significant decision. Lives in `docs/context/decisions.md`. |
| **Phase 1 / 2 / 3 / 4** | Roadmap phases from `project_plan/00_overview.md`. Task IDs use the phase prefix (e.g. `P1-007`). |
