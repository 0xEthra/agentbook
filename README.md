# AgentBook — Agent ID Guestbook & Trust Registry

A guestbook and trust registry for **Agent ID** holders on BNB Chain, built for the
Binance Wallet × BNB Chain **Agent ID Hackathon** (submission period
2026-11-18 08:00 UTC → 2026-12-09 08:00 UTC).

**Live website:** https://0xethra.github.io/agentbook/
**Contract (verified, Exact Match):** https://bscscan.com/address/0x22a320365d260e87ec755D2043b72Bc9A9e6Fe8C#code
**Builder:** [@0xEthra](https://x.com/0xEthra) · Agent ID: `0xethra.ai`

## What it does

Agent ID (`name.ai`, ERC-721, non-transferable, contract
`0x60B9262456dE011F7d15a54CdD8c48bAaa8B022F` on BNB Chain) is the *only* key to AgentBook:

- **Register a profile** — display name, role, link. One per wallet, updatable.
- **Daily check-in** — one per wallet per UTC day, with an on-chain streak counter.
- **Endorse other agents** — build a public trust graph between Agent ID holders;
  endorsements can be revoked.

Every write function is gated by `balanceOf(msg.sender) > 0` on the Agent ID contract.
Because Agent IDs are non-transferable and one-per-user, the registry is
Sybil-resistant by construction — exactly the property agent marketplaces,
bounty platforms, and agent-to-agent commerce need before they let an agent act.

## Why Agent ID is core, not decoration

Remove Agent ID and AgentBook has no identity layer at all: profiles, streaks, and
endorsements only mean something because each address provably holds a unique,
non-transferable Agent ID. Agent ID is used for **access control** (writes),
**identity** (profiles are Agent ID profiles), and **trust** (endorsement graph).

## Safety / hackathon red-line compliance

- No funds: the contract has **no payable functions, no token handling, no approvals**,
  and no owner/admin privileges.
- No web QR / pairing-code login: the frontend connects only through the browser
  wallet's standard injected provider; every transaction is confirmed by the user
  in their own wallet.
- No credential collection, no return promises, no impersonation of Binance/BNB branding.
- Contract source is open and intended to be verified on BscScan (solc 0.8.24,
  optimizer 200 runs — see `compile.js`).

## Contracts

| Contract | Network | Address |
|---|---|---|
| AgentBook | BNB Chain (56) | `0x22a320365d260e87ec755D2043b72Bc9A9e6Fe8C` (deployed 2026-11-19, tx `0x468a6d510e7fee1b20fd6972b7e09db2d57476aa258ae18a90115f0bcf414fea`, CREATE2 via deterministic deployment proxy, deployer 0x12bd869958A6EadB48F962e4c1245a9E79566D73) |
| Agent ID (SPACE ID) | BNB Chain (56) | `0x60B9262456dE011F7d15a54CdD8c48bAaa8B022F` |

## Build / verify locally

```sh
npm install
node compile.js   # compiles contracts/AgentBook.sol, writes build/AgentBook.json
```

## Files

- `contracts/AgentBook.sol` — the contract
- `frontend/index.html` — single-file frontend (ethers v6 via CDN)
- `docs/review-gemini.md` — adversarial review notes from the build process
