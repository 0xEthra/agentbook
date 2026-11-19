// SPDX-License-Identifier: MIT
pragma solidity 0.8.24;

/// @dev Minimal ERC-721 interface used to verify Agent ID ownership.
interface IERC721 {
    function balanceOf(address account) external view returns (uint256);
}

/// @title AgentBook
/// @notice Profiles, daily check-ins, and endorsements for SPACE ID Agent ID holders on BNB Chain.
/// @dev Agent ID NFTs are non-transferable (soulbound).
contract AgentBook {
    /// @notice SPACE ID Agent ID ERC-721 contract on BNB Chain mainnet.
    address public constant agentIdContract =
        0x60B9262456dE011F7d15a54CdD8c48bAaa8B022F;

    uint256 public constant MAX_NAME_LEN = 64;
    uint256 public constant MAX_ROLE_LEN = 64;
    uint256 public constant MAX_LINK_LEN = 256;

    struct Profile {
        string displayName;
        string role;
        string link;
        uint256 timestamp;
        bool registered;
    }

    mapping(address => Profile) private _profiles;

    /// @notice Number of unique addresses that have registered a profile.
    uint256 public totalAgents;

    /// @notice Number of check-ins recorded for each address.
    mapping(address => uint256) public totalCheckIns;

    /// @notice Current consecutive-day check-in streak for each address.
    mapping(address => uint256) public currentStreak;

    /// @notice Most recent UTC day number on which each address checked in.
    mapping(address => uint256) public lastCheckInDay;

    /// @notice Total check-ins recorded across all addresses.
    uint256 public totalCheckInsGlobal;

    mapping(address => mapping(address => bool)) private _hasEndorsed;
    mapping(address => uint256) private _endorsementCounts;

    event ProfileRegistered(
        address indexed agent,
        string displayName,
        string role,
        string link,
        uint256 timestamp
    );
    event CheckedIn(address indexed agent, uint256 day, uint256 streak);
    event Endorsed(address indexed endorser, address indexed agent);
    event EndorsementRevoked(address indexed endorser, address indexed agent);

    /// @dev Every state-changing action is restricted to callers holding at
    /// least one Agent ID NFT in the configured ERC-721 contract.
    modifier onlyAgent() {
        require(
            IERC721(agentIdContract).balanceOf(msg.sender) > 0,
            "Agent ID required"
        );
        _;
    }

    /// @notice Registers or updates the caller's profile.
    function registerProfile(
        string calldata displayName,
        string calldata role,
        string calldata link
    ) external onlyAgent {
        require(bytes(displayName).length <= MAX_NAME_LEN, "Name too long");
        require(bytes(role).length <= MAX_ROLE_LEN, "Role too long");
        require(bytes(link).length <= MAX_LINK_LEN, "Link too long");

        Profile storage profile = _profiles[msg.sender];

        if (!profile.registered) {
            profile.registered = true;
            totalAgents += 1;
        }

        profile.displayName = displayName;
        profile.role = role;
        profile.link = link;
        profile.timestamp = block.timestamp;

        emit ProfileRegistered(
            msg.sender,
            displayName,
            role,
            link,
            block.timestamp
        );
    }

    /// @notice Records one check-in per UTC day and updates the caller's streak.
    function checkIn() external onlyAgent {
        uint256 day = block.timestamp / 1 days;
        uint256 previousDay = lastCheckInDay[msg.sender];
        require(previousDay != day, "Already checked in today");

        uint256 streak = previousDay == day - 1
            ? currentStreak[msg.sender] + 1
            : 1;

        lastCheckInDay[msg.sender] = day;
        currentStreak[msg.sender] = streak;
        totalCheckIns[msg.sender] += 1;
        totalCheckInsGlobal += 1;

        emit CheckedIn(msg.sender, day, streak);
    }

    /// @notice Endorses another Agent ID holder once per endorser-agent pair.
    function endorse(address agent) external onlyAgent {
        require(agent != msg.sender, "Cannot endorse self");
        require(
            IERC721(agentIdContract).balanceOf(agent) > 0,
            "Target must hold Agent ID"
        );
        require(!_hasEndorsed[msg.sender][agent], "Already endorsed");

        _hasEndorsed[msg.sender][agent] = true;
        _endorsementCounts[agent] += 1;

        emit Endorsed(msg.sender, agent);
    }

    /// @notice Revokes the caller's endorsement of an agent.
    function revokeEndorsement(address agent) external onlyAgent {
        require(_hasEndorsed[msg.sender][agent], "No endorsement to revoke");

        _hasEndorsed[msg.sender][agent] = false;
        _endorsementCounts[agent] -= 1;

        emit EndorsementRevoked(msg.sender, agent);
    }

    /// @notice Returns whether an address currently holds an Agent ID.
    function isAgent(address account) external view returns (bool) {
        return IERC721(agentIdContract).balanceOf(account) > 0;
    }

    /// @notice Returns the profile fields and last update timestamp for an address.
    function profileOf(
        address agent
    )
        external
        view
        returns (
            string memory displayName,
            string memory role,
            string memory link,
            uint256 timestamp
        )
    {
        Profile storage profile = _profiles[agent];
        return (
            profile.displayName,
            profile.role,
            profile.link,
            profile.timestamp
        );
    }

    /// @notice Returns the number of endorsements an address has received.
    function endorsementCountOf(address agent) external view returns (uint256) {
        return _endorsementCounts[agent];
    }
}