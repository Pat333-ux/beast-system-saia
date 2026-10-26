Markdown
# BEAST-SAIA System Architecture

## 1. System Topology Overview

The **Sovereign Autonomous Intelligence Architecture (SAIA)** is designed as a modular, scalable monorepo. It decouples intake processing, autonomous rule evaluation, decentralized verification, and cloud infrastructure deployment to ensure maximum resilience, auditability, and sovereign operational control.

   [ Public / Citizens ]
             │
             ▼
  [ Submission Gateway ]  (Express.js / Cloud Run API)
             │
             ▼
  [ Governance Engine ]   (Automated Policy & Benefit Evaluator)
    ┌────────┴────────┐
    ▼                 ▼
[ PostgreSQL DB ]   [ Smart Contracts ] (Ethereum / Sepolia Registry)


---

## 2. Core Modules & Responsibilities

### A. Submission Gateway (`apps/submission-gateway`)
- **Role**: Primary intake portal for public benefit claims, citizen submissions, and webhook events.
- **Tech Stack**: Node.js, Express.js, TypeScript, Docker.
- **Key Features**: Validates intake payloads, issues cryptographic tracking IDs (`SAIA-SUB-*`), and queues requests for governance evaluation.

### B. Governance Engine (`apps/governance-engine`)
- **Role**: Autonomous decision-making core that executes policy logic, income thresholds, and benefit calculations.
- **Tech Stack**: TypeScript rule evaluation modules.
- **Key Features**: Deterministic evaluation of benefit claims (`benefitsEvaluator.ts`) ensuring transparent and bias-free execution.

### C. Smart Contracts (`packages/smart-contracts`)
- **Role**: On-chain decentralized verification and immutable audit registry.
- **Tech Stack**: Solidity (^0.8.20), Hardhat, OpenZeppelin AccessControl.
- **Key Features**: `PublicBenefitDistributor.sol` coordinates secure fund allocations, role-based governance access, and verifiable citizen claims.

### D. Infrastructure & Deployment (`packages/infrastructure`, `apps/submission-gateway/Dockerfile`)
- **Role**: Cloud provisioning and automated deployment configuration.
- **Tech Stack**: Terraform, Google Cloud Platform (Cloud Run, Cloud SQL PostgreSQL), GitHub Actions CI/CD.
- **Key Features**: Containerized microservices running on GCP Cloud Run with automated infrastructure-as-code state management.

---

## 3. Data Flow & Security
1. **Intake**: Requests arrive at the Submission Gateway.
2. **Validation**: Payloads are authenticated and assigned tracking identifiers.
3. **Evaluation**: The Governance Engine runs policy checks against criteria parameters.
4. **Settlement / Audit**: Approved allocations are recorded in the PostgreSQL state databa
