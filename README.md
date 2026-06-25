# sehlceris-agent-skills

A personal collection of generalizable [agent skills](https://www.skills.sh/) I maintain for my own use. Public — you're welcome to use them too.

Each skill is a self-contained directory under `skills/`, following the [Agent Skills](https://www.skills.sh/) standard (a `SKILL.md` with YAML frontmatter, optionally plus `references/`, `scripts/`, and `assets/`).

## Install

Skills are installable with the [`skills` CLI](https://www.skills.sh/):

```bash
# install everything in this repo
npx skills add sehlceris/sehlceris-agent-skills

# or pick a single skill
npx skills add sehlceris/sehlceris-agent-skills/multi-agent-pr-review
```

This copies the skill(s) into your agent's skills directory (e.g. `.claude/skills/`).

## Skills

| Skill | Description |
| --- | --- |
| [`multi-agent-pr-review`](skills/multi-agent-pr-review/) | Structured, analysis-only PR review run as an orchestrator → scoped specialist reviewers → synthesizer, producing one prioritized fix/won't-fix handoff list. |

## Repository layout

```
skills/
  <skill-name>/
    SKILL.md        # required: frontmatter (name, description) + instructions
    references/     # optional: deeper docs the skill reads on demand
    scripts/        # optional: helper scripts the skill invokes
    assets/         # optional: examples and templates
```

The `skills` CLI walks the `skills/` directory to discover each `SKILL.md`; no root manifest is required.

## License

MIT
