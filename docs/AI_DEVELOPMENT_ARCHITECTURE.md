# AI Development Architecture
## Visual Flowchart: How AI Develops JourneyPlus

This document provides visual representations of the complete AI-driven development procedure for JourneyPlus. Use this to understand the decision flow, execution loop, and context hierarchy.

---

## 1. Initial Entry Point: Fresh Clone or Resume

```mermaid
flowchart TD
    Start([Developer clones repo or opens in AI tool]) --> Q1{First time on this machine?}
    
    Q1 -->|Yes| LocalSetup["<b>LOCAL SETUP (One-time)</b><br/>1. Install Flutter ^3.11.4<br/>2. flutter pub get<br/>3. dart run build_runner<br/>4. Drop in .env<br/>5. Drop in Firebase configs<br/>6. flutter analyze ✓"]
    Q1 -->|No| SkipSetup["Setup already done"]
    
    LocalSetup --> OpenTool["Open repo in AI tool"]
    SkipSetup --> OpenTool
    
    OpenTool --> PastePrompt["Paste docs/ai_context/<br/>RESUME_PROMPT.md Section 1"]
    
    PastePrompt --> AIReads["<b>AI reads files in order</b><br/>(see Tier 1-4 below)"]
    
    AIReads --> Confirm["AI outputs 4-line confirmation:<br/>✓ Resume confirmed<br/>✓ Last session: Session N<br/>✓ Phase 1 progress: X/50<br/>✓ Next session: Session M"]
    
    Confirm --> CheckConfirm{Correct confirmation?}
    
    CheckConfirm -->|No| RepastPrompt["Re-paste prompt<br/>(Section 2 if confused)"]
    RepastPrompt --> AIReads
    
    CheckConfirm -->|Yes| Ready["✓ Ready to execute"]
    
    Ready --> Decision{"User says:<br/>go / start session N /<br/>do tasks X,Y,Z"}
    
    Decision -->|go| UseDefault["Execute default session<br/>per batches file"]
    Decision -->|start session N| ValidateDeps["Validate all task dependencies<br/>in session N are met"]
    Decision -->|do tasks X,Y,Z| EditBatches["AI edits batches file first,<br/>then executes ad-hoc batch"]
    
    UseDefault --> SessionLoop["🔄 SESSION EXECUTION LOOP"]
    ValidateDeps --> SessionLoop
    EditBatches --> SessionLoop
    
    style Start fill:#e1f5ff
    style LocalSetup fill:#fff3e0
    style AIReads fill:#f3e5f5
    style Confirm fill:#e8f5e9
    style SessionLoop fill:#fce4ec
```

---

## 2. Information Hierarchy: What AI Reads (In Order)

