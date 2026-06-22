# How to import this plan into Notion

You have **two** Notion-ready files. Use them for different views.

| File | Notion treats it as | Best for |
|---|---|---|
| `tasks.csv` | **Database** (table) | Filtering, grouping, status changes, kanban view |
| `notion_tracker.md` | **Page** with live checkboxes | Quick reading + ticking off completed tasks |

You don't have to pick one — import **both**. They share the same task IDs (`P1-001`, etc.) so you can cross-reference.

---

## Option A — Import `tasks.csv` as a database (recommended for tracking)

This gives you a real Notion database with filters, sorts, kanban view by status, etc.

1. Open Notion → choose the workspace/parent page where JourneyPlus should live.
2. Click **`+ Add a page`** (or open an existing parent page).
3. Inside the page, type `/import` and select **Import**.
4. Choose **CSV**.
5. Pick `project_plan/tasks.csv` from this repo.
6. Notion will create a new **database** in the page with these properties:
   - `ID` (text) → set this as the primary/title column if you want
   - `Task` (text)
   - `Phase` (select)
   - `Section` (select)
   - `Priority` (select: P0 / P1 / P2)
   - `Status` (select: Not started / In progress / Done / Blocked / Cancelled)
   - `Estimate` (text)
   - `Dependencies` (text — semicolon-separated IDs)
   - `Tags` (multi-select — semicolon-separated)
   - `Notes` (text)

### After import — recommended views

In the imported database, click **`+ Add view`** and create:

- **By Phase** — Group by `Phase`, sort by `ID` ascending. *Main working view.*
- **Kanban — Status** — Board view grouped by `Status`. *Visual progress.*
- **Priority Triage** — Filter `Status = Not started`, sort by `Priority` then `ID`. *What to pick next.*
- **Current Sprint** — Filter `Status = In progress`. *What's live now.*

### Convert property types

Notion may import all columns as plain text. Convert them like this:

- Right-click the `Status` column header → `Edit property` → change type to **Select** → add the 5 options.
- Same for `Priority` (`P0`, `P1`, `P2`).
- Same for `Phase` (the four phase names already in the data).
- For `Tags`: change to **Multi-select**. Notion will split by comma — our CSV uses `;` for tag separation, so right after import do a column find/replace `;` → `,` if needed.

---

## Option B — Import `notion_tracker.md` as a page (quick checkbox view)

This gives you a single-page Notion view with native checkbox lists you can tick off.

1. In Notion, open the parent page where you want it.
2. Type `/import` → select **Import**.
3. Choose **Markdown & CSV**.
4. Pick `project_plan/notion_tracker.md`.
5. Notion will create a child page with all the headings and `[ ]` rendered as **to-do blocks**.

The legend mapping `[/]` `[!]` `[-]` won't render as native checkboxes — they'll show as text. That's fine, they're just hints. The real status of truth is `tasks.csv`.

---

## How we keep both in sync

Whenever you finish a task:

1. Tell me the ID — e.g. *"P1-007 is done"*.
2. I will:
   - Set `Status = Done` for that row in `tasks.csv`.
   - Change `[ ]` → `[x]` for that line in `notion_tracker.md`.
   - Update the phase markdown's checklist (`01_phase_1_mvp.md` etc.).
   - Bump the totals in the "Quick metrics" table at the bottom of `notion_tracker.md`.
3. In Notion:
   - **Database (Option A):** re-import or manually change the row's `Status`. (Manual is faster after the first import.)
   - **Page (Option B):** just tick the checkbox in Notion — your Notion copy stays in sync visually.

If you prefer Notion to always reflect the repo (one-way: repo → Notion), do this once a week:

1. In Notion, open the imported database.
2. Click `…` → **Merge with CSV** → choose the latest `tasks.csv`.
3. Notion will match on the `ID` column and update changed rows.

---

## Optional — folder structure inside Notion

Once imported, this is a clean structure that mirrors the repo:

```
JourneyPlus (parent page)
├── 📌 Overview (paste contents of project_plan/00_overview.md)
├── 📋 Tasks (the imported database from tasks.csv)
├── ✅ Tracker (the imported notion_tracker.md page)
├── 🗺  Phase 1 — MVP (paste 01_phase_1_mvp.md)
├── 🗺  Phase 2 — Intelligence (paste 02_phase_2_intelligence.md)
├── 🗺  Phase 3 — AI Copilot (paste 03_phase_3_ai_copilot.md)
├── 🗺  Phase 4 — Scale (paste 04_phase_4_scale.md)
└── 🏗  Architecture
    ├── System Overview (docs/architecture/system_overview.md)
    ├── Data Flow     (docs/architecture/data_flow.md)
    ├── User Workflow (docs/architecture/user_workflow.md)
    └── …
```

---

## TL;DR

```bash
# In Notion:
1. /import → CSV → project_plan/tasks.csv         (database view)
2. /import → Markdown → project_plan/notion_tracker.md   (page view)
3. Add views: By Phase, Kanban by Status, Priority Triage
4. Update statuses in repo first → re-import or hand-toggle in Notion
```
