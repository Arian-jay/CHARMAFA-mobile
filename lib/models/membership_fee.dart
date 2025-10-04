class MembershipFee {
  final int? membershipFeeId;
  final double feeAmount;
  final String? description;

  MembershipFee({
    this.membershipFeeId,
    required this.feeAmount,
    this.description,
  });

  Map<String, dynamic> toMap() {
    return {
      'membership_fee_id': membershipFeeId,
      'fee_amount': feeAmount,
      'description': description,
    };
  }

  factory MembershipFee.fromMap(Map<String, dynamic> map) {
    return MembershipFee(
      membershipFeeId: map['membership_fee_id'],
      feeAmount: map['fee_amount'],
      description: map['description'],
    );
  }
}
