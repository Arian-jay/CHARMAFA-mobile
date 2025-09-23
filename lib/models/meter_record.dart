class MeterRecord {
  final String tsNo;
  final String meterNo;
  final String name;
  final String purok;
  bool isSelected;

  MeterRecord({
    required this.tsNo,
    required this.meterNo,
    required this.name,
    required this.purok,
    this.isSelected = false,
  });
}