```mermaid
flowchart TD
    Start([AI pasted with RESUME_PROMPT]) --> T1["<b>TIER 1: Ground Truth</b><br/>(Rules of engagement)"]
    
    T1 --> T1a["📄 AGENTS.md<br/>Team context, philosophy,<br/>communication style"]
    T1 --> T1b["📋 .cursor/rules/*.mdc<br/>Stack rules, folder layout,<br/>style guide, conventions"]
    
    T1a --> T1Check{"Parsed rules<br/>successfully?"}
    T1b --> T1Check
    
    T1Check -->|No| T1Error["❌ STOP — Ask user<br/>for clarification"]
    T1Check -->|Yes| T2
    
    T1Error --> End1([Cannot proceed])
    
    T2["<b>TIER 2: Context & Strategy</b><br/>(What are we building?)<br/>Read in order:"]
    
    T2 --> T2a["📖 product_vision.md<br/>User jobs, brand voice,<br/>product narrative"]
    T2 --> T2b["🔐 decisions.md<br/>ADRs — architectural<br/>decisions that can't be reversed"]
    T2 --> T2c["📚 glossary.md<br/>Terminology with<br/>specific meaning"]
    
    T2a --> T2Check
    T2b --> T2Check
    T2c --> T2Check
    
    T2Check{"Built mental model<br/>of strategy?"}
    T2Check -->|Incomplete| T2Error2["❌ STOP — Ask user<br/>for missing context"]
    T2Check -->|Complete| T3
    
    T2Error2 --> End2([Cannot proceed])
    
    T3["<b>TIER 3: Current State</b><br/>(Rolling snapshots)<br/>Read in order:"]
    
    T3 --> T3a["🔍 current_state.md<br/>Implemented surface,<br/>Phase N progress, last update"]
    T3 --> T3b["🗂️ codebase_map.md<br/>File paths, providers,<br/>feature structure"]
    T3 --> T3c["📊 progress_log.md<br/>Session-by-session history<br/>what was done & why"]
    T3 --> T3d["❓ open_questions.md<br/>Decisions waiting on<br/>human input"]
    
    T3a --> T3Check
    T3b --> T3Check
    T3c --> T3Check
    T3d --> T3Check
    
    T3Check{"Understand current<br/>state + blockers?"}
    T3Check -->|Incomplete| T3Error3["❌ Blocked on decision<br/>in open_questions.md"]
    T3Check -->|Complete| T4
    
    T3Error3 --> Decision_Wait["⏸️ Ask user for decision"]
    Decision_Wait --> End3([Cannot proceed without input])
    
    T4["<b>TIER 4: The Plan</b><br/>(Marching orders)<br/>Read in order:"]
    
    T4 --> T4a["📅 phase_1_batches.md<br/>Session-by-session<br/>task groupings"]
    T4 --> T4b["📋 01_phase_1_mvp.md<br/>Full task reference<br/>table"]
    T4 --> T4c["📊 tasks.csv<br/>Task status +<br/>dependency graph"]
    T4 --> T4d["✓ notion_tracker.md<br/>Checkbox view<br/>for humans"]
    
    T4a --> T4Check
    T4b --> T4Check
    T4c --> T4Check
    T4d --> T4Check
    
    T4Check{"Know which session<br/>to execute?"}
    T4Check -->|No| T4Error4["❌ User must specify<br/>session or task"]
    T4Check -->|Yes| Ready["✅ Ready for execution"]
    
    T4Error4 --> End4([Wait for user input])
    
    Ready --> PreFlight["🚀 Pre-flight checks<br/>before session starts"]
    
    style T1 fill:#fff3e0,stroke:#ff6f00,stroke-width:2px
    style T2 fill:#f3e5f5,stroke:#7b1fa2,stroke-width:2px
    style T3 fill:#e3f2fd,stroke:#1565c0,stroke-width:2px
    style T4 fill:#e8f5e9,stroke:#388e3c,stroke-width:2px
    style Ready fill:#c8e6c9,stroke:#2e7d32,stroke-width:3px
```

---

## 3. Pre-Flight Checks: Before Session Starts

```mermaid
flowchart TD
    Start([AI read all Tier 1-4 context]) --> Check1["<b>Check 1:</b> Which session?<br/>Query batches file for<br/>next unstarted or user-specified"]
    
    Check1 --> S1["✓ Session ID known"]
    
    S1 --> Check2["<b>Check 2:</b> Can I start?<br/>For each task in session,<br/>check dependencies in tasks.csv"]
    
    Check2 --> Deps{All task dependencies<br/>already Done?}
    
    Deps -->|No| DepsFail["❌ Missing task IDs:<br/>Show list"]
    DepsFail --> DepsFail2["Ask user: Skip missing?<br/>Or start different session?"]
    DepsFail2 --> End_Blocked([Blocked])
    
    Deps -->|Yes| S2["✓ Can execute"]
    
    S2 --> Check3["<b>Check 3:</b> What exists now?<br/>Read current_state.md<br/>Implemented surface section"]
    
    Check3 --> S3["✓ Know what's built"]
    
    S3 --> Check4["<b>Check 4:</b> Rules per task<br/>For each task, cross-check:<br/>- Stack rules forbid this?<br/>- ADRs forbid this?<br/>- Naming conventions match?"]
    
    Check4 --> RulesCheck{All rules<br/>compatible?}
    
    RulesCheck -->|No| RulesFail["❌ Conflict found:<br/>Show rule + task"]
    RulesFail --> RulesFail2["Ask user: Waive rule?<br/>Or change task?"]
    RulesFail2 --> End_Conflict([Conflict])
    
    RulesCheck -->|Yes| S4["✓ No conflicts"]
    
    S4 --> Check5["<b>Check 5:</b> Blockers?<br/>Check open_questions.md<br/>for pending decisions"]
    
    Check5 --> Blockers{Any blockers<br/>for this session?}
    
    Blockers -->|Yes| BlockerList["⚠️ List blockers"]
    BlockerList --> BlockerAsk["Ask user: Proceed<br/>despite blockers?<br/>Or wait?"]
    BlockerAsk --> BlockerDecision{User says<br/>proceed?}
    BlockerDecision -->|No| End_Wait([Wait])
    BlockerDecision -->|Yes| S5
    
    Blockers -->|No| S5["✓ No blockers"]
    
    S5 --> FinalConfirm["<b>FINAL OUTPUT:</b><br/>Resume confirmed.<br/>Last session: Session N<br/>Phase 1 progress: X/50<br/>Next session: Session M"]
    
    FinalConfirm --> Ready["✅ READY TO EXECUTE"]
    
    style Start fill:#e1f5ff
    style Check1 fill:#fff9c4
    style Check2 fill:#fff9c4
    style Check3 fill:#fff9c4
    style Check4 fill:#fff9c4
    style Check5 fill:#fff9c4
    style Ready fill:#c8e6c9,stroke:#2e7d32,stroke-width:3px
    style DepsFail fill:#ffcdd2
    style RulesFail fill:#ffcdd2
    style End_Blocked fill:#ef5350
    style End_Conflict fill:#ef5350
    style End_Wait fill:#ffa726
```

