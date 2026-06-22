# JourneyPlus — `docs/`

This folder is the **knowledge base** of the project — what we're building, how it's wired, and the conventions we follow. Read it from top to bottom on a new machine and you're caught up in ~30 minutes.

## Map

```
docs/
├── README.md                     ← you are here
├── context/                      ← *why* and *what*
│   ├── product_vision.md         ← North star + principles
│   ├── current_state.md          ← Rolling snapshot of what's built
│   ├── glossary.md               ← Plain-English definitions of every term
│   └── decisions.md              ← Architecture Decision Records (ADRs)
├── architecture/                 ← *how* it works
│   ├── system_overview.md        ← Layers + services + diagram
│   ├── data_flow.md              ← Read/write paths with concrete examples
│   ├── user_workflow.md          ← End-to-end user journey
│   ├── user_interactions.md      ← Every option/gesture inventoried
│   ├── feature_map.md            ← Every feature slice, status, task IDs
│   ├── tech_stack.md             ← Libraries used + versions + reasons
│   └── folder_structure.md       ← Where things go in lib/
└── design/                       ← *how* it looks
    ├── README.md                 ← How to use the master prompt
    └── UI_GENERATION_PROMPT.md   ← Master prompt for Stitch / Figma AI / v0 / etc.
```

## Where to start

| If you want to | Read |
|---|---|
| Understand the product | `context/product_vision.md` |
| Know what's currently shipped | `context/current_state.md` |
| Look up a term | `context/glossary.md` |
| Know why we made a decision | `context/decisions.md` |
| See the big picture | `architecture/system_overview.md` |
| Trace data through the app | `architecture/data_flow.md` |
| Design a new screen | `architecture/user_workflow.md` + `architecture/user_interactions.md` |
| Find which feature owns X | `architecture/feature_map.md` |
| Decide where a file goes | `architecture/folder_structure.md` |
| Pick a library | `architecture/tech_stack.md` |
| Generate UI in Stitch / Figma AI / v0 | `design/UI_GENERATION_PROMPT.md` |

## Related

- **`AGENTS.md`** at the repo root — canonical short-form context for AI agents.
- **`project_plan/`** — phased task lists with stable IDs (Notion-importable).
- **`RELIABILITY_PHASES.md`** at root — reliability UX work history.
- **`COMMUNITY_REPORTS.md`** at root — community feature spec.

## Maintenance rule

Treat `docs/context/current_state.md` and `docs/context/decisions.md` as **append-only**. The rest of the architecture docs evolve with the codebase — update them in the same PR that changes the code they describe.
