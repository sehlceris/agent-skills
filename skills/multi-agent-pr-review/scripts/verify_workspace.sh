#!/usr/bin/env bash
# Validate the review workspace precondition.
#
# Usage:
#   verify_workspace.sh <base_path> <head_path> <diff_inventory_path>
#
# Checks, on whatever paths it is handed (it does NOT discover them):
#   1. base and head checkouts exist and are git working trees
#   2. base is an ancestor of head (i.e. base is the merge-base, not the
#      target-branch tip — this is the invariant that keeps the diff honest)
#   3. the diff inventory exists and is non-empty
#
# Exits non-zero with a message on the first failure. Dictates no layout:
# how the paths were produced and where they live is the caller's business.

set -euo pipefail

if [ "$#" -ne 3 ]; then
  echo "usage: verify_workspace.sh <base_path> <head_path> <diff_inventory_path>" >&2
  exit 2
fi

base_path=$1
head_path=$2
diff_inventory=$3

fail() { echo "workspace verification failed: $1" >&2; exit 1; }

# 1. Both checkouts exist and are working trees.
[ -d "$base_path" ] || fail "base checkout not found at: $base_path"
[ -d "$head_path" ] || fail "head checkout not found at: $head_path"
git -C "$base_path" rev-parse --is-inside-work-tree >/dev/null 2>&1 \
  || fail "base path is not a git working tree: $base_path"
git -C "$head_path" rev-parse --is-inside-work-tree >/dev/null 2>&1 \
  || fail "head path is not a git working tree: $head_path"

base_sha=$(git -C "$base_path" rev-parse HEAD)
head_sha=$(git -C "$head_path" rev-parse HEAD)

# 2. base must be an ancestor of head. If it is not, base is almost certainly
#    the target-branch tip rather than the merge-base, which silently pollutes
#    the diff with commits the PR did not make.
if [ "$base_sha" = "$head_sha" ]; then
  fail "base and head point at the same commit ($base_sha) — nothing to review"
fi
if ! git -C "$head_path" merge-base --is-ancestor "$base_sha" "$head_sha" 2>/dev/null; then
  fail "base ($base_sha) is not an ancestor of head ($head_sha) — base should be the merge-base, not the target-branch tip"
fi

# 3. Diff inventory present and non-empty.
[ -e "$diff_inventory" ] || fail "diff inventory not found at: $diff_inventory"
if [ -d "$diff_inventory" ]; then
  [ -n "$(ls -A "$diff_inventory" 2>/dev/null)" ] || fail "diff inventory directory is empty: $diff_inventory"
else
  [ -s "$diff_inventory" ] || fail "diff inventory file is empty: $diff_inventory"
fi

echo "workspace OK  base=${base_sha:0:12}  head=${head_sha:0:12}  inventory=$diff_inventory"
