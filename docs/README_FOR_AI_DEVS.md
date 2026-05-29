# TripPlus: Complete Guide for AI Developers

> **You just cloned TripPlus on a fresh machine (or switched AI tools). Start here.**

This document is your roadmap. It tells you which file to read first, what order to read them in, and what to do after each step.

---

## 📋 Three Essential Documents

Read them in this order on **your first time ever**:

### 1️⃣ **AI_DEV_ONBOARDING.md** — Setup & Mechanical Steps
- **Read if:** You've never set up TripPlus on this machine
- **What it covers:**
  - Install Flutter
  - `pub get` + `build_runner`
  - Configure `.env` and Firebase
  - How to open in your AI tool
  - Paste the resume prompt
  - What the 4-line confirmation means
  
- **Time:** ~10 minutes
- **Output:** Ready to start developing

**Then continue to:**

---

### 2️⃣ **AI_DEVELOPMENT_WORKFLOW.md** — The Complete Mental Model
- **Read if:** You want to understand how the AI development process works
- **What it covers:**
  - The information hierarchy (Tier 1-4 rules, strategy, current state, plan)
  - Decision framework (5 questions to answer before coding)
  - Session execution loop (per-task flow)
  - Documentation lifecycle (what changes when)
  - Error recovery scenarios (what to do when things break)
  - Context preservation (how work survives across machines/AI tools)
  
- **Time:** ~20 minutes (skim) or ~40 minutes (careful read)
- **Output:** Complete understanding of the AI development architecture

**Plus refer to:**

---

### 3️⃣ **AI_DEVELOPMENT_ARCHITECTURE.md** — Visual Flowcharts
- **Read if:** You prefer visual representations
- **What it covers:**
  - 8 detailed mermaid flowcharts showing:
    1. Initial entry point (fresh clone vs. resume)
    2. Information hierarchy (what the AI reads in order)
    3. Pre-flight checks (before session starts)
    4. Per-task execution loop (code → build → analyze)
    5. Session wrap-up (documentation updates)
    6. Error handling (what to do when things break)
    7. End-to-end workflow (Day 1 setup → Session 11 verification)
    8. Context flow (how info moves across sessions)
  
- **Time:** ~10 minutes (scan) or ~20 minutes (study)
- **Output:** Visual understanding of the complete process

---

## 🗂️ Supporting Reference Documents

Keep these bookmarked for daily work:

| Document | When to Read | What It Does |
|----------|--------------|-------------|
| `RESUME_PROMPT.md` | Every session start | Instructions for the AI to read context in order |
| `AGENTS.md` | First time only | Team philosophy, communication style, rules of engagement |
| `.cursor/rules/*.mdc` | First time only | Stack/folder/style rules the AI must follow |
| `docs/context/product_vision.md` | When confused about product direction | What we're building, user jobs, brand voice |
| `docs/context/decisions.md` | When making architectural choices | ADRs — decisions that can't be reversed |
| `docs/context/glossary.md` | When unsure of terminology | Terms with specific meaning in this project |
| `docs/context/current_state.md` | Before every session | What's shipped, what's in progress, what's blocked |
| `docs/ai_context/codebase_map.md` | When navigating the codebase | File paths, provider names, feature structure |
| `docs/ai_context/progress_log.md` | When wondering what happened before | Session-by-session history |
| `docs/ai_context/open_questions.md` | When blocked on a decision | Decisions waiting on human input |
| `docs/batches/phase_1_batches.md` | Before every session | Which tasks are in this session |
| `project_plan/01_phase_1_mvp.md` | When understanding task context | Full task reference table |
| `project_plan/tasks.csv` | When tracking task status | Task status + dependency graph |
| `project_plan/notion_tracker.md` | For progress tracking | Checkbox view for humans |

---

## 🚀 Your First 5 Minutes

**If you're on a fresh machine for the first time:**

```bash
# 1. Clone the repo
git clone <your-repo-url> tripplus
cd tripplus

# 2. Install dependencies (see AI_DEV_ONBOARDING.md for details)
flutter pub get
dart run build_runner build --delete-conflicting-outputs

# 3. Configure (see AI_DEV_ONBOARDING.md for where to get these)
# - Create .env with 3 API keys
# - Copy Firebase config files

# 4. Verify setup
flutter analyze  # Should say "No issues found!"

# 5. Open in your AI tool
claude  # or cursor, codex, etc.
```

