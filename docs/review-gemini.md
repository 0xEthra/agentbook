### 1. Sybil / Metric Manipulation via NFT Transfer
* **Severity:** Medium
* **Issue:** `onlyAgent` checks `IERC721.balanceOf(msg.sender) > 0`. A user can transfer or flash-loan a single Agent ID NFT through multiple addresses in the same transaction or block. This allows an attacker to artificially inflate `totalAgents`, farm `totalCheckInsGlobal`, and generate illegitimate endorsements.
* **Fix:** Track state per token ID rather than per address, or require the address to maintain ownership across checks. If the interface must rely solely on address ownership without tracking token IDs, consider recording the block number of the last transfer/activity per account or accepting that metrics represent addresses rather than unique entities. If token ID tracking is possible:
```solidity
// Change interface to verify specific token ownership:
interface IERC721 {
    function ownerOf(uint256 tokenId) external view returns (address);
}
```

---

### 2. Missing String Length Validations (Gas Exhaustion / DoS)
* **Severity:** Medium
* **Issue:** `displayName`, `role`, and `link` have no upper bound on string length. Users can pass arbitrarily large strings, causing massive storage write costs, event log bloat, and potential memory-limit issues for off-chain indexers or frontend RPC nodes.
* **Fix:** Add length constraints in `registerProfile`:
```solidity
uint256 public constant MAX_NAME_LEN = 64;
uint256 public constant MAX_ROLE_LEN = 64;
uint256 public constant MAX_LINK_LEN = 256;

function registerProfile(
    string calldata displayName,
    string calldata role,
    string calldata link
) external onlyAgent {
    require(bytes(displayName).length <= MAX_NAME_LEN, "Name too long");
    require(bytes(role).length <= MAX_ROLE_LEN, "Role too long");
    require(bytes(link).length <= MAX_LINK_LEN, "Link too long");
    // ...
```

---

### 3. Redundant Storage Reads in `checkIn`
* **Severity:** Gas Optimization / Low
* **Issue:** `lastCheckInDay[msg.sender]` is read from storage twice: once during the `require` check and once to calculate `previousDay`.
* **Fix:** Cache the storage value in a local variable:
```solidity
function checkIn() external onlyAgent {
    uint256 day = block.timestamp / 1 days;
    uint256 previousDay = lastCheckInDay[msg.sender];
    require(previousDay != day, "Already checked in today");

    uint256 streak = (previousDay == day - 1)
        ? currentStreak[msg.sender] + 1
        : 1;

    lastCheckInDay[msg.sender] = day;
    currentStreak[msg.sender] = streak;
    totalCheckIns[msg.sender] += 1;
    totalCheckInsGlobal += 1;

    emit CheckedIn(msg.sender, day, streak);
}
```

---

### 4. Streak Logic Edge Cases
* **Severity:** Low / Informational
* **Evaluation:**
  * **Day 0 / Initialization:** `previousDay` defaults to `0`. Current UTC day is > `19,000`, so `previousDay == day - 1` evaluates to `false`, correctly initializing `streak` to `1`.
  * **Missed Day:** If `day - previousDay > 1`, the streak evaluates to `1`.
  * **Timestamp Drift:** Relies on `block.timestamp / 1 days` (86,400-second intervals). Validators can manipulate block timestamps by a few seconds, which could allow a check-in seconds before or after a UTC boundary. Because check-ins are locked per UTC day integer, a user cannot check in more than once in any given day window regardless of minor drift.

---

### 5. Hackathon Red Line Verification
* **Severity:** Passed (No violation)
  * **No Asset Handling:** The contract does not accept BNB (`msg.value` / `payable`), hold tokens, or transfer assets.
  * **No Approvals:** Does not call or expose `approve` / `setApprovalForAll`.
  * **No QR Login:** Authentication is purely EVM transaction-based (`msg.sender`).
  * **No Return Promises:** Does not implement yield, token distribution, or financial reward guarantees.