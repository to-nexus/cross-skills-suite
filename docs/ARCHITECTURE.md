# CROSS Skills Suite — Architecture

3-Layer Hybrid distribution: per-service repos + this umbrella + 4 install paths.

## 1. Hybrid 3-Layer Diagram

```
┌─────────────────────────────────────────────────────────────────┐
│ Layer 1 — Per-Service Repos (10/10)                              │
│   github.com/to-nexus/skill-cross-dex-trade                      │
│   github.com/to-nexus/skill-cross-prediction                     │
│   github.com/to-nexus/skill-cross-forge                          │
│   github.com/to-nexus/skill-cross-crossd                         │
│   github.com/to-nexus/skill-cross-rewards                        │
│   github.com/to-nexus/skill-cross-nft                            │
│   github.com/to-nexus/skill-cross-shop                           │
│   github.com/to-nexus/skill-cross-explorer                       │
│   github.com/to-nexus/skill-cross-wave                           │
│   github.com/to-nexus/skill-cross-stake │
│                                                                  │
│   각 레포 = Claude Code Plugin 단위. 단독 설치 가능.              │
└─────────────────────────────────────────────────────────────────┘
                                ▲
                                │ marketplace.json source.repo
                                │ services.list URL
                                │
┌─────────────────────────────────────────────────────────────────┐
│ Layer 2 — Umbrella (this repo)                                  │
│   .claude-plugin/marketplace.json   ← Path A 진입               │
│   bootstrap.sh + services.list      ← Path C 진입               │
│   CHECKLIST.md (10 services)                                    │
│   README, docs/                                                 │
└─────────────────────────────────────────────────────────────────┘
                                ▼
┌─────────────────────────────────────────────────────────────────┐
│ Layer 3 — User-facing Install Paths                             │
│   A. /plugin marketplace add github.com/to-nexus/cross-skills-   │
│        suite ; /plugin install <name>@cross-skills-suite        │
│   B. git clone <per-service-repo> && bash install.sh            │
│   C. curl -fsSL <umbrella>/bootstrap.sh | bash  (전체 일괄)     │
│   D. OpenClaw — assets/SOUL.template.md 복사                    │
└─────────────────────────────────────────────────────────────────┘
```

## 2. Why Hybrid

3 후보 중 Hybrid를 선택한 이유 정리.

| 옵션 | 장점 | 단점 | 선택 |
|---|---|---|---|
| **Hybrid** | 서비스별 독립 버전·이슈·릴리즈, 일괄 진입점, 부분 추가 0-cost | 레포 N+1개 유지 | ✅ |
| Monorepo | CI 단순, 일괄 버전 | 한 서비스 break = 전체 영향, 거대화 | ❌ |
| Flat marketplace (no umbrella) | 가벼움 | 일괄 설치 불가, OpenClaw mass-deploy 어려움 | ❌ |

## 3. Layer 1 — Per-Service Repo 표준 구조

각 `skill-cross-<svc>` 레포는 다음 5개 진입점 (+ skill 본체)로 구성한다:

```
skill-cross-<svc>/
├── .claude-plugin/plugin.json   ← /plugin install 진입
├── install.sh                   ← symlink 설치 (Path B 진입)
├── LICENSE                      ← MIT + 서비스별 disclaimer
├── README.md                    ← 4 install path 안내
├── .gitignore                   ← .env / .auth/ / .session/ 차단 (필수)
└── skills/cross-<svc>/
    ├── SKILL.md                 ← Claude가 읽는 활성화·실행 규칙
    ├── package.json             ← Node deps
    ├── .env.example
    ├── scripts/                 ← *.mjs 서브커맨드 (JSON stdout)
    ├── references/              ← lazy-loaded 컨텍스트
    └── (assets/SOUL.template.md)  ← OpenClaw 지원 시
```

## 4. Layer 2 — Umbrella 책임

