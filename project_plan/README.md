# JourneyPlus — Project Plan

This folder is the **single source of truth** for what we are building, in what order, and how progress is tracked.

> Product positioning: **JourneyPlus — India's Smart Highway Companion / AI Copilot for Road Trips**
> (Built on top of the existing EV-charging-assistant Flutter app, *not* a rewrite.)

---

## Files in this folder

| File | Purpose |
|---|---|
| `00_overview.md` | Strategic plan: why we extend instead of restart, phases, success metrics |
| `01_phase_1_mvp.md` | **Phase 1 — Smart Highway Companion MVP** (task IDs `P1-XXX`) |
| `02_phase_2_intelligence.md` | **Phase 2 — Predictive & Personalized Intelligence** (task IDs `P2-XXX`) |
| `03_phase_3_ai_copilot.md` | **Phase 3 — AI Travel Copilot** (task IDs `P3-XXX`) |
| `04_phase_4_scale.md` | **Phase 4 — Scale & Monetization** (task IDs `P4-XXX`) |
| `tasks.csv` | Notion-importable database (rows for every task ID across all phases) |
| `notion_tracker.md` | Pretty Notion page (toggle-style) — import as a page, not a database |
| `IMPORT_TO_NOTION.md` | How to import `tasks.csv` and `notion_tracker.md` into Notion |

---

## How task IDs work

Every task has a stable ID like **`P1-007`**:

- `P1` = phase (Phase 1 / 2 / 3 / 4)
- `007` = sequence within the phase

**When you complete a task, tell me the ID** (e.g. *"P1-007 is done"*) and I'll:
1. Mark it `Done` in `tasks.csv` and `notion_tracker.md`.
2. Update the phase markdown file's checklist.
3. Update `docs/context/current_state.md` if it materially changes the product surface.

---

## How to use this in day-to-day work

1. Open the current phase file (start with `01_phase_1_mvp.md`).
2. Pick the next task whose status is `Not started` and whose dependencies are `Done`.
3. Implement → mark complete → ping me with the ID.

---

## Sequencing rule of thumb

- **Phase 1 must ship in ~4–6 focused weeks.** It is the MVP from the PDF.
- **Do not skip ahead.** Phase 2 features assume Phase 1 data shapes; Phase 3 assumes Phase 2 ranking signals.
- **Status values**: `Not started` · `In progress` · `Done` · `Blocked` · `Cancelled`.

---

## Status legend

| Symbol | Meaning |
|---|---|
| ⬜ | Not started |
| 🟡 | In progress |
| ✅ | Done |
| 🚧 | Blocked |
| ❌ | Cancelled |