**Then in your AI tool:**

```
You:  [paste docs/ai_context/RESUME_PROMPT.md — Section 1 only]

AI:   Resume confirmed.
      Last session: None — first time
      Phase 1 progress: 0 / 50 = 0%
      Next session: Session 1 — Foundation models + rebrand
      Proposed tasks: P1-001, P1-002, P1-063, P1-003, P1-031, P1-006, P1-022, P1-029

You:  go

AI:   [writes code for session 1]
      [when session is done: shows commit message]

You:  git add -A && git commit -m "feat(phase1): foundation models + rebrand (session 1)"
```

That's it. Tomorrow:

```bash
git pull
claude  # or your AI tool
# [paste RESUME_PROMPT]
# [say "go"]
```

---

## 🔄 The Daily Workflow

**Every day after setup:**

```
1. $ git pull                              # Get yesterday's commit
2. $ [open-ai-tool]                        # Open in AI tool
3. Paste RESUME_PROMPT (Section 1 only)    # AI reads context
4. Wait for 4-line confirmation            # AI confirms it understands
5. Say "go"                                # Start the session
6. [AI runs session execution loop]        # AI codes, tests, updates docs
7. [AI shows commit message]               # You review
8. $ git add -A && git commit -m "..."     # You commit
```

That's the entire loop. Everything else is just details.

---

## ❌ When Something Goes Wrong

**The AI doesn't read context before coding:**
```
You:  STOP. Re-paste RESUME_PROMPT.
AI:   [reads context]
AI:   Resume confirmed. ...
You:  go
```

**The AI forgets to update tasks.csv:**
```
You:  Update tasks.csv for P1-018, P1-019, P1-020 to Done.
AI:   [reads file, updates it]
```

**You want to change the plan:**
```
You:  Skip P1-064, I want to evaluate Sentry instead.
AI:   I'll edit docs/batches/phase_1_batches.md first.
      [AI updates batches file, then proceeds]
```

**You cloned on a different machine:**
```
[Same as above. The resume prompt is tool-agnostic.]
```

**For all error scenarios:** See "Error Recovery" in `AI_DEVELOPMENT_WORKFLOW.md`.

---

## 📊 How Progress Is Tracked

- **Human view:** `project_plan/notion_tracker.md` — checkbox list of all 50 tasks
- **AI view:** `docs/batches/phase_1_batches.md` — which tasks are in which session
- **Status view:** `docs/context/current_state.md` — what's shipped, what's in progress
- **History view:** `docs/ai_context/progress_log.md` — what was done each session

The **batches file** is the source of truth. Everything else is just a different view of the same data.

---

## 🎯 Key Principles to Remember

1. **One resume prompt per session** — paste it every time you start work
2. **AI reads in order:** Rules → Strategy → Current state → The plan
3. **Session = commit** — one session is one atomic commit
4. **Documentation is the memory** — progress lives in files, not in chat history
5. **Machines are fungible** — any machine + any AI tool can pick up where the last one left off
6. **Batches file is truth** — if you want to change the plan, edit the batches file first

---

## 📚 Quick Reference: Which File for Which Question?

| Question | Answer In |
|----------|-----------|
| How do I set up on a new machine? | `AI_DEV_ONBOARDING.md` |
| What's the complete AI development process? | `AI_DEVELOPMENT_WORKFLOW.md` |
| How do I visualize the process? | `AI_DEVELOPMENT_ARCHITECTURE.md` |
| What's the product vision? | `docs/context/product_vision.md` |
| What decisions are locked in? | `docs/context/decisions.md` |
| What's already been built? | `docs/context/current_state.md` |
| Where are the files I need to touch? | `docs/ai_context/codebase_map.md` |
| What happened in prior sessions? | `docs/ai_context/progress_log.md` |
| What's blocking me? | `docs/ai_context/open_questions.md` |
| Which tasks are in this session? | `docs/batches/phase_1_batches.md` |
| What's the full task list? | `project_plan/01_phase_1_mvp.md` |
| What tasks are done? | `project_plan/tasks.csv` + `project_plan/notion_tracker.md` |
| What code rules do I follow? | `.cursor/rules/*.mdc` |
| What's my team context? | `AGENTS.md` |

