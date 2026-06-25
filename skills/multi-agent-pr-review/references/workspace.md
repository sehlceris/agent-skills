# Workspace Reference

Two things must be in place before review begins: the **review folder** (where roles write) and the **checkout precondition** (what they review). The review folder layout is defined in `SKILL.md`. This file covers the checkout precondition and how to verify it.

## Checkout precondition

This skill reviews two checkouts plus a diff inventory. It does **not** create them — how they come to exist depends on the host (CI checkout, fresh clone, local worktrees) and is out of scope. A repository may supply a supplemental skill that produces them; otherwise the project lead produces them by hand. Either way, before review the following must hold:

1. A **head** checkout exists — the PR branch's code.
2. A **base** checkout exists at the **merge-base** of head and the target branch — *not* the target branch's current tip. Using the tip pulls in unrelated commits landed after the PR branched and pollutes the diff with changes the PR did not make.
3. A **diff inventory** derived from those two checkouts is available (changed files and per-file patches).
4. The agents know where all three are. The mechanism (paths, env vars, a manifest — whatever the setup used) is not dictated here.

## Verify before spending tokens

Validate the contract on whatever paths you were given:

```bash
scripts/verify_workspace.sh <base_path> <head_path> <diff_inventory_path>
```

It confirms both checkouts exist and are git working trees, that base is an ancestor of head (catching the target-tip mistake), and that the inventory is present and non-empty. If it fails, stop and report — do not review an unverified workspace.
