class Purok {
  final int? purokId;
  final String purok;

  Purok({
    this.purokId,
    required this.purok,
  });

  Map<String, dynamic> toMap() {
    return {
      'purok_id': purokId,
      'purok': purok,
    };
  }

  factory Purok.fromMap(Map<String, dynamic> map) {
    return Purok(
      purokId: map['purok_id'],
      purok: map['purok'],
    );
  }
}
