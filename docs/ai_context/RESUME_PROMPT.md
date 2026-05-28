# How to resume TripPlus on a fresh machine / fresh AI

This file is a **paste-target**. Copy the prompt in the next section into any
AI coding tool (Claude Code, Cursor, Codex CLI, Continue, etc.) opened at the
repo root, and the model will pick up exactly where the previous session left
off.

The prompt is deliberately self-contained — it tells the model **which files
to read, in what order, what the conventions are, how the task list and
dependency graph work, and what to do when a task is finished.** No prior
chat memory is required.

---

## 1. The resume prompt (copy everything between the lines)

```
────────────────────────────────────────────────────────────────────────────
You are resuming work on TripPlus — an EV/road-trip Flutter app being
extended into India's Smart Highway Companion. Work is tracked by task IDs
like `P1-007` from `project_plan/`.

Do not write any code or make any changes until you have read the files
below in order and replied with the four-line summary at the end.

STEP 1 — Read these files in order, no skipping:

  1. AGENTS.md                                  (repo-wide ground truth)
  2. .cursor/rules/project-conventions.mdc      (stack + non-negotiables)
  3. .cursor/rules/feature-slice.mdc            (folder + boundary rules)
  4. .cursor/rules/flutter-style.mdc            (Dart style + Freezed pattern)
  5. docs/context/product_vision.md             (what we are building)
  6. docs/context/decisions.md                  (ADRs — do not break these)
  7. docs/context/glossary.md                   (terminology)
  8. docs/context/current_state.md              (rolling snapshot of what
                                                 actually exists today)
  9. docs/ai_context/codebase_map.md            (file paths cheat-sheet)
 10. docs/ai_context/progress_log.md            (session-wise log — the
                                                 NEWEST entry at the top is
                                                 the previous session)
 11. docs/ai_context/open_questions.md          (anything blocked on the user)
 12. docs/batches/phase_1_batches.md            (THE SESSION PLAN — already
                                                 splits Phase 1 into commit-
                                                 sized sessions. Use this
                                                 instead of inventing your
                                                 own batches.)
 13. project_plan/README.md                     (how the plan is structured)
 14. project_plan/00_overview.md                (strategic plan, week-1 path)
 15. project_plan/01_phase_1_mvp.md             (Phase 1 task table —
                                                 columns: ID, Task, Priority,
                                                 Est, Depends on, Status)
 16. project_plan/tasks.csv                     (machine-readable status of
                                                 EVERY task across all phases)
 17. project_plan/notion_tracker.md             (checkbox view; same data)

STEP 2 — Figure out what to do next.

  Default path: open `docs/batches/phase_1_batches.md` and pick the
  next session marked `🔵 next` (or the first `⬜ planned` after the
  last ✅). Use that session's task list verbatim — the batches file
  has already curated dependency-safe, theme-coherent groupings.

  If the user said "start session N", jump to session N. Before any
  code, validate that EVERY dependency of EVERY task in session N has
  `Status == "Done"` in `project_plan/tasks.csv`. If any dep is open,
  stop and tell the user which earlier session must land first.

  Fallback path (only if the batches file is missing or stale): filter
  `project_plan/tasks.csv` to rows where `Status == "Not started"` AND
  every comma-separated id in `Dependencies` has `Status == "Done"`.
  Pick 3–6 ready tasks that share a theme. Prefer P0 over P1 over P2.
  Lower task ids break ties. Add the resulting session to the batches
  file before starting.

  Either way, confirm the batch + order with the user before writing
  code. Mention which Phase-1 sections (1.1 … 1.10) the batch covers
  and which later tasks it unblocks. Do not start until the user says go.

STEP 3 — Execute the batch one task at a time.

  - Mark a task `in_progress` (in your todo tool) when you start it.
  - When a model changes shape, run:
        dart run build_runner build --delete-conflicting-outputs
  - After each task, run `flutter analyze` and stop if it reports anything.
  - Repository writes return `Either<Failure, T>` (fpdart) using the
    sealed `Failure` in `lib/core/utils/failure.dart` with the 6 variants:
        network, permission, index, firestore, platform, quota.
  - Do NOT migrate existing repositories that still use raw strings /
    exceptions — only new code uses the typed `Failure`. The legacy
    `CommunityReportRepository` and `UserProfileRepository` are
    intentionally left as-is until separately scheduled.
  - Mark the task `completed` and immediately:
       a) Flip the `Status` column in `project_plan/tasks.csv` from
          "Not started" to "Done".
       b) Tick the `[ ]` → `[x]` for that ID in
          `project_plan/notion_tracker.md`.
       c) Bump the "Phase 1 — MVP" Done count + percentage in the metrics
          table at the bottom of `notion_tracker.md`.

STEP 4 — End the session.

  - Append a new `## Session N — <theme>` block to the TOP of
    `docs/ai_context/progress_log.md`. Use the format of the existing
    sessions (header, per-task notes, files changed, validation,
    suggested commit message, open follow-ups).
  - Update `docs/ai_context/codebase_map.md` with any new files /
    folders / providers you added.
  - Update `docs/context/current_state.md` (the "Phase 1 progress"
    section + the "Last updated" header) so the next resume picks up
    accurate context. This is task `P1-065` rolling.
  - Update `docs/batches/phase_1_batches.md`: flip your session row
    from 🔵 / ⬜ to ✅, and update the progress tracker table at the
    bottom of that file.
  - Do NOT commit; the user commits per session. Show them a
    suggested commit message in the format used by previous sessions.
  - Tell the user: which tasks are done, what files changed, the
    suggested commit message, and which session is next per the
    batches file (with a one-line "why now" per task).

