# CROSS Skills Suite — Service Rollout Checklist

| # | Service | Repo | SKILL.md | install.sh | marketplace 등록 | 자격증명 | 실행 모드 | OpenClaw | Owner | 출시일 |
|---|---------|------|----------|-----------|------------------|----------|-----------|----------|-------|--------|
| 1 | DEX (GameToken swap + liquidity) | ✅ [skill-cross-dex-trade](https://github.com/to-nexus/skill-cross-dex-trade) | ✅ | ✅ | ✅ | EOA `PRIVATE_KEY` | API quote + AMM liquidity quote + On-chain TX | ✅ | to-nexus | 2026-04-29; swap/liquidity migration 2026-06-09 |
| 2 | Prediction | ✅ [skill-cross-prediction](https://github.com/to-nexus/skill-cross-prediction) | ✅ | ✅ | ✅ | A: `PRIVATE_KEY` / B·C: `PIN`+session | Mixed (TX + UI auto) | — | to-nexus | 2026-04-29 |
| 3 | Forge | ✅ [skill-cross-forge](https://github.com/to-nexus/skill-cross-forge) | ✅ | ✅ | ✅ | EOA `PRIVATE_KEY` (deploy + trade) | On-chain TX (Builder API + Router) + bonding-curve REST | — | to-nexus | 2026-05-06 (v0.4) |
| 4 | Bridge (CrossDefi) | ✅ [skill-cross-crossd](https://github.com/to-nexus/skill-cross-crossd) | ✅ | ✅ | ✅ | EOA `PRIVATE_KEY` (read-path needs none) | On-chain TX (native / approve) + offline EIP-712 (permit) | — | to-nexus | 2026-04-30 |
| 5 | Rewards | ✅ [skill-cross-rewards](https://github.com/to-nexus/skill-cross-rewards) | ✅ | ✅ | ✅ | EOA `PRIVATE_KEY` | On-chain TX (WCROSS staking) | — | to-nexus | 2026-04-29 |
| 6 | NFT | ✅ [skill-cross-nft](https://github.com/to-nexus/skill-cross-nft) | ✅ | ✅ | ✅ | EOA `PRIVATE_KEY` | GraphQL read + On-chain TX (MarketplaceV1) | ✅ (planned) | to-nexus | 2026-05-04 |
| 7 | Shop | ✅ [skill-cross-shop](https://github.com/to-nexus/skill-cross-shop) | ✅ | ✅ | ✅ | Game UUID (login) + EOA `PRIVATE_KEY` (payment) | REST API + On-chain payment escrow | ? | to-nexus | 2026-05-04 (v0.1.0-rc.skeleton — only `games` works) |
| 8 | Explorer | ✅ [skill-cross-explorer](https://github.com/to-nexus/skill-cross-explorer) | ✅ | ✅ | ✅ | none (read-only) | Public RPC/REST (Blockscout v2) | — | to-nexus | 2026-05-04 (v0.1.0) |
| 9 | Wave | ✅ [skill-cross-wave](https://github.com/to-nexus/skill-cross-wave) | ✅ | ✅ | ✅ | read: none / auth: paste-token JWT (CROSSx OAuth) | REST API + paste-token auth | — | to-nexus | 2026-05-06 (v0.2) |
| 10 | Stake | ✅ [skill-cross-stake](https://github.com/to-nexus/skill-cross-stake) | ✅ | ✅ | ✅ | read: none / write: EOA `PRIVATE_KEY` (CROSSx wallet users must export key) | posa-api REST read + On-chain TX (stake/unstake/claimUnstake) | — | to-nexus | 2026-05-08 (v0.3.0) |

> Legend: ✅ done · ⏳ planned/in-progress · — not applicable · ? to be evaluated

## 새 서비스 추가 절차

[`docs/ONBOARDING-NEW-SERVICE.md`](./docs/ONBOARDING-NEW-SERVICE.md) 참고. 6 step / 3 file invariant.