---

## 🛠️ What to Do Right Now

### If you've never cloned this project before:
1. Read this file (you're doing it)
2. Read `AI_DEV_ONBOARDING.md` → Do the setup
3. Skim `AI_DEVELOPMENT_ARCHITECTURE.md` → See the flowcharts
4. Reference `AI_DEVELOPMENT_WORKFLOW.md` → When you need details

### If you've cloned before but on a different machine:
1. Do the setup from `AI_DEV_ONBOARDING.md`
2. Jump to "Your First 5 Minutes" above
3. Paste the resume prompt → you're off

### If you're resuming on the same machine:
1. `git pull`
2. Open your AI tool
3. Paste the resume prompt
4. Say "go"

### If something feels off:
1. Read `AI_DEVELOPMENT_WORKFLOW.md` → Error Recovery section
2. Check `docs/ai_context/progress_log.md` → What happened before?
3. Check `docs/ai_context/open_questions.md` → What's blocking?
4. Ask the AI: "What's the current blocker?"

---

## 🎓 Learning Path

**Minimal (just want to code):**
- 5 min: Read "Your First 5 Minutes" above
- 10 min: `AI_DEV_ONBOARDING.md`
- Done

**Standard (want to understand the process):**
- 10 min: This file
- 10 min: `AI_DEV_ONBOARDING.md`
- 20 min: `AI_DEVELOPMENT_WORKFLOW.md` (skim)
- 10 min: `AI_DEVELOPMENT_ARCHITECTURE.md` (scan flowcharts)
- ~50 min total

**Deep (want to own the process):**
- 10 min: This file
- 10 min: `AI_DEV_ONBOARDING.md`
- 40 min: `AI_DEVELOPMENT_WORKFLOW.md` (careful read)
- 20 min: `AI_DEVELOPMENT_ARCHITECTURE.md` (study flowcharts)
- 15 min: `AGENTS.md` + `.cursor/rules/*.mdc`
- ~95 min total

---

## 💡 Pro Tips

1. **Bookmark the resume prompt** — You'll paste it every session. Keep it accessible.
2. **Skim the progress log before each session** — 5 minutes saved vs. 50 minutes of confusion.
3. **Update open_questions.md the moment you're blocked** — Don't keep going; surface decisions early.
4. **The batches file is your roadmap** — If the user asks you to do something different, edit the batches file first.
5. **One session = one commit** — If you finish 5 tasks in one session, it's one commit with 5 tasks. Don't split.
6. **`flutter analyze` is your guardrail** — If it's not clean, don't commit. Period.
7. **Freezed is picky** — If you touch a freezed model, run build_runner immediately. Don't wait.

---

## ✅ Checklist: You're Ready When...

- [ ] You've cloned the repo
- [ ] You've run `flutter pub get` + `build_runner`
- [ ] You've created `.env` with 3 API keys
- [ ] You've copied Firebase config files
- [ ] `flutter analyze` says "No issues found!"
- [ ] You've opened the repo in your AI tool
- [ ] You've read this file
- [ ] You understand the 5-minute workflow above
- [ ] You're ready to paste the resume prompt

**Then:**
- [ ] Open `docs/ai_context/RESUME_PROMPT.md`
- [ ] Copy Section 1
- [ ] Paste into your AI tool
- [ ] Wait for the 4-line confirmation
- [ ] Say "go"

🚀 **You're now developing TripPlus as a team with an AI.**

---

**Questions?**
- Setup issues → `AI_DEV_ONBOARDING.md`
- Process questions → `AI_DEVELOPMENT_WORKFLOW.md`
- Visual learner → `AI_DEVELOPMENT_ARCHITECTURE.md`
- Blocked → `docs/ai_context/open_questions.md`
- Lost → Re-read this file, then the progress log

**Good luck! 🎉**