---

## 4. Session Execution Loop: Per-Task Flow

```mermaid
flowchart TD
    Start([Session N starts]) --> TaskList["Read task list from<br/>docs/batches/phase_1_batches.md<br/>Session N tasks"]
    
    TaskList --> LoopStart["🔄 FOR EACH TASK"]
    
    LoopStart --> MarkProgress["1️⃣ Mark task in_progress<br/>in batches file"]
    
    MarkProgress --> ReadSpec["2️⃣ Read task spec from<br/>01_phase_1_mvp.md"]
    
    ReadSpec --> ReadDeps["3️⃣ Read dependencies from<br/>tasks.csv (should be all Done)"]
    
    ReadDeps --> DesignTask["4️⃣ Design solution<br/>- Check codebase_map.md for paths<br/>- Check decisions.md for constraints<br/>- Check current_state.md for context"]
    
    DesignTask --> CodeWrite["5️⃣ Write / Edit code<br/>Create files, edit existing,<br/>follow stack rules + conventions"]
    
    CodeWrite --> AnyFrozen{"Any Freezed or<br/>JSON model<br/>changes?"}
    
    AnyFrozen -->|Yes| BuildRunner["6️⃣ dart run build_runner<br/>build --delete-conflicting-outputs<br/>Regenerate *.freezed.dart<br/>and *.g.dart files"]
    AnyFrozen -->|No| Analyze
    
    BuildRunner --> Analyze["7️⃣ flutter analyze"]
    
    Analyze --> AnalyzeClean{"All issues<br/>resolved?"}
    
    AnalyzeClean -->|No| AnalyzeFail["❌ Fix errors"]
    AnalyzeFail --> CodeWrite
    
    AnalyzeClean -->|Yes| MarkDone["8️⃣ Mark task completed<br/>in batches file"]
    
    MarkDone --> UpdateCSV["9️⃣ Flip row in tasks.csv<br/>→ Done"]
    
    UpdateCSV --> UpdateNotion["🔟 Tick box in<br/>notion_tracker.md"]
    
    UpdateNotion --> TaskOutput["Show summary:<br/>✅ Task ID done<br/>Files changed: [list]"]
    
    TaskOutput --> MoreTasks{More tasks<br/>in session?}
    
    MoreTasks -->|Yes| LoopStart
    
    MoreTasks -->|No| WrapUp["⏹️ SESSION WRAP-UP<br/>(see next diagram)"]
    
    style Start fill:#e1f5ff
    style LoopStart fill:#fce4ec,stroke:#c2185b,stroke-width:2px
    style MarkProgress fill:#fff3e0
    style CodeWrite fill:#e8f5e9
    style BuildRunner fill:#fff3e0
    style Analyze fill:#fff3e0
    style AnalyzeFail fill:#ffcdd2
    style MarkDone fill:#c8e6c9
    style WrapUp fill:#f3e5f5,stroke:#6a1b9a,stroke-width:2px
```

---

## 5. Session Wrap-Up: After All Tasks Done

