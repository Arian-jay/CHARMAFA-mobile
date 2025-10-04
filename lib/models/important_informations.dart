class ImportantInformation {
  final int? id;
  final double minimumAmountPerMonth;
  final double excessMinimumCUMPerMonth;
  final double lossDamageAndOtherCharges;
  final double electricityConsumption;
  final double? generatorConsumption;
  final String? announcement;
  final String? landmark;
  final String? accountName;
  final String? meterNo;
  final String? accountNo;
  final int? freeCUMPerMonth;

  ImportantInformation({
    this.id,
    required this.minimumAmountPerMonth,
    required this.excessMinimumCUMPerMonth,
    required this.lossDamageAndOtherCharges,
    required this.electricityConsumption,
    this.generatorConsumption,
    this.announcement,
    this.landmark,
    this.accountName,
    this.meterNo,
    this.accountNo,
    this.freeCUMPerMonth,
  });

  factory ImportantInformation.fromMap(Map<String, dynamic> map) {
    return ImportantInformation(
      id: map['id'],
      minimumAmountPerMonth: map['minimum_amount_per_month'],
      excessMinimumCUMPerMonth: map['excess_minimum_CUM_per_month'],
      lossDamageAndOtherCharges: map['lossdamage_and_other_charges'],
      electricityConsumption: map['electricity_consumption'],
      generatorConsumption: map['generator_consumption'],
      announcement: map['announcement'],
      landmark: map['Landmark'],
      accountName: map['Account_Name'],
      meterNo: map['Meter_No'],
      accountNo: map['Account_No'],
      freeCUMPerMonth: map['free_CUM_per_month'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'minimum_amount_per_month': minimumAmountPerMonth,
      'excess_minimum_CUM_per_month': excessMinimumCUMPerMonth,
      'lossdamage_and_other_charges': lossDamageAndOtherCharges,
      'electricity_consumption': electricityConsumption,
      'generator_consumption': generatorConsumption,
      'announcement': announcement,
      'Landmark': landmark,
      'Account_Name': accountName,
      'Meter_No': meterNo,
      'Account_No': accountNo,
      'free_CUM_per_month': freeCUMPerMonth,
    };
  }
}
