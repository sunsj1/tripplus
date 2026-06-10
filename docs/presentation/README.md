# Presentation materials

Ready-to-use scripts, decks, and demo aids for showing TripPlus to people.

| File | Audience | Length | What it is |
|---|---|---|---|
| [`DEMO_SCRIPT_3MIN.md`](DEMO_SCRIPT_3MIN.md) | All audiences | 3:20 | Live walkthrough script — single-user story (Priya plans Mumbai → Pune) with every smart feature surfacing naturally |

## How to use this folder

- **Live demos.** Open `DEMO_SCRIPT_3MIN.md` on a second screen as presenter
  notes while you mirror the phone. The script tells you *what* to point at
  and *when*.
- **Investor pitches.** The "One-liner backup pitches" table near the end has
  one ready answer per audience type.
- **Internal onboarding.** Pair this with [`../SMART_FEATURES.md`](../SMART_FEATURES.md)
  for the full feature inventory.

## Adding more presentation materials

Drop new files into this folder and add a row to the table above. Suggested
formats:

- `DEMO_SCRIPT_<duration>MIN.md` — shorter or longer demo variants (90s, 5min, 10min)
- `INVESTOR_DECK_OUTLINE.md` — slide-by-slide notes for a pitch deck
- `TECHNICAL_TALK.md` — engineering-audience deep dive
- `CONFERENCE_TALK_<topic>.md` — talks at Flutter/Firebase/EV conferences

## Source of truth

These are presentation aids — the canonical product story lives in:

- [`../SMART_FEATURES.md`](../SMART_FEATURES.md) — feature inventory
- [`../PHASE_REPORTS.md`](../PHASE_REPORTS.md) — per-phase rollup
- [`../context/current_state.md`](../context/current_state.md) — what's shipped today

When the canonical files change at the end of a phase, sweep this folder for
talking points that need updating.
