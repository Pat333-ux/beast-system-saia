// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/access/AccessControl.sol";

/**
 * @title PublicBenefitDistributor
 * @dev Sovereign automated public benefit registry and distribution controller for BEAST-SAIA.
 */
contract PublicBenefitDistributor is AccessControl {
    bytes32 public constant GOVERNOR_ROLE = keccak256("GOVERNOR_ROLE");
    bytes32 public constant AUDITOR_ROLE = keccak256("AUDITOR_ROLE");

    struct DistributionRecord {
        address recipient;
        uint256 amount;
        string programId;
        uint256 timestamp;
        bool claimed;
    }

    mapping(bytes32 => DistributionRecord) public distributions;
    mapping(address => uint256) public totalClaimedByRecipient;

    event BenefitAllocated(bytes32 indexed claimId, address indexed recipient, uint256 amount, string programId);
    event BenefitClaimed(bytes32 indexed claimId, address indexed recipient, uint256 amount);

    constructor(address admin) {
        _grantRole(DEFAULT_ADMIN_ROLE, admin);
        _grantRole(GOVERNOR_ROLE, admin);
    }

    function allocateBenefit(
        bytes32 claimId,
        address recipient,
        uint256 amount,
        string calldata programId
    ) external onlyRole(GOVERNOR_ROLE) {
        require(distributions[claimId].recipient == address(0), "Claim ID already exists");
        require(recipient != address(0), "Invalid recipient address");

        distributions[claimId] = DistributionRecord({
            recipient: recipient,
            amount: amount,
            programId: programId,
            timestamp: block.timestamp,
            claimed: false
        });

        emit BenefitAllocated(claimId, recipient, amount, programId);
    }

    function claimBenefit(bytes32 claimId) external {
        DistributionRecord storage record = distributions[claimId];
        require(record.recipient == msg.sender, "Caller is not the designated recipient");
        require(!record.claimed, "Benefit already claimed");
        require(record.amount > 0, "No funds allocated");

        record.claimed = true;
        totalClaimedByRecipient[msg.sender] += record.amount;

        (bool success, ) = payable(msg.sender).call{value: record.amount}("");
        require(success, "Transfer failed");

        emit BenefitClaimed(claimId, msg.sender, record.amount);
    }

    // Allow contract to receive funds for distribution
    receive() external payable {}
}
