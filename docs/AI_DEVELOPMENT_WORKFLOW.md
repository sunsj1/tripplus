# AI Development Workflow Guide
## Master Reference for AI-Driven Development on JourneyPlus

> **Audience:** Any AI coding tool (Claude Code, Cursor, Codex, Continue, etc.) starting work on the JourneyPlus project—whether it's your first session or resuming after a break.
>
> **Purpose:** This document defines the complete AI decision-making architecture: where to read information, what rules to follow, how to execute work, and how to maintain project continuity across machines and AI tools.

---

## Table of Contents

1. [Quick Start](#quick-start)
2. [Information Hierarchy](#information-hierarchy)
3. [Decision Framework](#decision-framework)
4. [Session Execution Loop](#session-execution-loop)
5. [Documentation Lifecycle](#documentation-lifecycle)
6. [Error Recovery](#error-recovery)
7. [Context Preservation](#context-preservation)

---

## Quick Start

**For any new session (same machine or different), follow these 5 steps:**

```
1. $ git pull                                    # Get latest state
2. $ [your-ai-tool]                             # Open in AI tool
3. Paste: docs/ai_context/RESUME_PROMPT.md      # Section 1 only
4. Wait for: 4-line confirmation response       # AI confirms it read context
5. Say: "go"                                     # Start session
```

**If something breaks:** Jump to [Error Recovery](#error-recovery).

---

## Information Hierarchy

The AI reads these files in strict order. **The order matters** — each level depends on the level above.

### Tier 1: Ground Truth (Read First)
These files define the *rules of engagement*. They rarely change, but when they do, everything changes.

| File | Purpose | Update frequency |
|------|---------|------------------|
| `AGENTS.md` | Repo-wide philosophy, team context, communication style | Rarely (manual) |
| `.cursor/rules/*.mdc` | Stack rules, folder layout, style guide, naming conventions | Rarely (manual) |

**AI must read these before touching any code.**

---

### Tier 2: Context & Strategy (Read Second)
These files answer: "What are we building?" and "What constraints are non-negotiable?"

| File | Purpose | Update frequency |
|------|---------|------------------|
| `docs/context/product_vision.md` | Product narrative, user jobs-to-be-done, brand voice | Manual (PRs only) |
| `docs/context/decisions.md` | Architecture Decision Records (ADRs) — decisions that can't be reversed | When making big choices |
| `docs/context/glossary.md` | Terminology with specific meaning in this project | As terms are coined |

**AI uses these to avoid re-discovering architectural decisions and to speak the project's language.**

---

### Tier 3: Current State (Read Third)
These files are the *rolling snapshots* — updated automatically at the end of every session.

| File | Purpose | Update frequency |
|------|---------|------------------|
| `docs/context/current_state.md` | What's shipped, what's half-done, what's blocked | End of every session |
| `docs/ai_context/codebase_map.md` | File paths, provider names, feature structure | End of every session |
| `docs/ai_context/progress_log.md` | Session-by-session history with what was done and why | End of every session |
| `docs/ai_context/open_questions.md` | Decisions waiting on human input | As they arise |

**AI uses these to understand what exists now, and to avoid repeating prior sessions' work.**

---

### Tier 4: The Plan (Read Fourth)
This is the AI's marching orders.

| File | Purpose | Update frequency |
|------|---------|------------------|
| `docs/batches/phase_1_batches.md` | Session-by-session task groupings | Start of each session |
| `project_plan/01_phase_1_mvp.md` | Full task reference table | Manual (design phase) |
| `project_plan/tasks.csv` | Task status + dependency graph | After each task |
| `project_plan/notion_tracker.md` | Checkbox view for humans | After each task |

**AI uses the batches file to know which tasks are in this session, and the task table to know task dependencies.**

---

## Decision Framework

Once the AI has read all context, it must answer these questions **in order** before writing a single line of code:

### Question 1: "Which session am I in?"
- Read `docs/batches/phase_1_batches.md`
- Find the **first unstarted session** (status = 🔵 or ⬜)
- Or a session specified by the user ("start session 8")
- **Output:** Session N, theme, list of task IDs

### Question 2: "Can I start this session?"
- For each task in the session, check `project_plan/tasks.csv` for dependencies
- Are all `Depends on` tasks `Done`?
- If no → **block** and ask the user
- **Output:** "Dependency check passed" or "Missing: [task IDs]"

### Question 3: "What does the project's code currently do?"
- Read `docs/context/current_state.md` — "Implemented surface" section
- Skim `docs/ai_context/codebase_map.md` for paths
- Read relevant `docs/context/*.md` ADRs for architectural constraints
- **Output:** Mental model of current state + what NOT to break

### Question 4: "What are the rules I must follow?"
For each task, cross-check:
- Does `.cursor/rules/*.mdc` forbid this approach? → Use allowed approach instead
- Does `docs/context/decisions.md` forbid this architecture? → Use allowed architecture instead
- Does `AGENTS.md` suggest a different style? → Match the style
- **Output:** List of constraints per task

### Question 5: "Can I execute this task independently?"
- Is the task a code-write task? → Can do alone
- Is the task a decision task (something in `open_questions.md`)? → Pause, ask user
- Is the task a manual task (bump version, create file, commit)? → Ask user or do if straightforward
- **Output:** "Ready to code" or "Blocked — need decision on X"

---

## Session Execution Loop

Once all questions above are answered, execute this loop **per task**:

```
┌─────────────────────────────────────────────────────────────┐
│ FOR EACH TASK IN SESSION                                    │
└─────────────────────────────────────────────────────────────┘
                              │
                              ▼
                    ┌─────────────────────┐
                    │ Mark task as        │
                    │ in_progress in      │
                    │ batches file        │
                    └─────────────────────┘
                              │
                              ▼
                    ┌─────────────────────┐
                    │ Write / Edit code   │
                    │ per task spec       │
                    └─────────────────────┘
                              │
                    ┌─────────┴─────────┐
                    │                   │
                    ▼                   ▼
            Any Freezed /        No Freezed /
            JSON models?         JSON changes?
                    │                   │
                    ▼                   ▼
        dart run build_runner   flutter analyze
        build --delete...
                    │                   │
                    └─────────┬─────────┘
                              │
                              ▼
                    ┌─────────────────────┐
                    │ All clean?          │
                    └─────────────────────┘
                       │              │
                      NO            YES
                       │              │
                       ▼              ▼
                    Fix code      ┌──────────────┐
                    & rebuild     │ Mark task as │
                    (loop back)   │ completed in │
                                  │ batches file │
                                  └──────────────┘
                                        │
                                        ▼
                                  ┌──────────────┐
                                  │ Flip row in  │
                                  │ tasks.csv →  │
                                  │ Done         │
                                  └──────────────┘
                                        │
                                        ▼
                                  ┌──────────────┐
                                  │ Tick box in  │
                                  │ notion_      │
                                  │ tracker.md   │
                                  └──────────────┘
                                        │
                    ┌─────────┬─────────┘
                    │
            More tasks?
              │      │
             YES     NO
              │      │
              ▼      ▼
           Loop   SESSION
           back   WRAP-UP
                (see below)
```

### Session Wrap-Up (After Last Task)

Run these steps in order:

1. **Append session block to progress log**
   - File: `docs/ai_context/progress_log.md`
   - Format: `## Session N — <theme>` at the TOP
   - Content: What was done, key decisions, any blockers

2. **Refresh codebase map**
   - File: `docs/ai_context/codebase_map.md`
   - Add new file paths, new providers, new feature structure

3. **Refresh current state**
   - File: `docs/context/current_state.md`
   - Update "Implemented surface" section
   - Update phase progress tracker
   - Update "Last updated" timestamp

4. **Mark session done in batches file**
   - File: `docs/batches/phase_1_batches.md`
   - Change session status from 🔵 to ✅

5. **Show user the commit message**
   - Format: `feat(phase1): <theme> (session N)`
   - Example: `feat(phase1): trip dashboard + trip foundation (session 7)`

6. **Stop — user commits**
   - Do NOT commit yourself
   - User runs: `git add -A && git commit -m "..."`

### Phase Wrap-Up (After Last Session in a Phase)

When the **verification** session signs off the phase, do everything in the
session wrap-up above **plus**:

7. **Prepend a new block to `docs/PHASE_REPORTS.md`**
   - Template at the bottom of that file
   - Pull the per-session theme + decisions from `progress_log.md`
   - Pull the "Features delivered" table by re-reading the batches file
   - Record gaps + improvements + tag name

8. **Update `docs/context/current_state.md` TL;DR**
   - Headline becomes "Phase N complete; Phase N+1 planning"
   - Link to `PHASE_REPORTS.md` for the rollup

9. **Tell the user the git tag to apply**
   - Format: `phase-N-<theme-slug>-complete`
   - Example: `phase-2-intelligence-complete`

This phase rollup is the canonical record. Future readers (humans or AI) start
here before opening the per-session log.

---

## Documentation Lifecycle

### Files That Change Per-Session (Rolling)

These files are *automatically updated* as part of the session loop. Treat them as living documents:

| File | When updated | Who updates | How |
|------|--------------|-------------|-----|
| `docs/context/current_state.md` | End of session | AI | Append/replace bullets in "Implemented surface" |
| `docs/ai_context/codebase_map.md` | End of session | AI | Add new paths, providers, structures |
| `docs/ai_context/progress_log.md` | End of session | AI | Append `## Session N` block at TOP |
| `docs/batches/phase_1_batches.md` | Start of session, mid-session if re-balancing | AI | Mark sessions ✅, move tasks if user asks |
| `project_plan/tasks.csv` | After each task | AI | Flip task row to `Done` |
| `project_plan/notion_tracker.md` | After each task | AI | Tick checkbox for completed task |

### Files That Change Per-Phase (Rollup)

These files are updated **once per phase**, at the verification / sign-off
step. They roll up the per-session work into a phase-level story so future
readers don't have to spelunk through every session block.

| File | When updated | Who updates | How |
|------|--------------|-------------|-----|
| `docs/PHASE_N_E2E_VERIFICATION.md` | At the start of the verification session | AI | Create a fresh checklist tailored to that phase's surface |
| `docs/PHASE_REPORTS.md` | At the end of the verification session, after sign-off | AI | Prepend a new `## Phase N — <theme>` block following the template at the bottom of the file |
| `docs/context/current_state.md` (TL;DR) | At the end of the verification session | AI | Update the headline to "Phase N complete; Phase N+1 planning" |

**Phase final-report block structure** (kept identical across phases for diff-ability):

1. Status / Duration / Verification link / Tag
2. **Theme** — one paragraph
3. **Features delivered** — table by surface
4. **Architecture changes** — bullets
5. **Improvements over previous phase** — bullets
6. **Known gaps / deferred to Phase N+1** — bullets
7. **Files of interest** — annotated path tree
8. **Test posture** — what's covered, what isn't

### Files That Rarely Change (Structural)

These are the *rules*. Only change them if the rules change:

| File | When updated | Who updates | Why |
|------|--------------|-------------|-----|
| `AGENTS.md` | Rarely | Human | Team context, philosophy, communication style |
| `.cursor/rules/*.mdc` | Rarely | Human | Stack/folder/style rules |
| `docs/context/decisions.md` | When making big choices | Human (AI suggests) | Recording ADRs |
| `docs/context/glossary.md` | When coining terms | Human (AI suggests) | Terminology |
| `docs/context/product_vision.md` | PRs only | Human | Product narrative |
| `project_plan/01_phase_1_mvp.md` | Design phase only | Human | Task reference table |

---

## Error Recovery

### Scenario 1: "AI Started Writing Code Without Reading Context"

**Symptom:** AI writes code before outputting the 4-line confirmation.

**Recovery:**
```
You:  STOP. Re-paste the RESUME_PROMPT from docs/ai_context/RESUME_PROMPT.md
AI:   [reads context]
AI:   Resume confirmed.
      Last session: Session 6 …
      Phase 1 progress: 30 / 50 = 60%
      Next session: Session 7 …
You:  go
```

**Why it happened:** AI skipped reading the rules. Make sure you pasted **Section 1 only** of the resume prompt.

---

### Scenario 2: "AI Forgot to Update tasks.csv or notion_tracker.md"

**Symptom:** AI completed a task but didn't mark it done in the trackers.

**Recovery:**
```
You:  You completed P1-018, P1-019, P1-020. Update tasks.csv and notion_tracker.md now.
AI:   [reads both files, finds tasks, updates them]
```

**Why it happened:** AI got distracted or the prompt didn't emphasize the rule. The batches file says to update trackers "immediately on each completion."

---

### Scenario 3: "flutter analyze is Dirty When I Clone"

**Symptom:** `flutter analyze` shows issues you didn't expect.

**Recovery (pick one):**

**Option A:** Build files aren't generated yet
```bash
$ dart run build_runner build --delete-conflicting-outputs
$ flutter analyze
```

**Option B:** Previous session left mid-flight
- Check `docs/ai_context/progress_log.md` — top entry will say so
- Ask the AI: "Session 6 appears unfinished. Resume it?"

**Option C:** Code is genuinely broken
- Read `docs/ai_context/open_questions.md` for any pending decisions
- Ask the AI: "What's blocking the build?"

---

### Scenario 4: "I Want to Change the Plan"

**Symptom:** You want to do a task out of order, skip a task, or combine sessions.

**Recovery:**
```
You:  Before session 7, let's add [custom task]. Or: Skip P1-064 for now.
AI:   I'll edit docs/batches/phase_1_batches.md first, then proceed.
      [AI updates batches file]
      Ready to continue?
You:  go
```

**Why this matters:** The batches file is the single source of truth. If the AI starts code without editing it first, the next machine will be confused.

---

### Scenario 5: "I'm on a Different AI Tool Now"

**Symptom:** You switched from Claude Code to Cursor (or vice versa).

**Recovery:**
```
You:  $ [new-ai-tool]
You:  [paste RESUME_PROMPT section 1]
AI:   Resume confirmed. Last session: Session 6 …
You:  go
```

**Why it works:** The resume prompt is tool-agnostic. It just tells the AI to read specific files and follow a specific protocol. No context is lost.

---

## Context Preservation

### What the Resume Prompt Contains (Section 1)

The `docs/ai_context/RESUME_PROMPT.md` file has two sections:

**Section 1:** Instructions to the AI
- "Read these files in this order"
- "Follow these rules"
- "Output this confirmation"
- **This is what you paste to start every session**

**Section 2:** Full context dump (optional)
- Entire codebase map
- Entire progress log
- Entire batches file
- Use this only if the AI seems confused (rare)

### Why This Works Across Machines

1. **All context lives in files, not in prior chats** — `docs/ai_context/progress_log.md` is the session history, not the chat history
2. **Each session starts fresh** — No memory needed from prior chats
3. **The resume prompt is idempotent** — Pasting it 100 times produces the same result
4. **Tool-agnostic** — Works with any AI tool that can read files

---

## Summary: The Workflow in One Picture

```
START
  │
  ├─→ git pull
  ├─→ Open AI tool
  ├─→ Paste RESUME_PROMPT (section 1)
  │
  ├─→ AI reads in order:
  │   1. AGENTS.md + .cursor/rules/*.mdc (rules)
  │   2. docs/context/* (strategy)
  │   3. docs/ai_context/* (current state)
  │   4. docs/batches/phase_1_batches.md (the plan)
  │
  ├─→ AI outputs 4-line confirmation:
  │   "Resume confirmed.
  │    Last session: Session 6 …
  │    Phase 1 progress: 30 / 50 = 60%
  │    Next session: Session 7 …"
  │
  ├─→ User says "go"
  │
  ├─→ AI executes per-session loop:
  │   FOR EACH TASK:
  │     - Write code
  │     - Run build_runner if needed
  │     - Run flutter analyze
  │     - Mark task done in batches + tasks.csv + notion_tracker
  │   AFTER ALL TASKS:
  │     - Append to progress_log.md
  │     - Refresh codebase_map.md
  │     - Refresh current_state.md
  │     - Mark session ✅ in batches file
  │     - Show commit message
  │
  ├─→ User commits
  │
  └─→ DONE — Next session, loop from "git pull"
```

---

## Checklists for Different Scenarios

### First Time on This Machine

- [ ] Clone the repo: `git clone <url> journeyplus && cd journeyplus`
- [ ] Install Flutter: `flutter --version` (need ^3.11.4)
- [ ] `flutter pub get`
- [ ] `dart run build_runner build --delete-conflicting-outputs`
- [ ] Drop in `.env` (3 API keys)
- [ ] Drop in Firebase config files
- [ ] `flutter analyze` (should be clean)
- [ ] Open repo in your AI tool
- [ ] Paste the resume prompt from `docs/ai_context/RESUME_PROMPT.md` section 1
- [ ] Wait for 4-line confirmation
- [ ] Say "go"

### Resuming After a Break (Same Machine, Same Tool)

- [ ] `git pull`
- [ ] Open repo in AI tool
- [ ] Paste the resume prompt from `docs/ai_context/RESUME_PROMPT.md` section 1
- [ ] Wait for 4-line confirmation
- [ ] Say "go"

### Switching to a Different AI Tool (Same Machine)

- [ ] `git pull`
- [ ] Open repo in new AI tool
- [ ] Paste the resume prompt from `docs/ai_context/RESUME_PROMPT.md` section 1
- [ ] Wait for 4-line confirmation
- [ ] Say "go"

### Cloning on a Different Machine

- [ ] Follow "First Time on This Machine" steps above
- [ ] Everything else is the same — the resume prompt works cross-machine

### If Something Breaks

- [ ] Check `docs/ai_context/progress_log.md` for the last completed session
- [ ] Check `docs/ai_context/open_questions.md` for any pending decisions
- [ ] Ask the AI: "What's the current blocker?"
- [ ] If the AI is confused, re-paste the resume prompt (Section 2 if Section 1 doesn't help)

---

## Key Principles

1. **One file is truth:** The batches file tells the AI what to do. Everything else is context.
2. **Context is external:** Progress and decisions live in docs, not in the chat history.
3. **Machines are fungible:** Any machine + any AI tool can pick up where the last one left off.
4. **Sessions are atomic:** One session = one commit. Each commit is self-contained.
5. **Documentation is a loop:** End-of-session documentation feeds next-session decisions.

---

**Questions? See `docs/AI_DEV_ONBOARDING.md` for setup or `docs/ai_context/RESUME_PROMPT.md` for the exact prompt to paste.**
