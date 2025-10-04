class WaterConsumption {
  final int? id;
  final int memberId;
  final String? prevCUMConsumption;
  final String? presentCUMConsumption;
  final String? prevMeterReading;
  final String? presentMeterReading;
  final String? others;

  WaterConsumption({
    this.id,
    required this.memberId,
    this.prevCUMConsumption,
    this.presentCUMConsumption,
    this.prevMeterReading,
    this.presentMeterReading,
    this.others,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'member_Id': memberId,
      'prev_CUM_consumption': prevCUMConsumption,
      'present_CUM_consumption': presentCUMConsumption,
      'prev_meter_reading': prevMeterReading,
      'present_meter_reading': presentMeterReading,
      'others': others,
    };
  }

  factory WaterConsumption.fromMap(Map<String, dynamic> map) {
    return WaterConsumption(
      id: map['id'],
      memberId: map['member_Id'],
      prevCUMConsumption: map['prev_CUM_consumption'],
      presentCUMConsumption: map['present_CUM_consumption'],
      prevMeterReading: map['prev_meter_reading'],
      presentMeterReading: map['present_meter_reading'],
      others: map['others'],
    );
  }
}