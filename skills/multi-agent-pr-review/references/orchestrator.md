# Orchestrator Reference

You are the orchestrator. You plan and dispatch; you do not review yourself when dispatch is possible. Your output is a triage plan that assigns scoped specialists to lanes.

## Read before planning

Read the PR summary, any project-lead notes (focus areas, validation expectations), and the diff inventory. Then **sample the hotspot diffs** — the largest or riskiest changes — not just filenames. Filenames tell you what moved; the diffs tell you what's actually at risk.

## Size the review

PR size sets the default specialist count. Adjust with a stated rationale when the change's risk doesn't match its size (a tiny diff to auth logic can warrant more; a huge mechanical rename can warrant fewer).

| Size   | Typical scope                 | Specialists |
| ------ | ----------------------------- | ----------- |
| Small  | <10 files, <400 lines         | 2–3         |
| Medium | 10–40 files or 400–1500 lines | 3–4         |
| Large  | >40 files or >1500 lines      | 4–7         |

## Plan the roster

1. **Cluster** touched files into subsystems or workflows.
2. **Map risk lanes** (see `specialist.md`) onto those clusters.
3. **Prefer narrow specialists** over broad ones — a reviewer with a focused scope finds more than one asked to look at everything.
4. **Assign each specialist a stable id and output path.** Number them `01`, `02`, … and give each its file `findings/NN-<lane>.md` (e.g. `findings/01-correctness.md`). If two specialists share a lane over distinct subsystems, disambiguate the suffix (`02-correctness-api.md`).

## Record the plan

Create the review folder's `findings/` directory, then write `triage.md` at the review-folder root. It holds, for each specialist: its id, lane, file scope, the concrete questions it must answer, the severity standard, and its `findings/NN-<lane>.md` output path. The synthesizer reads `triage.md` to know what was dispatched, so an omitted specialist is an invisible gap — list every one.

## Dispatch rules

- **Shard by area, not by duplicating the same lane over the same files.** Two reviewers on the same lane and files just doubles the work.
- **Multiple reviewers in one lane are fine when the PR spans distinct subsystems** (e.g. a UI flow and an API surface are both correctness, but different enough to split).
- **Give each specialist an explicit assignment contract**: its scope (which files/clusters), the questions to answer, the severity standard, and its `findings/NN-<lane>.md` output path. A specialist with a vague contract returns vague findings.

## Handoff

Once `triage.md` is written and contracts are assigned, dispatch the specialists. They review in parallel and each writes its own `findings/NN-<lane>.md`. When the reports are in, the synthesizer takes over (`synthesizer.md`).
