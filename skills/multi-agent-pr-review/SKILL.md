---
name: multi-agent-pr-review
description: Run a structured, analysis-only pull request review using an orchestrator, several scoped specialist reviewers, and a synthesizer. The synthesizer emits a single prioritized list of suggested improvements ready to hand off to a fix orchestrator. Use this whenever the user wants to review a PR, diff, or branch in depth — especially when they mention multi-agent review, splitting a review across reviewers, prioritizing review findings, or producing a fix/wontfix handoff. Trigger even if the user just says "review this PR thoroughly" without naming the process.
---

# Multi-Agent Pull Request Review

An orchestrator coordinates several scoped specialist reviewers and a synthesizer to turn a PR diff into a single prioritized list of suggested improvements. The list is structured for handoff: a human project lead marks each item fix or won't-fix and optionally steers it, then a fix orchestrator acts on the approved items.

Each role owns one thing. The orchestrator plans and dispatches. Specialists investigate a narrow lane. The synthesizer merges and prioritizes. A human project lead decides what to act on, defer, or dismiss. Do not collapse roles — when dispatch is possible, the orchestrator dispatches rather than reviewing itself.

Reviews are **static analysis only**: agents read diffs and surrounding code. They do not run the application, execute tests, or reproduce CI failures.

## Flow

```
Workspace satisfies the precondition (see below)
         │
         ▼
Orchestrator (triage + dispatch)
         │
         ├──▶ Specialist A ──▶ findings report
         ├──▶ Specialist B ──▶ findings report
         └──▶ Specialist C ──▶ findings report
         │
         ▼
Synthesizer (merge + prioritize)
         │
         ▼
Prioritized improvement list  ──▶  project lead triage  ──▶  fix orchestrator
```

## Workspace precondition

This skill reviews two checkouts. It does **not** create them — how they come to exist depends on the host repository (CI checkout, fresh clone, local worktrees) and is out of scope here. A repository may supply a supplemental skill that produces them; otherwise the caller produces them by hand. Either way, before review begins the following must hold:

1. A **head** checkout exists — the PR branch's code.
2. A **base** checkout exists at the **merge-base** of head and the target branch — *not* the target branch's current tip. Using the tip pulls in unrelated commits landed after the PR branched and pollutes the diff with changes the PR did not make.
3. A **diff inventory** derived from those two checkouts is available (changed files and per-file patches).
4. The agents know where all three are. The mechanism (paths, env vars, a manifest — whatever the setup used) is not dictated here.

Before spending tokens on review, validate the contract on whatever paths you were given:

```bash
scripts/verify_workspace.sh <base_path> <head_path> <diff_inventory_path>
```

It confirms both checkouts exist, that base is an ancestor of head (catching the target-tip mistake), and that the inventory is present and non-empty. If it fails, stop and report — do not review an unverified workspace.

## How to run a review

1. **Verify** the workspace precondition (above).
2. **Triage and dispatch** — act as the orchestrator. Read `references/orchestrator.md`.
3. **Review each lane** — each specialist reads `references/specialist.md`, reviews only its assigned lane and scope, and writes a findings report.
4. **Synthesize** — merge the reports into the prioritized handoff list. Read `references/synthesizer.md`. The exact item shape and the fix/won't-fix semantics live there; a short filled example is in `assets/example-handoff.md`.

## References

- `references/orchestrator.md` — triage, PR-size→specialist-count, clustering, assignment contracts. Read when acting as the orchestrator.
- `references/specialist.md` — review lanes and the findings-report contract. Read when acting as a specialist.
- `references/synthesizer.md` — synthesis steps, the handoff item shape, fix/won't-fix and lead-comment semantics. Read when acting as the synthesizer.
- `assets/example-handoff.md` — a short, high-signal example of the output artifact. Match its tone: concise, high-signal, enough context to act without re-explaining the obvious.
