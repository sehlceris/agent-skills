---
name: multi-agent-pr-review
description: Run a structured, analysis-only pull request review using an orchestrator, several scoped specialist reviewers, and a synthesizer.
---

# Multi-Agent Pull Request Review

An orchestrator coordinates scoped specialist reviewers and a synthesizer to turn a PR diff into one prioritized list of suggested improvements, structured for handoff: a project lead marks each item fix or won't-fix, then a fix orchestrator acts on the approved items.

Each role owns one thing — the orchestrator plans and dispatches, each specialist investigates one narrow lane, the synthesizer merges and prioritizes. Don't collapse roles: when dispatch is possible, the orchestrator dispatches rather than reviewing itself.

Reviews are **static analysis only** — agents read diffs and surrounding code; they do not run the app, execute tests, or reproduce CI.

## Flow

```
Workspace precondition satisfied (references/workspace.md)
         │
         ▼
Orchestrator ──▶ writes triage.md, dispatches specialists
         │
         ├──▶ Specialist A ──▶ findings/01-<lane>.md
         ├──▶ Specialist B ──▶ findings/02-<lane>.md
         └──▶ Specialist C ──▶ findings/03-<lane>.md
         │
         ▼
Synthesizer ──▶ reads triage.md + findings/*.md ──▶ writes handoff.md
         │
         ▼
project lead triage ──▶ fix orchestrator
```

## Review folder

The project lead specifies a review folder. All roles read and write inside it using this fixed layout — this _is_ the handoff mechanism, so every role knows where its inputs and outputs live without being told per-run:

```
<review_dir>/
  triage.md            # orchestrator: PR sizing, roster, per-specialist assignment contracts
  findings/
    NN-<lane>.md       # one report per specialist; NN is a zero-padded id (01-correctness.md)
  handoff.md           # synthesizer: the final prioritized improvement list
```

Ownership: the orchestrator creates `triage.md` and the `findings/` directory and assigns each specialist its `findings/NN-<lane>.md` path; each specialist writes only its own file; the synthesizer reads `triage.md` plus every `findings/*.md` and writes `handoff.md`. Treat existing files as inputs — don't clobber another role's file.

## How to run

1. **Verify** the workspace precondition — read `references/workspace.md`.
2. **Triage and dispatch** as the orchestrator — read `references/orchestrator.md`.
3. **Review each lane** — each specialist reads `references/specialist.md`, reviews only its assigned lane, and writes `findings/NN-<lane>.md`.
4. **Synthesize** — merge the reports into `handoff.md` — read `references/synthesizer.md`. Filled example in `assets/example-handoff.md`.
