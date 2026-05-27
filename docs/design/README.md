# TripPlus — Design

This folder is the **design source-of-truth** for AI UI generators (Stitch by Google, Figma AI, Galileo, v0, Uizard, Lovable, Cursor) and any human designer.

## Files

| File | Purpose |
|---|---|
| `UI_GENERATION_PROMPT.md` | Master prompt. Sections 1–8 cover product context, design system, screen briefs, state coverage, quality bar, prompt-chaining playbook, deliverables, anti-patterns. |

## How to use

1. Open a UI tool (Stitch / Figma AI / v0 / Cursor with image-mode / etc.).
2. Start a fresh chat.
3. Paste **Section 1 + Section 2 + Section 4 + Section 5** of `UI_GENERATION_PROMPT.md` as the first message — this anchors product context, design system, state coverage, quality bar.
4. Append **one screen brief** from Section 3 per generation.
5. For follow-up screens use the short re-anchor template at the top of Section 6.
6. If the model drifts, paste the correction template in Section 6C.

## Tips for best results

- **Generate one screen at a time.** Multi-screen requests in a single turn dilute quality.
- **Always ask for state frames** (Default / Loading / Empty / Offline / Error_Network / Error_Permission). It is included in Section 4 — do not skip it.
- **Keep Indian sample data** in every prompt: Pune → Nashik trip, BPCL/HPCL pumps, "Hotel Sai Pure Veg", etc. Real-feeling data drives better hierarchy decisions.
- **Lock the tokens.** If the tool insists on changing the color, paste the fix-up template (6C) and re-render.
- **Save styles to Figma local styles** the first time you accept a screen. After that, all subsequent screens will inherit them via the library.
- For **Stitch by Google specifically**: paste Section 1 + 2 once at the start of a "project", then ask one screen at a time using the short template.
- For **Figma AI**: use the same flow but expect to manually create components after — Figma AI is best for layout exploration, not final components.
- For **v0 / Lovable / Cursor**: they output code (React/Tailwind). Map the tokens in Section 2 to Tailwind config first — see notes inline in Section 2.

## When the design is ready

- Hand off to development by exporting tokens (color + type) and the components library from Figma.
- Keep `docs/architecture/user_workflow.md` and `docs/architecture/user_interactions.md` synced with any new screens or interactions discovered during design — these two files are the bridge between design and code.
