# CROSS Skills Suite

Natural-language skill suite for the **CROSS Chain** (id `612055`) ecosystem, packaged for [Claude Code](https://claude.com/claude-code).

> **All 10 services live:** [DEX](https://github.com/to-nexus/skill-cross-dex-trade), [Prediction](https://github.com/to-nexus/skill-cross-prediction), [Forge](https://github.com/to-nexus/skill-cross-forge), [Bridge (CrossDefi)](https://github.com/to-nexus/skill-cross-crossd), [Rewards](https://github.com/to-nexus/skill-cross-rewards), [NFT](https://github.com/to-nexus/skill-cross-nft), [Shop](https://github.com/to-nexus/skill-cross-shop), [Explorer](https://github.com/to-nexus/skill-cross-explorer), [Wave](https://github.com/to-nexus/skill-cross-wave), [Stake](https://github.com/to-nexus/skill-cross-stake).

---

## Install — pick any path

### Path A — Marketplace (recommended)

```bash
/plugin marketplace add github.com/to-nexus/cross-skills-suite
/plugin install cross-dex-trade@cross-skills-suite
/plugin install cross-prediction@cross-skills-suite
/plugin install cross-crossd@cross-skills-suite
/plugin install cross-rewards@cross-skills-suite
/plugin install cross-nft@cross-skills-suite
/plugin install cross-shop@cross-skills-suite
/plugin install cross-explorer@cross-skills-suite
/plugin install cross-forge@cross-skills-suite
/plugin install cross-wave@cross-skills-suite
/plugin install cross-stake@cross-skills-suite
```

Plugins update automatically when this marketplace is refreshed (`/plugin marketplace update cross-skills-suite`).

### Path B — Single skill (standalone)

Install one skill at a time without the marketplace layer:

```bash
git clone https://github.com/to-nexus/skill-cross-dex-trade
bash skill-cross-dex-trade/install.sh
```

Or for Prediction:

```bash
git clone https://github.com/to-nexus/skill-cross-prediction
bash skill-cross-prediction/install.sh
```

### Path C — All-in-one bootstrap

One command, all active skills:

```bash
curl -fsSL https://raw.githubusercontent.com/to-nexus/cross-skills-suite/main/bootstrap.sh | bash
```

Installs into `${CROSS_SKILLS_DIR:-$HOME/cross-skills}`, then chains each skill's `install.sh` to symlink into `~/.claude/skills/`. Idempotent — re-run to update.

For development (full git history), clone manually first:

```bash
git clone https://github.com/to-nexus/cross-skills-suite
bash cross-skills-suite/bootstrap.sh
```

### Path D — OpenClaw

Each service that supports OpenClaw ships an `assets/SOUL.template.md` you can stage into a workspace:

```bash
mkdir -p ~/.openclaw/workspaces/cross-dex
cp ~/.claude/skills/cross-dex-trade/assets/SOUL.template.md ~/.openclaw/workspaces/cross-dex/SOUL.md
ln -s ~/.claude/skills/cross-dex-trade/.env ~/.openclaw/workspaces/cross-dex/.env
```

Then drive it via Claude with phrases like *"openclaw로 RUBYx 10개 매수해줘"*.

| Service | OpenClaw |
|---------|----------|
| DEX | ✅ |
| Prediction | — (uses internal Strategy A/B/C dispatcher) |
| Bridge (CrossDefi) | — (EOA + viem direct) |
| Rewards | — (EOA + viem direct) |
| NFT | — (EOA + viem direct) |
| Shop | — (REST API + on-chain payment) |
| Explorer | — (read-only RPC/REST) |

---

## Service catalog

| # | Service | Repo | Description |
|---|---------|------|-------------|
| 1 | **DEX (Gametoken)** | [skill-cross-dex-trade](https://github.com/to-nexus/skill-cross-dex-trade) | Game token orderbook trading (limit buy/sell, cancel, balance, pair listing) |
| 2 | **Prediction** | [skill-cross-prediction](https://github.com/to-nexus/skill-cross-prediction) | YES/NO Share trading on `prediction.crossdefi.io` via 3 signing strategies |
| 4 | **Bridge (CrossDefi)** | [skill-cross-crossd](https://github.com/to-nexus/skill-cross-crossd) | Swap-bridge across BSC / CROSS Chain / Klaytn — pairs, quote with fees, native / EIP-2612 permit / approve+bridgeToken auto-dispatch |
| 5 | **Rewards** | [skill-cross-rewards](https://github.com/to-nexus/skill-cross-rewards) | WCROSS staking — pool query, deposit (with optional native→WCROSS wrap), withdraw, multi-token harvest |
| 6 | **NFT** | [skill-cross-nft](https://github.com/to-nexus/skill-cross-nft) | NFT marketplace — collections / token / listings / offers / activities / stats (GraphQL read) + MarketplaceV1 trades |
| 7 | **Shop** | [skill-cross-shop](https://github.com/to-nexus/skill-cross-shop) | cross.shop game web-shop — browse games (rohan2 / seal-m / rom), products, on-chain payment escrow |
| 8 | **Explorer** | [skill-cross-explorer](https://github.com/to-nexus/skill-cross-explorer) | Read-only Blockscout v2 explorer (crossscan.io) — addresses, txs, tokens, blocks, mainnet + testnet |
| 3 | **Forge** | [skill-cross-forge](https://github.com/to-nexus/skill-cross-forge) | Token launch + bonding-curve trade — deploy game/AI-agent tokens, create pools, browse trending, quote / buy / sell, portfolio, activity feed |
| 9 | **Wave** | [skill-cross-wave](https://github.com/to-nexus/skill-cross-wave) | CROSS WAVE Streamer-Economy — anon read of info / missions / campaigns + paste-token auth for login / referral / submit |
| 10 | **Stake** | [skill-cross-stake](https://github.com/to-nexus/skill-cross-stake) | CROSS Mainnet 2.0 native-CROSS staking — single-pool stake/unstake/claimUnstake on `stake.ogfcorp.com`, posa-api read-path (no auth) for position / rewards / history / network-stats, 14-day unbonding cooldown surfaced as `withdrawAvailableAt` |

All 10 services in the suite are published. See [CHECKLIST.md](./CHECKLIST.md) for per-service rollout dates and status.

---

## Usage examples

After installing one or more skills, just describe in natural language:

```
buy 31 RUBYx at 0.128 CROSS
show CROSS balance
list active gametoken pairs
cancel order 12345 on RUBYx

list active prediction events
BTC 1분 예측 이벤트 찾아줘
buy 10 YES shares of <event> at max 0.55 BILL/share
show settled results for event <id>

list bridge pairs
quote 1 USDT BSC to CROSS
bridge 10 native CROSS to BSC
permit-hash status 12345

show CROSS NFT collections
list activities for NFT collection 0x...
buy NFT token <id> from listing <id>

list cross.shop games
show rohan2 products
buy item <productId> from rohan2

look up tx 0xabcd... on crossscan
show address 0x... activity
get latest blocks on CROSS Chain
```

Each skill's README has full activation triggers and CLI fallback commands.

---

## Architecture

3-layer Hybrid distribution: per-service repos + this umbrella + 4 install paths. See [docs/ARCHITECTURE.md](./docs/ARCHITECTURE.md) for the diagram and rationale.

## Adding a new service

See [docs/ONBOARDING-NEW-SERVICE.md](./docs/ONBOARDING-NEW-SERVICE.md) — 6-step procedure with the 3-file sync invariant (`marketplace.json` ↔ `services.list` ↔ `CHECKLIST.md`).

## Safety model

Every skill in this suite enforces:
- **Chain-id check.** All RPC clients verify `eth_chainId == 612055` before any signed transaction.
- **Per-trade notional cap** (`MAX_TRADE_CROSS` / `MAX_TRADE_BILL`). Hard abort above the cap.
- **Confirmation prompt** for trades over a threshold.
- **Secrets stay local.** PRIVATE_KEY / PIN / session JWT never appear in transcript, argv, or logs. `.env` / `.auth/` / `.session/` are gitignored everywhere.

## License

[MIT](./LICENSE).
