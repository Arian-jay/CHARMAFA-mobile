import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/meter_record.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('charmafa.db');
    return _database!;
  }


  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);
    print('db path: $path');

    return await openDatabase(
      path,
      version: 2,
      onCreate: _createDB,
      onUpgrade: _upgradeDB,
    );
  }

  Future<void> _upgradeDB(Database db, int oldVersion, int newVersion) async {
  if (oldVersion < 2) {
  }

  if (oldVersion < 3) {
    // Future migrations 
  }
}


  Future<void> _createDB(Database db, int version) async {
    // Create Roles table
    await db.execute('''
      CREATE TABLE roles (
        role_id INTEGER PRIMARY KEY AUTOINCREMENT,
        role_name TEXT NOT NULL
      )
    ''');

    // Create Puroks table
    await db.execute('''
      CREATE TABLE puroks (
        purok_id INTEGER PRIMARY KEY AUTOINCREMENT,
        purok TEXT NOT NULL
      )
    ''');

    // Create Membership_Fee table
    await db.execute('''
      CREATE TABLE membership_fees (
        membership_fee_id INTEGER PRIMARY KEY AUTOINCREMENT,
        fee_amount REAL NOT NULL,
        description TEXT
      )
    ''');

    // Create TS_Numbers table
    await db.execute('''
      CREATE TABLE ts_numbers (
        ts_Id INTEGER PRIMARY KEY AUTOINCREMENT,
        ts_no TEXT NOT NULL,
        landmark TEXT
      )
    ''');

    // Create Users table
    await db.execute('''
      CREATE TABLE users (
        admin_id INTEGER PRIMARY KEY AUTOINCREMENT,
        fname TEXT NOT NULL,
        mname TEXT,
        lname TEXT NOT NULL,
        suffix TEXT,
        contact_no TEXT,
        username TEXT NOT NULL UNIQUE,
        password TEXT NOT NULL,
        purok_id INTEGER,
        role INTEGER NOT NULL DEFAULT 4,
        association_id INTEGER,
        last_login DATETIME,
        last_date_synced DATETIME,
        FOREIGN KEY (purok_id) REFERENCES puroks (purok_id),
        FOREIGN KEY (role) REFERENCES roles (role_id)
      )
    ''');

    // Create Members table
    await db.execute('''
      CREATE TABLE members (
        member_id INTEGER PRIMARY KEY AUTOINCREMENT,
        account_no TEXT UNIQUE NOT NULL,
        purok_id INTEGER NOT NULL,
        ts_Id INTEGER NOT NULL,
        meter_no TEXT NOT NULL UNIQUE,
        fname TEXT NOT NULL,
        mname TEXT,
        lname TEXT NOT NULL,
        suffix TEXT,
        barangay TEXT NOT NULL,
        municipality TEXT NOT NULL,
        province TEXT NOT NULL,
        zip_code TEXT,
        region TEXT,
        date_of_birth DATE NOT NULL,
        place_of_birth TEXT,
        sex TEXT NOT NULL,
        civil_status TEXT,
        religion TEXT,
        ethnicity TEXT,
        language TEXT,
        education_attainment TEXT,
        school_address TEXT,
        course TEXT,
        year_graduated TEXT,
        mobile_no TEXT,
        height REAL,
        weight REAL,
        occupation TEXT,
        company_address TEXT,
        spouse_fname TEXT,
        spouse_mname TEXT,
        spouse_lname TEXT,
        spouse_suffix TEXT,
        spouse_date_of_birth DATE,
        spouse_address TEXT,
        spouse_ethnicity TEXT,
        spouse_occupation TEXT,
        spouse_phone_no TEXT,
        membership_fee_id INTEGER,
        is_approved INTEGER DEFAULT 0,
        photo_name TEXT,
        photo_path TEXT,
        registration_date DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
        update_date DATETIME,
        government_type_id INTEGER,
        government_no TEXT,
        prev_balance REAL,
        connection_status INTEGER DEFAULT 1,
        reconnection_date DATETIME,
        is_read BOOLEAN DEFAULT 0,
        FOREIGN KEY (purok_id) REFERENCES puroks (purok_id),
        FOREIGN KEY (membership_fee_id) REFERENCES membership_fees (membership_fee_id),
        FOREIGN KEY (ts_Id) REFERENCES ts_numbers (ts_Id)
      )
    ''');

    // Create Important_Information table
    await db.execute('''
      CREATE TABLE important_information (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        minimum_amount_per_month REAL NOT NULL DEFAULT 160,
        excess_minimum_CUM_per_month REAL NOT NULL DEFAULT 15,
        lossdamage_and_other_charges REAL NOT NULL DEFAULT 0,
        electricity_consumption REAL NOT NULL DEFAULT 0,
        generator_consumption REAL,
        announcement TEXT,
        free_CUM_per_month INTEGER
      )
    ''');

    // Add Water_Consumptions table
    await db.execute('''
      CREATE TABLE water_consumptions (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        member_Id INTEGER NOT NULL,
        prev_CUM_consumption BIGINT,
        present_CUM_consumption BIGINT,
        prev_meter_reading BIGINT,
        present_meter_reading BIGINT,
        others TEXT,
        FOREIGN KEY (member_Id) REFERENCES members (member_id)
      )
    ''');

    // Insert default roles
    await db.insert('roles', {'role_name': 'Super Admin'});
    await db.insert('roles', {'role_name': 'Treasurer'});
    await db.insert('roles', {'role_name': 'Collector'});
    await db.insert('roles', {'role_name': 'Reader'});

    // Insert default membership fees
    await db.insert('membership_fees', {'fee_amount': 150, 'description': 'Membership Type 1'});
    await db.insert('membership_fees', {'fee_amount': 300, 'description': 'Membership Type 2'});
    await db.insert('membership_fees', {'fee_amount': 600, 'description': 'Membership Type 3'});
  }

  // Users CRUD operations
  Future<int> insertUser(Map<String, dynamic> user) async {
    final db = await database;
    return await db.insert('users', user);
  }

  Future<List<Map<String, dynamic>>> getAllUsers() async {
    final db = await database;
    return await db.query('users');
  }

  Future<Map<String, dynamic>?> getUserByUsername(String username) async {
    final db = await database;
    final results = await db.query(
      'users',
      where: 'username = ?',
      whereArgs: [username],
      limit: 1,
    );
    return results.isNotEmpty ? results.first : null;
  }

  // Members CRUD operations
  Future<int> insertMember(Map<String, dynamic> member) async {
    final db = await database;
    return await db.insert('members', member);
  }

  Future<List<Map<String, dynamic>>> getAllMembers() async {
    final db = await database;
    return await db.query('members');
  }

  Future<List<Map<String, dynamic>>> getMembersByPurok(int purokId) async {
    final db = await database;
    return await db.query(
      'members',
      where: 'purok_id = ?',
      whereArgs: [purokId],
    );
  }

  Future<Map<String, dynamic>?> getMemberByMeterNo(String meterNo) async {
    final db = await database;
    final results = await db.query(
      'members',
      where: 'meter_no = ?',
      whereArgs: [meterNo],
      limit: 1,
    );
    return results.isNotEmpty ? results.first : null;
  }

  Future<List<Map<String, dynamic>>> getAllMeters() async {
    final db = await database;
    // Join members, ts_numbers, and puroks to get all details
    return await db.rawQuery('''
      SELECT m.member_id, m.meter_no, m.fname, m.purok_id, p.purok, m.ts_Id, t.ts_no
      FROM members m
      JOIN puroks p ON m.purok_id = p.purok_id
      JOIN ts_numbers t ON m.ts_Id = t.ts_Id
    ''');
  }

  Future<int> insertMeter(Map<String, dynamic> meter) async {
    final db = await database;
    // Insert with correct keys: ts_Id, meter_no, fname, purok_id, etc.
    return await db.insert('members', meter);
  }

  // Get all meters with TS number and Purok name (for filtering and display)
  Future<List<Map<String, dynamic>>> getAllMeterDetails() async {
    final db = await database;
    return await db.rawQuery('''
      SELECT m.member_id, m.meter_no, m.fname, m.purok_id, p.purok, m.ts_Id, t.ts_no
      FROM members m
      JOIN puroks p ON m.purok_id = p.purok_id
      JOIN ts_numbers t ON m.ts_Id = t.ts_Id
    ''');
  }

  // Insert a meter/member with ts_Id
  Future<int> insertMemberWithTs(Map<String, dynamic> member) async {
    final db = await database;
    return await db.insert('members', member);
  }

  // Puroks CRUD operations
  Future<int> insertPurok(String purok) async {
    final db = await database;
    return await db.insert('puroks', {'purok': purok});
  }

  Future<List<Map<String, dynamic>>> getAllPuroks() async {
    final db = await database;
    return await db.query('puroks');
  }

  // Update operations
  Future<int> updateMember(Map<String, dynamic> member) async {
    final db = await database;
    return await db.update(
      'members',
      member,
      where: 'member_id = ?',
      whereArgs: [member['member_id']],
    );
  }

  Future<int> updateUser(Map<String, dynamic> user) async {
    final db = await database;
    return await db.update(
      'users',
      user,
      where: 'admin_id = ?',
      whereArgs: [user['admin_id']],
    );
  }

  // Delete operations
  Future<int> deleteMember(int memberId) async {
    final db = await database;
    return await db.delete(
      'members',
      where: 'member_id = ?',
      whereArgs: [memberId],
    );
  }

  Future<int> deleteUser(int adminId) async {
    final db = await database;
    return await db.delete(
      'users',
      where: 'admin_id = ?',
      whereArgs: [adminId],
    );
  }
}