STEP 5 — Conventions you must NOT break.

  1. Feature-slice layout: `lib/features/<feature>/{data,domain,presentation}/`.
     A feature must not import another feature's `data/` or `domain/`
     internals — only public `*_providers.dart` + domain models.
  2. Riverpod everywhere. `family.autoDispose` for entity-scoped providers.
  3. Freezed for all domain models. Run build_runner after every change.
  4. No raw `Colors.*` or inline `TextStyle(...)` — always go through
     `AppColors` / `AppTextStyles`.
  5. Community reports are immutable — the Firestore schema may only
     ADD fields, never remove or rename.
  6. Community photos are base64 JPEG inline on the document. No Firebase
     Storage (ADR-002).
  7. Stable identity helpers only — `stationKey` (`u_…` / `ocm_…` / `sid_…`),
     `targetKey`, `communityPoiKey(Poi)`. Never raw provider ids.
  8. Two `LatLng` types exist in the codebase. The service / data layer
     uses `lib/core/utils/polyline_decoder.dart`'s `LatLng`. Only
     `presentation/` widgets that render Google Maps use
     `package:google_maps_flutter`'s `LatLng`. Do not mix.
  9. EV stations are NOT served by `GooglePlacesPoiSource`. EV goes
     through `RoutePoiService` which delegates to the existing
     `RouteStationService` (OCM + Google EV-detection gate).
 10. Internal product positioning is "AI Highway Companion for Indian
     road trips" — do NOT regress to "EV charging app" wording in
     user-visible strings or docs.
 11. Two task-id pitfalls:
     - `P1-010` (domain model fields) and `P1-050` (Firestore schema)
       overlap. The DTO write IS the Firestore-side change. If you
       see one done but not the other, it's the same body of work.
     - `P1-065` is rolling — no separate session for it; it's the
       `current_state.md` refresh you owe every session end.
 12. Firestore composite indexes (e.g. `targetKey + createdAt` from
     `P1-055`) must be deployed with `firebase deploy --only
     firestore:indexes` for the new query path to work in production.
     Surface this to the user when you change the indexes file —
     don't assume they remember.
 13. `flutter_local_notifications` is installed (`P1-063` ✅) but its
     native iOS + Android plumbing is owed to `P1-027` (session 9
     per the batches file). Don't add notification calls before then.
 14. Native platform plumbing (`android/`, `ios/`, …) is only touched
     by tasks that explicitly mention it (`P1-027` notifications,
     `P1-030` icons, `P1-042` foreground service). Don't open those
     directories proactively for unrelated tasks.

When you have read everything, reply with exactly:

  Resume confirmed.
  Last session: <session N from progress_log.md top entry>
  Phase 1 progress: <X / 50 = Y%>
  Next session per batches file: Session <N+1> — <theme>
  Proposed tasks: <list of task ids from that session, with a one-line
                  why-now for each>

