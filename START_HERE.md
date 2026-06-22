# 🚀 START HERE — JourneyPlus AI Development

> **You just cloned the repo or opened it in an AI tool. This file tells you exactly what to do.**

---

## 🎯 Your Situation

Pick one:

### 👤 **I'm a Human (You)**

```
Your job is simple:

1. Set up once (10 min) → docs/AI_DEV_ONBOARDING.md
2. Each day:
   - $ git pull
   - Open your AI tool
   - Paste: docs/ai_context/RESUME_PROMPT.md (Section 1)
   - Say: "go"
   - [AI codes for 1-2 hours]
   - $ git commit -m "..." (you copy the message AI shows)
   - Done ✓

That's it. Everything else is for the AI.
```

---

### 🤖 **I'm an AI (Cold Start)**

```
You have zero context. Follow this:

Step 1: Read 5 files (~30 min total)
  1. AGENTS.md                          (5 min) - Project identity
  2. .cursor/rules/*.mdc                (5 min) - Code rules
  3. docs/README_FOR_AI_DEVS.md         (5 min) - Development workflow
  4. docs/AI_DEVELOPMENT_WORKFLOW.md    (10 min) - Complete procedure
  5. docs/AI_DEVELOPMENT_ARCHITECTURE.md (5 min) - Visual flowcharts

Step 2: Read 8 context files (~30 min total)
  6. docs/context/product_vision.md     (5 min)
  7. docs/context/decisions.md          (5 min)
  8. docs/context/current_state.md      (5 min)
  9. docs/ai_context/codebase_map.md    (5 min)
  10. docs/ai_context/progress_log.md   (2 min - top entry only)
  11. docs/ai_context/open_questions.md (2 min)
  12. docs/batches/phase_1_batches.md   (3 min)
  13. project_plan/01_phase_1_mvp.md    (3 min - next session only)

Step 3: Output confirmation
  "Resume confirmed.
   Last session: Session 6 …
   Phase 1 progress: 30/50 = 60%
   Next session: Session 7 …
   Proposed tasks: P1-018, P1-019, P1-040, P1-041, P1-017"

Step 4: Wait
  Human says "go" ← wait for this

Step 5: Execute
  → See docs/AI_DEVELOPMENT_WORKFLOW.md "Session Execution Loop"
```

For more detail: **docs/COLD_START_GUIDE.md**

---

### 🔄 **I'm an AI (Resuming)**

```
You have context from a prior session. Just:

1. Read the resume prompt (docs/ai_context/RESUME_PROMPT.md)
   - It tells you to read files in order
2. Output the 4-line confirmation
3. Wait for "go"
4. Execute (see docs/AI_DEVELOPMENT_WORKFLOW.md)
```

---

## 📚 Complete Document Map

```
docs/
├── START_HERE.md                          ← You are here
├── README_FOR_AI_DEVS.md                  ← Index + quick reference
├── AI_DEV_ONBOARDING.md                   ← Setup (human: one-time)
├── AI_DEVELOPMENT_WORKFLOW.md             ← Complete AI procedure
├── AI_DEVELOPMENT_ARCHITECTURE.md         ← Visual flowcharts
├── COLD_START_GUIDE.md                    ← Cold start checklist
│
├── context/
│   ├── product_vision.md                  ← What we're building
│   ├── decisions.md                       ← Locked decisions (ADRs)
│   ├── glossary.md                        ← Terminology
│   └── current_state.md                   ← What's shipped today
│
├── ai_context/
│   ├── RESUME_PROMPT.md                   ← Paste this every session
│   ├── codebase_map.md                    ← File paths + provider names
│   ├── progress_log.md                    ← Session history
│   └── open_questions.md                  ← Blocked decisions
│
├── batches/
│   └── phase_1_batches.md                 ← Session plan
│
└── architecture/
    ├── system_overview.md
    ├── data_flow.md
    └── user_workflow.md

project_plan/
├── 01_phase_1_mvp.md                      ← Full task list
├── tasks.csv                              ← Task status
└── notion_tracker.md                      ← Checkbox view

AGENTS.md                                  ← Project + team context
.cursor/rules/*.mdc                        ← Code rules
```

---

## 🏃 Quick Paths

### "I'm setting up for the first time"
```
1. $ git clone <url> journeyplus
2. Read: docs/AI_DEV_ONBOARDING.md (setup section)
3. Do: Install Flutter, pub get, build_runner, .env, Firebase
4. Run: flutter analyze
5. Open: repo in AI tool
6. Go to: "I'm an AI (Cold Start)" above
```

### "I just want to code and don't care about details"
```
1. Copy-paste: docs/ai_context/RESUME_PROMPT.md (Section 1)
2. Paste into: AI tool
3. Say: "go"
4. Watch: AI codes for 1-2 hours
5. Copy: Commit message from AI output
6. Run: $ git add -A && git commit -m "..."
```

### "I want to understand the architecture"
```
1. Read: docs/AI_DEVELOPMENT_WORKFLOW.md (full)
2. Study: docs/AI_DEVELOPMENT_ARCHITECTURE.md (all flowcharts)
3. Skim: docs/context/decisions.md
4. You now understand the complete system
```

