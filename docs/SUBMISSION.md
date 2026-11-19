# Submission pack — Agent ID Hackathon (fill after deploy)

- Project name: AgentBook — Agent ID Guestbook & Trust Registry
- Builder: @0xEthra (Agent ID: 0xethra.ai)
- Website: https://0xethra.github.io/agentbook/ (GitHub Pages, live & verified 2026-11-19)
- Repo: https://github.com/0xEthra/agentbook (public, MIT)
- Contract (BNB Chain): 0x22a320365d260e87ec755D2043b72Bc9A9e6Fe8C
  Deploy tx: 0x468a6d510e7fee1b20fd6972b7e09db2d57476aa258ae18a90115f0bcf414fea
  (CREATE2 via deterministic deployment proxy 0x4e59b44847b379578588920cA78FbF26c0B4956C,
  salt 0x01, deployer 0x12bd869958A6EadB48F962e4c1245a9E79566D73, gas used 1,001,297,
  on-chain runtime bytecode verified identical to local build on 2 RPCs.)
  Verify source on BscScan with solc 0.8.24 exact, optimizer enabled, 200 runs,
  no constructor args.
  Verification status: Sourcify EXACT_MATCH (creation + runtime, matchId 59488364,
  verified 2026-11-18T20:42:41Z); Sourcify forwarded the verification to
  Etherscan/BscScan (their verificationId wcyknhqffftinx6awux5kd87vg9w9zuzvbimhfaavu3h2msenh).
  BscScan display CONFIRMED verified by the user's own screenshot on
  2026-11-19 13:30 WIB: "Source Code Verified — Exact Match", contract name
  AgentBook, compiler v0.8.24+commit.e11b9ed9, optimization Yes with 200 runs.
  (The agent browser itself was blocked by BscScan's Cloudflare wall.)
- Agent ID usage description:
  "AgentBook gates 100% of its write surface (profile registration, daily
  check-in, endorsements) on holding an Agent ID NFT
  (0x60B9262456dE011F7d15a54CdD8c48bAaa8B022F, balanceOf > 0). Agent ID is the
  identity, access-control, and trust layer: profiles belong to Agent ID
  wallets, check-in streaks accrue to Agent ID wallets, and the endorsement
  graph only exists between Agent ID holders. Because Agent IDs are
  non-transferable and one-per-user, the registry is Sybil-resistant."
- Reward receiving address: 0x12bd869958A6EadB48F962e4c1245a9E79566D73
- Targets:
  - Innovation Award eligibility: >=30 distinct Agent ID addresses interact
    with the contract during 2026-11-18 → 2026-12-09 UTC.
  - Pioneer Award ranking: distinct interacting Agent ID addresses +
    transaction count/volume during the same window.
- NOTE: the official announcement text does not expose a separate project
  submission form link (only the X-promotion survey). Re-checked again
  2026-11-19 ~09:12 WIB: the live announcement
  (binance.com/en/support/announcement/detail/95f5dbe0ea674a48a739b59e046648bf)
  still has no project-submission link — step 3 says to submit project
  name/website/contract/Agent ID usage "during the Submission Period. No
  registration needed." but links nothing; the only survey link in the
  announcement is the X-promotion campaign survey. Re-check the
  announcement / Binance Wallet ecosystem page for the project submission
  channel before 2026-12-09 and submit this pack there. Repo is NOT yet
  public (no git repo / remote in ~/workspace/agentid-hackathon as of
  2026-11-19) — Website and Repo fields above are still placeholders.
- X promotion survey (Community Award): https://app.binance.com/uni-qr/user-survey/ff6832f8d2984af289068c9450a3c98c
  — submit the X post link there after posting (see docs/X_POST.md).