Then wait for the user to approve (or to redirect to a different session)
before writing code.
────────────────────────────────────────────────────────────────────────────
```

---

## 2. Why these specific files

| File | Why it's in the resume prompt |
|---|---|
| `AGENTS.md` | Anthropic / OpenAI convention — many tools auto-load it; the project uses it as the canonical context anchor. |
| `.cursor/rules/*.mdc` | Hard rules on stack + folder layout + style. Every contributor (human or AI) is expected to follow these. |
| `docs/context/product_vision.md` | Keeps the model from accidentally treating this as "an EV app" — it's a superset. |
| `docs/context/decisions.md` (ADRs) | Decisions that look reversible but aren't. Read before designing. |
| `docs/context/glossary.md` | Terms like `targetKey`, `corridor`, `pulse` mean specific things here. |
| `docs/context/current_state.md` | What's actually implemented today vs what's documented. Saves you from re-discovering. |
| `docs/ai_context/codebase_map.md` | Direct file paths — avoids minutes of `find` / `grep` to locate things. |
| `docs/ai_context/progress_log.md` | Session-wise history. Newest entry = last commit. Tells you why things are the way they are. |
| `docs/ai_context/open_questions.md` | Anything blocked on user input. |
| `docs/batches/phase_1_batches.md` | The curated session plan. Without this, a new AI would re-derive batches every time. With it, the user can just say "start session 7" and the AI knows which tasks to pick. |
| `project_plan/00_overview.md` | Strategy and week-1 path. |
| `project_plan/01_phase_1_mvp.md` | Authoritative task table for the active phase. |
| `project_plan/tasks.csv` | The dependency graph in machine-readable form. The resume prompt instructs the model to filter it. |
| `project_plan/notion_tracker.md` | Checkbox mirror — kept in sync with `tasks.csv`. |

## 3. How "next task" is computed

The `tasks.csv` schema is:

```
ID, Task, Phase, Section, Priority, Status, Estimate, Dependencies, Tags, Notes
```

A task is **ready** when:

1. `Status == "Not started"`, AND
2. Every id listed in the semi-colon-separated `Dependencies` column has
   `Status == "Done"`.

The model should pick a **coherent batch** (3–8 tasks) from the ready set,
honoring priority order (`P0` → `P1` → `P2`), and present it for approval.
Larger tickets (≥1 day estimate) should not share airtime with other large
tickets unless they're tightly coupled.

## 4. What the model writes back at session end

Per `STEP 4` in the prompt, every session must update:

- `project_plan/tasks.csv` — `Status` column flipped to `Done`.
- `project_plan/notion_tracker.md` — `[ ]` → `[x]` + bump the metrics row.
- `docs/ai_context/progress_log.md` — new top section.
- `docs/ai_context/codebase_map.md` — new files / providers.
- `docs/context/current_state.md` — Phase 1 progress block + "Last updated".
- `docs/batches/phase_1_batches.md` — flip the session row to ✅ +
  update the "Phase 1 progress tracker" table at the bottom.

The user commits these files **together with the code** so each git commit
is a complete session unit.

## 5. What NOT to read

The resume prompt deliberately doesn't tell the model to read:

- `build/`, `.dart_tool/`, `*.freezed.dart`, `*.g.dart` — generated, noise.
- `android/`, `ios/`, `macos/`, `web/`, `windows/`, `linux/` — only needed
  when a specific task touches platform plumbing (`P1-027` notifications,
  `P1-042` foreground location, etc.) — the task description will say so.
- `Initial idea and current status of project.md`, `tripplus_notion.md`,
  `RELIABILITY_PHASES.md`, `COMMUNITY_REPORTS.md` — these are pre-Phase-1
  historical context, superseded by `docs/context/`.

Reading them isn't wrong, just unnecessary for resuming work.

## 6. If you're on a different machine

1. Clone the repo, `cd` in.
2. `flutter pub get`
3. `dart run build_runner build --delete-conflicting-outputs`
4. Make sure `.env` has the three keys (see `README.md`).
5. Open the project in your AI tool of choice.
6. Paste the prompt in section 1.
7. Wait for the four-line confirmation, then approve the batch.

That's it.

---

## 7. Customizing — overriding the auto-picked session

The default behavior is "next session per `docs/batches/phase_1_batches.md`".
To override, just tell the AI one of:

- `"start session N"` — jumps to session N. The AI must verify all
  dependencies before writing code.
- `"do tasks P1-XXX, P1-YYY, P1-ZZZ"` — runs an ad-hoc batch. The AI
  must check deps and amend `phase_1_batches.md` to record the
  change before starting.
- `"split session N into two"` or `"merge sessions N and N+1"` —
  re-balance the plan. The AI edits the batches file first, then
  asks for go-ahead.

The AI must never silently deviate from the batches file — it either
follows it or asks before changing it.

## 8. When Phase 1 ends

Create `docs/batches/phase_2_batches.md` from
`project_plan/02_phase_2_intelligence.md` using the same template
(session blocks → tasks table → progress tracker). Update the resume
prompt's STEP 1 list and STEP 2 default path to point at the new
batches file. Bump `current_state.md` to note Phase 1 complete +
Phase 2 starting.
