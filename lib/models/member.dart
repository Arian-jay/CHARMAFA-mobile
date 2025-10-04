class Member {
  final int? memberId;
  final String accountNo;
  final int purokId;
  final int tsId; // updated: now references ts_numbers
  final String meterNo;
  final String fname;
  final String? mname;
  final String lname;
  final String? suffix;
  final String barangay;
  final String municipality;
  final String province;
  final String? zipCode;
  final String? region;
  final DateTime dateOfBirth;
  final String? placeOfBirth;
  final String sex;
  final String? civilStatus;
  final String? religion;
  final String? ethnicity;
  final String? language;
  final String? educationAttainment;
  final String? schoolAddress;
  final String? course;
  final String? yearGraduated;
  final String? mobileNo;
  final double? height;
  final double? weight;
  final String? occupation;
  final String? companyAddress;
  final String? spouseFname;
  final String? spouseMname;
  final String? spouseLname;
  final String? spouseSuffix;
  final DateTime? spouseDateOfBirth;
  final String? spouseAddress;
  final String? spouseEthnicity;
  final String? spouseOccupation;
  final String? spousePhoneNo;
  final int? membershipFeeId;
  final int isApproved;
  final String? photoName;
  final String? photoPath;
  final DateTime registrationDate;
  final DateTime? updateDate;
  final int? governmentTypeId;
  final String? governmentNo;
  final double prevBalance;
  final int connectionStatus;
  final DateTime? reconnectionDate;

  Member({
    this.memberId,
    required this.accountNo,
    required this.purokId,
    required this.tsId,
    required this.meterNo,
    required this.fname,
    this.mname,
    required this.lname,
    this.suffix,
    required this.barangay,
    required this.municipality,
    required this.province,
    this.zipCode,
    this.region,
    required this.dateOfBirth,
    this.placeOfBirth,
    required this.sex,
    this.civilStatus,
    this.religion,
    this.ethnicity,
    this.language,
    this.educationAttainment,
    this.schoolAddress,
    this.course,
    this.yearGraduated,
    this.mobileNo,
    this.height,
    this.weight,
    this.occupation,
    this.companyAddress,
    this.spouseFname,
    this.spouseMname,
    this.spouseLname,
    this.spouseSuffix,
    this.spouseDateOfBirth,
    this.spouseAddress,
    this.spouseEthnicity,
    this.spouseOccupation,
    this.spousePhoneNo,
    this.membershipFeeId,
    this.isApproved = 0,
    this.photoName,
    this.photoPath,
    required this.registrationDate,
    this.updateDate,
    this.governmentTypeId,
    this.governmentNo,
    this.prevBalance = 0.0,
    this.connectionStatus = 1,
    this.reconnectionDate,
  });

  Map<String, dynamic> toMap() {
    return {
      'member_id': memberId,
      'account_no': accountNo,
      'purok_id': purokId,
      'ts_Id': tsId,
      'meter_no': meterNo,
      'fname': fname,
      'mname': mname,
      'lname': lname,
      'suffix': suffix,
      'barangay': barangay,
      'municipality': municipality,
      'province': province,
      'zip_code': zipCode,
      'region': region,
      'date_of_birth': dateOfBirth.toIso8601String(),
      'place_of_birth': placeOfBirth,
      'sex': sex,
      'civil_status': civilStatus,
      'religion': religion,
      'ethnicity': ethnicity,
      'language': language,
      'education_attainment': educationAttainment,
      'school_address': schoolAddress,
      'course': course,
      'year_graduated': yearGraduated,
      'mobile_no': mobileNo,
      'height': height,
      'weight': weight,
      'occupation': occupation,
      'company_address': companyAddress,
      'spouse_fname': spouseFname,
      'spouse_mname': spouseMname,
      'spouse_lname': spouseLname,
      'spouse_suffix': spouseSuffix,
      'spouse_date_of_birth': spouseDateOfBirth?.toIso8601String(),
      'spouse_address': spouseAddress,
      'spouse_ethnicity': spouseEthnicity,
      'spouse_occupation': spouseOccupation,
      'spouse_phone_no': spousePhoneNo,
      'membership_fee_id': membershipFeeId,
      'is_approved': isApproved,
      'photo_name': photoName,
      'photo_path': photoPath,
      'registration_date': registrationDate.toIso8601String(),
      'update_date': updateDate?.toIso8601String(),
      'government_type_id': governmentTypeId,
      'government_no': governmentNo,
      'prev_balance': prevBalance,
      'connection_status': connectionStatus,
      'reconnection_date': reconnectionDate?.toIso8601String(),
    };
  }

  factory Member.fromMap(Map<String, dynamic> map) {
    return Member(
      memberId: map['member_id'],
      accountNo: map['account_no'],
      purokId: map['purok_id'],
      tsId: map['ts_Id'],
      meterNo: map['meter_no'],
      fname: map['fname'],
      mname: map['mname'],
      lname: map['lname'],
      suffix: map['suffix'],
      barangay: map['barangay'],
      municipality: map['municipality'],
      province: map['province'],
      zipCode: map['zip_code'],
      region: map['region'],
      dateOfBirth: DateTime.parse(map['date_of_birth']),
      placeOfBirth: map['place_of_birth'],
      sex: map['sex'],
      civilStatus: map['civil_status'],
      religion: map['religion'],
      ethnicity: map['ethnicity'],
      language: map['language'],
      educationAttainment: map['education_attainment'],
      schoolAddress: map['school_address'],
      course: map['course'],
      yearGraduated: map['year_graduated'],
      mobileNo: map['mobile_no'],
      height: map['height'],
      weight: map['weight'],
      occupation: map['occupation'],
      companyAddress: map['company_address'],
      spouseFname: map['spouse_fname'],
      spouseMname: map['spouse_mname'],
      spouseLname: map['spouse_lname'],
      spouseSuffix: map['spouse_suffix'],
      spouseDateOfBirth: map['spouse_date_of_birth'] != null
          ? DateTime.parse(map['spouse_date_of_birth'])
          : null,
      spouseAddress: map['spouse_address'],
      spouseEthnicity: map['spouse_ethnicity'],
      spouseOccupation: map['spouse_occupation'],
      spousePhoneNo: map['spouse_phone_no'],
      membershipFeeId: map['membership_fee_id'],
      isApproved: map['is_approved'] ?? 0,
      photoName: map['photo_name'],
      photoPath: map['photo_path'],
      registrationDate: DateTime.parse(map['registration_date']),
      updateDate: map['update_date'] != null
          ? DateTime.parse(map['update_date'])
          : null,
      governmentTypeId: map['government_type_id'],
      governmentNo: map['government_no'],
      prevBalance: map['prev_balance'] ?? 0.0,
      connectionStatus: map['connection_status'] ?? 1,
      reconnectionDate: map['reconnection_date'] != null
          ? DateTime.parse(map['reconnection_date'])
          : null,
    );
  }
}