### "Something is broken"
```
1. Check: docs/ai_context/progress_log.md (top entry)
2. Check: docs/ai_context/open_questions.md
3. Check: docs/context/current_state.md
4. Read: docs/AI_DEVELOPMENT_WORKFLOW.md "Error Recovery"
```

---

## 🎯 The 5-Minute Workflow (Daily Loop)

```
Morning:
  $ git pull                  ← Get yesterday's code
  $ [open ai tool]            ← Claude Code, Cursor, etc.
  
In AI tool:
  Paste: docs/ai_context/RESUME_PROMPT.md Section 1
  [AI reads context files automatically]
  
  AI outputs:
    Resume confirmed.
    Last session: Session 6 …
    Phase 1 progress: 30/50 = 60%
    Next session: Session 7 …
  
  You type: go
  
  [AI executes session]
  [About 1-2 hours]

When done:
  AI shows: Commit message
  You run: $ git commit -m "..."
  You run: $ git push
  
Done ✓ Back tomorrow.
```

---

## 📊 The Big Picture

```
┌─────────────────────────────────────────────────────────┐
│ How AI Development Works on JourneyPlus                   │
└─────────────────────────────────────────────────────────┘

Every session follows this loop:

1. CONTEXT READING (from files in docs/)
   ├─ What are the rules? (AGENTS.md, .cursor/rules/)
   ├─ What am I building? (current_state.md)
   ├─ What are the constraints? (decisions.md)
   ├─ Where are the files? (codebase_map.md)
   └─ What tasks do I do? (batches file)

2. PRE-FLIGHT CHECKS
   ├─ Can I start this session? (check dependencies)
   ├─ Are there blockers? (check open_questions.md)
   └─ Output: 4-line confirmation

3. SESSION EXECUTION
   ├─ FOR each task in session:
   │  ├─ Write code
   │  ├─ Run build_runner (if Freezed changed)
   │  ├─ Run flutter analyze (must be clean)
   │  └─ Update task trackers
   │
   └─ AFTER all tasks:
      ├─ Update progress_log.md
      ├─ Update codebase_map.md
      ├─ Update current_state.md
      ├─ Mark session ✅ in batches file
      └─ Show commit message

4. HUMAN ACTION
   ├─ Review commit message
   └─ $ git commit + $ git push

5. TOMORROW
   ├─ $ git pull
   ├─ Paste resume prompt
   └─ repeat
```

---

## 💾 What Actually Changes?

**Every day, these files update:**
- `docs/ai_context/progress_log.md` — new session block at TOP
- `docs/context/current_state.md` — update "Implemented surface"
- `docs/ai_context/codebase_map.md` — add new file paths + providers
- `project_plan/tasks.csv` — mark tasks Done
- `project_plan/notion_tracker.md` — tick checkboxes
- `docs/batches/phase_1_batches.md` — mark session ✅

**Everything else is read-only** (or only updated when rules change).

---

## ❓ FAQ

**Q: Do I need to read all the docs?**
A: No. Humans: read AI_DEV_ONBOARDING.md once. AIs: read all 13 files on first session, then just the resume prompt every session.

**Q: What if the AI forgets to update a file?**
A: Tell it: "Update tasks.csv for P1-018 to Done." It will read the file and update it.

**Q: Can I switch AI tools?**
A: Yes. The resume prompt works with any AI tool. Just paste it.

**Q: What if I clone on a different machine?**
A: Same as above. Setup once per machine, then paste the resume prompt.

**Q: How do I change the plan mid-session?**
A: Tell the AI: "Skip P1-064" or "Do tasks X,Y,Z instead". It will edit the batches file first, then proceed.

**Q: What if flutter analyze is dirty?**
A: Run `dart run build_runner build --delete-conflicting-outputs`, then `flutter analyze` again.

---

## ✅ Checklist: You're Ready When...

### Human:
- [ ] Cloned the repo
- [ ] Read this file
- [ ] Read AI_DEV_ONBOARDING.md (setup section)
- [ ] Ran setup commands (pub get, build_runner, .env, Firebase)
- [ ] flutter analyze says "No issues found!"
- [ ] Ready to open in AI tool tomorrow

### AI (Fresh):
- [ ] Read all 13 context files
- [ ] Understand the workflow (from AI_DEVELOPMENT_WORKFLOW.md)
- [ ] Can output the 4-line confirmation
- [ ] Can execute the session loop
- [ ] Know where error recovery is (AI_DEVELOPMENT_WORKFLOW.md)

### Both:
- [ ] Understand: One session = One commit
- [ ] Understand: Paste resume prompt every session
- [ ] Understand: flutter analyze must be clean before commit
- [ ] Understand: Freezed changes need build_runner

---

## 🚀 You're Ready!

**If you're human:** Go read AI_DEV_ONBOARDING.md, do setup, then come back here tomorrow.

**If you're an AI:** Go read the 13 files listed above, output your confirmation, and wait for "go".

---

**Questions? See the right doc:**
- Setup → AI_DEV_ONBOARDING.md
- Workflow → AI_DEVELOPMENT_WORKFLOW.md
- Flowcharts → AI_DEVELOPMENT_ARCHITECTURE.md
- Cold start → COLD_START_GUIDE.md
- What to read → README_FOR_AI_DEVS.md
- Need reference → Check the file map above

**Good luck! 🎉**