```mermaid
flowchart TD
    Start([All tasks in session completed]) --> Step1["<b>Step 1: Append to progress_log.md</b><br/>- Add to TOP of file<br/>- Format: ## Session N — Theme<br/>- Content: What was done,<br/>  key decisions, blockers"]
    
    Step1 --> S1["✅ Progress log updated"]
    
    S1 --> Step2["<b>Step 2: Refresh codebase_map.md</b><br/>- List new files created<br/>- List new providers added<br/>- Update feature structure<br/>- Update file paths"]
    
    Step2 --> S2["✅ Codebase map refreshed"]
    
    S2 --> Step3["<b>Step 3: Refresh current_state.md</b><br/>- Update 'Implemented surface'<br/>  bullets with new feature<br/>- Update Phase N progress % <br/>- Update 'Last updated' timestamp<br/>- Remove from 'NOT implemented'<br/>  if task was completion-level"]
    
    Step3 --> S3["✅ Current state updated"]
    
    S3 --> Step4["<b>Step 4: Mark session done</b><br/>in batches file<br/>- Change session status<br/>  from 🔵 to ✅"]
    
    Step4 --> S4["✅ Batches file updated"]
    
    S4 --> Step5["<b>Step 5: Show commit message</b><br/>Format:<br/>feat(phase1): SESSION_THEME (session N)<br/><br/>Example:<br/>feat(phase1): trip dashboard +<br/>trip foundation (session 7)"]
    
    Step5 --> S5["✅ Commit message ready"]
    
    S5 --> Step6["<b>Step 6: Stop — user commits</b><br/>User runs:<br/>$ git add -A<br/>$ git commit -m '...'<br/>$ git push"]
    
    Step6 --> Done["✅ SESSION COMPLETE<br/>Ready for next session"]
    
    Done --> NextSession["<b>Tomorrow:</b><br/>$ git pull<br/>$ [open-ai-tool]<br/>$ paste RESUME_PROMPT<br/>$ go"]
    
    style Start fill:#e1f5ff,stroke:#01579b,stroke-width:2px
    style Step1 fill:#f3e5f5
    style Step2 fill:#f3e5f5
    style Step3 fill:#f3e5f5
    style Step4 fill:#f3e5f5
    style Step5 fill:#f3e5f5
    style Step6 fill:#ffe0b2
    style Done fill:#c8e6c9,stroke:#2e7d32,stroke-width:3px
    style NextSession fill:#e0f2f1,stroke:#00695c,stroke-width:2px
```

---

## 6. Error Handling: What to Do When Things Break

```mermaid
flowchart TD
    Error([Something unexpected happened]) --> Q1{"AI wrote code before<br/>4-line confirmation?"}
    
    Q1 -->|Yes| E1["❌ AI didn't read context<br/>Solution:<br/>STOP → Re-paste RESUME_PROMPT<br/>→ Wait for confirmation<br/>→ go"]
    
    E1 --> Fix1["✅ Fixed"]
    
    Q1 -->|No| Q2{"flutter analyze<br/>dirty when<br/>cloning?"}
    
    Q2 -->|Yes| E2A["Possible cause 1:<br/>Build files missing<br/>$ dart run build_runner build<br/>$ flutter analyze"]
    
    E2A --> E2Check{"Clean now?"}
    E2Check -->|No| E2B["Possible cause 2:<br/>Previous session mid-flight<br/>Check progress_log.md top<br/>Ask AI: Resume session N?"]
    E2Check -->|Yes| Fix2["✅ Fixed"]
    
    E2B --> E2C{"Still dirty?"}
    E2C -->|No| Fix2
    E2C -->|Yes| E2D["Possible cause 3:<br/>Code genuinely broken<br/>Ask AI: What's blocking?"]
    
    E2D --> Fix2
    
    Q2 -->|No| Q3{"AI forgot to update<br/>tasks.csv or<br/>notion_tracker.md?"}
    
    Q3 -->|Yes| E3["❌ Trackers out of sync<br/>Solution:<br/>Ask AI: Update trackers<br/>for P1-XXX, P1-YYY<br/>AI reads files and updates"]
    
    E3 --> Fix3["✅ Fixed"]
    
    Q3 -->|No| Q4{"Want to change<br/>the plan?"}
    
    Q4 -->|Yes| E4["✅ Normal operation<br/>Tell AI: Do tasks X,Y,Z<br/>Or: Skip P1-064<br/>Or: Split session 8<br/>AI edits batches file FIRST,<br/>then proceeds"]
    
    E4 --> Fix4["✅ Proceeding"]
    
    Q4 -->|No| Q5{"Switched AI tools?"}
    
    Q5 -->|Yes| E5["✅ Normal operation<br/>$ [new-ai-tool]<br/>$ paste RESUME_PROMPT<br/>$ go<br/>Resume prompt is tool-agnostic"]
    
    E5 --> Fix5["✅ Works"]
    
    Q5 -->|No| E6["❌ Unknown error<br/>Solution:<br/>1. Check progress_log.md<br/>2. Check open_questions.md<br/>3. Ask AI: What happened?<br/>4. If confused, re-paste<br/>   RESUME_PROMPT (Section 2)"]
    
    E6 --> Fix6["🔧 Debugging"]
    
    style Error fill:#ffcdd2,stroke:#d32f2f,stroke-width:2px
    style E1 fill:#ffebee
    style E2A fill:#ffebee
    style E2B fill:#ffebee
    style E3 fill:#ffebee
    style E4 fill:#e8f5e9
    style E5 fill:#e8f5e9
    style E6 fill:#fff3e0
    style Fix1 fill:#c8e6c9
    style Fix2 fill:#c8e6c9
    style Fix3 fill:#c8e6c9
    style Fix4 fill:#c8e6c9
    style Fix5 fill:#c8e6c9
```

