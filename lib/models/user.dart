class User {
  final int? adminId;
  final String fname;
  final String? mname;
  final String lname;
  final String? suffix;
  final String? contactNo;
  final String username;
  final String password;
  final int? purokId;
  final int role;
  final int? associationId;
  final DateTime? lastLogin;
  final DateTime? lastDateSynced;

  User({
    this.adminId,
    required this.fname,
    this.mname,
    required this.lname,
    this.suffix,
    this.contactNo,
    required this.username,
    required this.password,
    this.purokId,
    required this.role,
    this.associationId,
    this.lastLogin,
    this.lastDateSynced,
  });

  Map<String, dynamic> toMap() {
    return {
      'admin_id': adminId,
      'fname': fname,
      'mname': mname,
      'lname': lname,
      'suffix': suffix,
      'contact_no': contactNo,
      'username': username,
      'password': password,
      'purok_id': purokId,
      'role': role,
      'association_id': associationId,
      'last_login': lastLogin?.toIso8601String(),
      'last_date_synced': lastDateSynced?.toIso8601String(),
    };
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      adminId: map['admin_id'],
      fname: map['fname'],
      mname: map['mname'],
      lname: map['lname'],
      suffix: map['suffix'],
      contactNo: map['contact_no'],
      username: map['username'],
      password: map['password'],
      purokId: map['purok_id'],
      role: map['role'],
      associationId: map['association_id'],
      lastLogin: map['last_login'] != null
          ? DateTime.parse(map['last_login'])
          : null,
      lastDateSynced: map['last_date_synced'] != null
          ? DateTime.parse(map['last_date_synced'])
          : null,
    );
  }
}