| 파일 | 역할 |
|---|---|
| `.claude-plugin/marketplace.json` | Catalog. `/plugin marketplace add github.com/to-nexus/cross-skills-suite` 의 진입점. |
| `services.list` | Bootstrap source of truth. `bootstrap.sh`가 읽어 순차 clone+install. |
| `CHECKLIST.md` | Rollout truth. 10 service 진행 상태. ⏳/✅ |
| `bootstrap.sh` | Path C 1줄 부트스트랩. POSIX bash, idempotent, partial-failure resilient. |
| `README.md` | 4 install path 사용자 안내 + service catalog. |
| `LICENSE` | MIT. |
| `docs/ARCHITECTURE.md` | (this file) |
| `docs/ONBOARDING-NEW-SERVICE.md` | 새 서비스 추가 6-step 절차. |

## 5. Sync Invariant — `marketplace.json` ↔ `services.list` ↔ `CHECKLIST.md`

세 파일은 active set이 일치해야 한다. 새 서비스 추가/제거 시 **한 PR에서 세 파일 모두 업데이트**한다.

| 파일 | 갱신 내용 |
|---|---|
| `marketplace.json` | `plugins[]`에 entry 추가 (source.repo, tags, homepage 등) |
| `services.list` | 해당 라인 추가 또는 uncomment |
| `CHECKLIST.md` | 해당 행 status를 ⏳ → ✅, repo URL 채움, 출시일 기록 |

v1은 **manual via PR review**. v1.1에 `scripts/sync-check.sh` lint 도입 검토.

## 6. Version Model — commit SHA 자동 버전

`marketplace.json`의 plugin entry와 각 per-service `plugin.json`에서 **`version` 필드를 비운다**. Claude Code는 git source 기반에서 commit SHA를 버전으로 사용 — 매 commit이 자동 신규 버전이다.

근거: 공식 [Plugin marketplaces docs](https://code.claude.com/docs/en/plugin-marketplaces)
> *"For the git-based source types github, url, git-subdir, and relative paths inside a git-hosted marketplace, you can omit version entirely and every new commit is treated as a new version."*

⚠️ **주의:** `plugin.json`과 marketplace entry 양쪽에 version을 두면 `plugin.json`이 silent win — 의도하지 않은 pin 발생. 둘 다 비우는 것이 일관된다.

v1.1 안정화 단계에 release channel (stable / latest) 분리 검토.

## 7. Failure Modes

| 상황 | 행동 | 사용자 경험 |
|---|---|---|
| Path C bootstrap에서 한 서비스 install.sh 실패 | 다음 서비스 계속, 마지막에 `Installed: N/M` 출력 + 실패 목록 표시 | 부분 설치 후 재실행으로 복구 가능 |
| Path A `/plugin install` 시 source.repo가 404 | Claude Code가 sync 단계에서 명시적 에러 반환 | 사용자에게 marketplace 갱신 유도 |
| `BILL.approve` / `CTF.setApprovalForAll` 부재 (Prediction Strategy C) | `APPROVAL_GAP` 에러로 즉시 abort | 사용자가 UI에서 1회 manual approve 후 재시도 |
| `services.list`와 `marketplace.json` mismatch | bootstrap.sh는 services.list만 읽음 → marketplace에 있는데 bootstrap에서 빠짐 (또는 vice versa) | v1.1 lint script로 사전 차단; v1은 PR review 책임 |
| GitHub Org 부재/권한 부족 (R-11) | `gh repo create` 실패 | DA:WORK pre-flight 단계에서 차단; 사용자 결정 후 재개 |

## References

- [Plugin marketplaces — Claude Code Docs](https://code.claude.com/docs/en/plugin-marketplaces)
- [anthropics/claude-plugins-official marketplace.json](https://github.com/anthropics/claude-plugins-official/blob/main/.claude-plugin/marketplace.json) — real-world catalog
- ADR-001 — marketplace.json schema 결정 (in source workspace `to-nexus/ara-skills/docs/`)
- ADR-002 — bootstrap clone strategy 결정
