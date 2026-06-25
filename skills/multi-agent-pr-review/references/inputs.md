# Review Inputs Reference

Two things must be in place before review begins: the **review folder** (where roles write, defined in `SKILL.md`) and the **review inputs** (what they review). This file covers the inputs.

## What the review needs access to

1. **The head code** — the PR branch's version of the codebase, readable as full files. The diff alone is not enough: to judge a change a reviewer must read the whole function it lives in, follow its callers and callees, and check the surrounding module. That navigation needs the actual files, not just patch hunks.
2. **A diff inventory** — the list of changed files plus a per-file patch for each. This scopes the review and carries the before/after of every changed line. The diff should be computed against the **merge-base** of the PR and its target branch, not the target's current tip — diffing against the tip folds in unrelated commits landed after the branch forked and pollutes the review with changes the PR did not make.
3. **The original version of changed files, on demand** — so a reviewer can reconstruct the full prior state of a heavily edited file when the patch's context lines aren't enough. For most findings the patch's before-lines suffice; this matters mainly for large refactors.

## How they're provided is out of scope

This skill does not dictate where the inputs come from or what form they take — a script that writes files to disk, the GitHub API or `gh` CLI, local checkouts, a CI artifact, whatever the host uses. Assume the inputs above are available to the agents and that they know how to reach them. If any are missing, stop and report rather than reviewing a partial picture.
