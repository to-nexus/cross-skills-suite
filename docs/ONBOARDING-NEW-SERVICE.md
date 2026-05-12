# Onboarding a New CROSS Service

6 steps to add `skill-cross-<svc>` to the suite.

## 1. Create the per-service repo

Use [`skill-cross-dex-trade`](https://github.com/to-nexus/skill-cross-dex-trade) as a template (`gh repo create --template to-nexus/skill-cross-dex-trade ...`, or fork + customize).

Required files:

| File | Purpose |
|---|---|
| `.claude-plugin/plugin.json` | Plugin manifest. **No `version` field** (commit SHA = version). |
| `install.sh` | Executable, idempotent symlink installer. `chmod +x`. |
| `LICENSE` | MIT + service-specific disclaimer if signing transactions. |
| `README.md` | 4 install paths + activation phrases. |
| `.gitignore` | **Must** exclude `.env`, `.auth/`, `.session/`, `node_modules/`, lock files. |
| `skills/cross-<svc>/SKILL.md` | What Claude reads to drive the skill. |
| `skills/cross-<svc>/package.json` | Node deps. |
| `skills/cross-<svc>/.env.example` | Configuration template. |
| `skills/cross-<svc>/scripts/*.mjs` | Subcommand modules. JSON stdout. |
| `skills/cross-<svc>/references/*.md` | Lazy-loaded context. |

Optional:
- `skills/cross-<svc>/assets/SOUL.template.md` — only if OpenClaw dispatch is meaningful for this service.

## 2. Verify the skill standalone

```bash
git clone https://github.com/to-nexus/skill-cross-<svc>
bash skill-cross-<svc>/install.sh
# Then trigger SKILL.md activation phrases in Claude Code.
```

Confirm `~/.claude/skills/cross-<svc>` is a symlink to the cloned dir.

## 3. Append entry to umbrella `marketplace.json`

```json
{
  "name": "cross-<svc>",
  "description": "<one-line description>",
  "source": {
    "source": "github",
    "repo": "to-nexus/skill-cross-<svc>"
  },
  "author": { "name": "to-nexus" },
  "homepage": "https://github.com/to-nexus/skill-cross-<svc>",
  "license": "MIT",
  "category": "blockchain",
  "tags": ["cross-chain", "<feature1>", "<feature2>"]
}
```

Do **not** include a `version` field — commit SHA is the version.

## 4. Uncomment line in `services.list`

Find the commented line for this service and uncomment it:

```diff
- # https://github.com/to-nexus/skill-cross-<svc>.git
+ https://github.com/to-nexus/skill-cross-<svc>.git
```

If the service is brand new (not pre-listed), add a new line in alphabetical order.

## 5. Update `CHECKLIST.md`

Move the row from `⏳` to `✅`:

| # | Service | Repo | SKILL.md | install.sh | marketplace 등록 | 자격증명 | 실행 모드 | OpenClaw | Owner | 출시일 |
|---|---------|------|----------|-----------|------------------|----------|-----------|----------|-------|--------|
| N | **<Svc>** | ✅ [skill-cross-\<svc\>](https://github.com/to-nexus/skill-cross-<svc>) | ✅ | ✅ | ✅ | ... | ... | ✅ / — | to-nexus | YYYY-MM-DD |

## 6. Verify all 4 install paths

- **Path A** — Marketplace:
  ```bash
  /plugin marketplace update cross-skills-suite
  /plugin install cross-<svc>@cross-skills-suite
  ```
- **Path B** — Standalone clone + install.sh
- **Path C** — `bash bootstrap.sh` from a fresh dir → confirm new service appears in the install summary
- **Path D** — (if applicable) Copy `assets/SOUL.template.md` into `~/.openclaw/workspaces/<svc>/`

Open umbrella PR with all three diffs (`marketplace.json` + `services.list` + `CHECKLIST.md`). The 3-file sync invariant must hold.

## Sync invariant

`.claude-plugin/marketplace.json` ↔ `services.list` ↔ `CHECKLIST.md` 의 active set은 항상 일치해야 한다.

| | marketplace.json | services.list | CHECKLIST.md |
|---|---|---|---|
| Service ready | entry 존재 | 라인 uncomment | row ✅ |
| Service planned | entry 부재 | 라인 commented | row ⏳ |

v1.1에 `scripts/sync-check.sh` 도입 예정. v1은 PR review 책임.