---

## 7. Complete Workflow: Start to Finish (End-to-End)

```mermaid
flowchart TD
    Day1Start([Day 1: Fresh clone]) --> Day1Setup["⚙️ ONE-TIME SETUP<br/>1. Install Flutter<br/>2. pub get<br/>3. build_runner<br/>4. .env + Firebase<br/>5. flutter analyze ✓"]
    
    Day1Setup --> Day1Open["🛠️ Open in AI tool"]
    Day1Open --> Day1Paste["📋 Paste RESUME_PROMPT"]
    Day1Paste --> Day1Confirm["✅ AI confirms<br/>Last session: none<br/>Phase 1: 0/50<br/>Next: Session 1"]
    Day1Confirm --> Day1Go["👉 You: go"]
    
    Day1Go --> S1Loop["🔄 SESSION 1 LOOP<br/>- 8 tasks<br/>- Write foundation models<br/>- build_runner after each<br/>- flutter analyze ✓"]
    
    S1Loop --> S1Done["✅ All 8 tasks done<br/>- Update progress_log<br/>- Update codebase_map<br/>- Update current_state<br/>- Mark session ✅"]
    
    S1Done --> S1Commit["📝 Show commit msg:<br/>feat(phase1): foundation models + rebrand (session 1)"]
    S1Commit --> Day1You["👉 You: git commit"]
    
    Day1You --> Day2Start([Day 2: Resume])
    
    Day2Start --> Day2Pull["$ git pull"]
    Day2Pull --> Day2Open2["🛠️ Open in AI tool"]
    Day2Open2 --> Day2Paste2["📋 Paste RESUME_PROMPT"]
    Day2Paste2 --> Day2Confirm2["✅ AI confirms<br/>Last session: Session 1<br/>Phase 1: 8/50<br/>Next: Session 2"]
    Day2Confirm2 --> Day2Go["👉 You: go"]
    
    Day2Go --> S2Loop["🔄 SESSION 2 LOOP<br/>- 6 tasks<br/>- Profile + POI scaffold<br/>- build_runner after each<br/>- flutter analyze ✓"]
    
    S2Loop --> S2Done["✅ All 6 tasks done<br/>- Update progress_log<br/>- Update codebase_map<br/>- Update current_state"]
    
    S2Done --> S2Commit["📝 Show commit msg:<br/>feat(phase1): profile experience + poi scaffold (session 2)"]
    S2Commit --> Day2You["👉 You: git commit"]
    
    Day2You --> Repeat["... Repeat for Sessions 3-11 ..."]
    
    Repeat --> S11["🔄 SESSION 11 (VERIFY)<br/>- End-to-end tests<br/>- All Phase 1 checklist"]
    
    S11 --> S11Done["✅ Phase 1 verification<br/>- Update current_state<br/>- Prepare Phase 2"]
    
    S11Done --> S11Commit["📝 feat(phase1): phase 1 mvp complete (session 11)"]
    S11Commit --> TagCommit["$ git tag phase-1-mvp-complete"]
    
    TagCommit --> Phase2Start["🎉 Phase 2 starts tomorrow<br/>Create docs/batches/phase_2_batches.md<br/>Update RESUME_PROMPT<br/>Same workflow continues"]
    
    style Day1Start fill:#e1f5ff,stroke:#01579b,stroke-width:2px
    style Day1Setup fill:#fff3e0
    style Day1Confirm fill:#c8e6c9
    style S1Loop fill:#fce4ec
    style S1Done fill:#c8e6c9
    style Day2Start fill:#e0f2f1,stroke:#00695c,stroke-width:2px
    style Day2Confirm2 fill:#c8e6c9
    style S2Loop fill:#fce4ec
    style S2Done fill:#c8e6c9
    style S11 fill:#f3e5f5
    style Phase2Start fill:#c8e6c9,stroke:#2e7d32,stroke-width:3px
```

