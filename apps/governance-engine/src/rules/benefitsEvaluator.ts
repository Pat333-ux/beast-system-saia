export interface BenefitClaim {
  claimId: string;
  applicantId: string;
  programId: string;
  qualifyingMetrics: Record<string, any>;
}

export interface EvaluationResult {
  claimId: string;
  approved: boolean;
  allocatedAmount: number;
  reason: string;
  timestamp: string;
}

export function evaluatePublicBenefit(claim: BenefitClaim): EvaluationResult {
  const { incomeThreshold, dependentCount } = claim.qualifyingMetrics;

  if (incomeThreshold !== undefined && incomeThreshold <= 45000) {
    const baseAllocation = 1200;
    const additionalBonus = (dependentCount || 0) * 300;

    return {
      claimId: claim.claimId,
      approved: true,
      allocatedAmount: baseAllocation + additionalBonus,
      reason: 'Automated policy thresholds met. Allocation calculated.',
      timestamp: new Date().toISOString()
    };
  }

  return {
    claimId: claim.claimId,
    approved: false,
    allocatedAmount: 0,
    reason: 'Submission parameters do not satisfy program eligibility thresholds.',
    timestamp: new Date().toISOString()
  };
}
