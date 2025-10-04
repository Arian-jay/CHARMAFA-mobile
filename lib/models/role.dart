class Role {
  final int? roleId;
  final String roleName;

  Role({
    this.roleId,
    required this.roleName,
  });

  Map<String, dynamic> toMap() {
    return {
      'role_id': roleId,
      'role_name': roleName,
    };
  }

  factory Role.fromMap(Map<String, dynamic> map) {
    return Role(
      roleId: map['role_id'],
      roleName: map['role_name'],
    );
  }
}