---

## 8. Context Flow: How Information Moves

```mermaid
graph LR
    subgraph "Session N-1 (Yesterday)"
        S_N_1_Code["Write code<br/>Session N-1"]
        S_N_1_Tests["flutter analyze ✓<br/>All clean"]
        S_N_1_Update["Update docs/<br/>- progress_log<br/>- codebase_map<br/>- current_state<br/>- tasks.csv<br/>- notion_tracker"]
        S_N_1_Commit["git commit<br/>Session N-1"]
        
        S_N_1_Code --> S_N_1_Tests
        S_N_1_Tests --> S_N_1_Update
        S_N_1_Update --> S_N_1_Commit
    end
    
    S_N_1_Commit --> Push["git push<br/>to origin/main"]
    
    subgraph "Session N (Today)"
        S_N_Start["git pull<br/>Get Session N-1 commits"]
        S_N_Paste["Paste RESUME_PROMPT"]
        S_N_Read["AI reads in order:<br/>- Tier 1: Rules<br/>- Tier 2: Strategy<br/>- Tier 3: Current state<br/>  (includes yesterday's<br/>   progress_log entry)<br/>- Tier 4: The plan"]
        S_N_Confirm["AI outputs:<br/>Last session: Session N-1<br/>Next: Session N"]
        S_N_Code["Write code<br/>Session N"]
        S_N_Tests["flutter analyze ✓"]
        S_N_Update["Update docs/<br/>- progress_log<br/>- codebase_map<br/>- current_state"]
        S_N_Commit["git commit<br/>Session N"]
        
        S_N_Start --> S_N_Paste
        S_N_Paste --> S_N_Read
        S_N_Read --> S_N_Confirm
        S_N_Confirm --> S_N_Code
        S_N_Code --> S_N_Tests
        S_N_Tests --> S_N_Update
        S_N_Update --> S_N_Commit
    end
    
    Push --> S_N_Start
    S_N_Commit --> NextDay["Next day:<br/>git pull<br/>repeat"]
    
    style S_N_1_Code fill:#fff3e0
    style S_N_1_Commit fill:#c8e6c9
    style S_N_Read fill:#f3e5f5,stroke:#6a1b9a,stroke-width:2px
    style S_N_Confirm fill:#c8e6c9
    style S_N_Code fill:#fff3e0
    style S_N_Commit fill:#c8e6c9
    style NextDay fill:#e0f2f1,stroke:#00695c,stroke-width:2px
```

---

## Summary: The 7-Step AI Developer Checklist

```
Day 1: Fresh Clone
─────────────────────────────────────────────────────────────
 1. ✓ Clone repo
 2. ✓ Install Flutter + run pub get + build_runner
 3. ✓ Drop in .env + Firebase configs
 4. ✓ flutter analyze (should be clean)
 5. ✓ Open in AI tool
 6. ✓ Paste RESUME_PROMPT (section 1 only)
 7. ✓ Wait for 4-line confirmation from AI
 8. ✓ Say "go" to start Session 1

Day 2+: Resume
─────────────────────────────────────────────────────────────
 1. ✓ git pull (get yesterday's commit)
 2. ✓ Open in AI tool (can be different tool)
 3. ✓ Paste RESUME_PROMPT (section 1 only)
 4. ✓ Wait for 4-line confirmation from AI
 5. ✓ Say "go" to start next session
 6. ✓ When session finishes, git commit (user does this)
 7. ✓ Repeat daily

Per-Session Loop (AI does this)
─────────────────────────────────────────────────────────────
 FOR each task in session:
   1. ✓ Write code
   2. ✓ If Freezed changed: dart run build_runner
   3. ✓ flutter analyze
   4. ✓ Update tasks.csv (mark Done)
   5. ✓ Update notion_tracker (tick box)

 After all tasks:
   1. ✓ Append to progress_log.md
   2. ✓ Refresh codebase_map.md
   3. ✓ Refresh current_state.md
   4. ✓ Mark session ✅ in batches file
   5. ✓ Show commit message
   6. ✓ STOP (user commits)
```

---

**See `docs/AI_DEVELOPMENT_WORKFLOW.md` for the complete written guide with all details, examples, and error recovery procedures.**
