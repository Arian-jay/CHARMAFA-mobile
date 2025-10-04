import 'package:blue_thermal_printer/blue_thermal_printer.dart';
import '../services/database_helper.dart';
import '../models/important_informations.dart';

class PrinterService {
  static final BlueThermalPrinter bluetooth = BlueThermalPrinter.instance;

  // Check connection status
  static Future<bool> isConnected() async {
    return await bluetooth.isConnected ?? false;
  }

  // Connect to first available printer
  static Future<void> connectPrinter() async {
    List<BluetoothDevice> devices = await bluetooth.getBondedDevices();
    if (devices.isNotEmpty) {
      await bluetooth.connect(devices.first);
    }
  }

  // Print detailed bill using all DB values
  static Future<void> printBill({required int memberId, required int newReading}) async {
    bool connected = await isConnected();
    if (!connected) {
      await connectPrinter();
    }
    final db = await DatabaseHelper.instance.database;
    // Get member details
    final member = await db.query('members', where: 'member_id = ?', whereArgs: [memberId], limit: 1);
    if (member.isEmpty) return;
    final m = member.first;
    // Get TS number and purok
    final tsRows = await db.query('ts_numbers', where: 'ts_Id = ?', whereArgs: [m['ts_Id']], limit: 1);
    final purokRows = await db.query('puroks', where: 'purok_id = ?', whereArgs: [m['purok_id']], limit: 1);
    final tsNo = tsRows.isNotEmpty ? tsRows.first['ts_no'] : '';
    final purok = purokRows.isNotEmpty ? purokRows.first['purok'] : '';
    // Get latest water consumption (before update)
    final waterRows = await db.query('water_consumptions', where: 'member_Id = ?', whereArgs: [memberId], orderBy: 'id DESC', limit: 1);
    int prevReading = 0;
    if (waterRows.isNotEmpty) {
      final prevVal = waterRows[0]['present_meter_reading'];
      if (prevVal is int) {
        prevReading = prevVal;
      } else if (prevVal is String) {
        prevReading = int.tryParse(prevVal) ?? 0;
      } else if (prevVal is double) {
        prevReading = prevVal.toInt();
      }
    }
    // Get important info (Pahibalo)
    final infoRows = await db.query('important_information', limit: 1);
    final info = infoRows.isNotEmpty ? ImportantInformation.fromMap(infoRows.first) : null;
    final minAmount = info != null ? info.minimumAmountPerMonth : 0.0;
    final excessRate = info != null ? info.excessMinimumCUMPerMonth : 15.0;
    final lossDamage = info != null ? info.lossDamageAndOtherCharges : 0.0;
    final electricity = info != null ? info.electricityConsumption : 0.0;
    final double generator = info != null && info.generatorConsumption != null ? info.generatorConsumption! : 0.0;
    final announcement = info?.announcement ?? '';
    final freeCUM = info?.freeCUMPerMonth ?? 5;
    // Compute bill breakdown
    int consumption = newReading - prevReading;
    int excessCUM = consumption > freeCUM ? (consumption - freeCUM) : 0;
    double excess = excessCUM * excessRate;
    double subtotal = minAmount + excess;
    double otherCharges = lossDamage + electricity + generator;
    double total = subtotal + otherCharges;
    // Print formatted bill
    bluetooth.printNewLine();
    bluetooth.printCustom("CHARITO MAHAYAG FARMERS ASSOCIATION", 1, 1);
    bluetooth.printCustom("(CHARMAFA)", 1, 1);
    bluetooth.printCustom("Purok-2, Charito, Bayugan City, Agusan del Sur", 0, 1);
    bluetooth.printCustom("TIN No: 763-299-844-000", 0, 1);
    bluetooth.printCustom("Hotline: (0946)949-1036 / (0909)231-0244", 0, 1);
    bluetooth.printCustom("\nSTATEMENT OF ACCOUNT", 1, 1);
    bluetooth.printNewLine();
    bluetooth.printCustom("TS No:         $tsNo", 0, 0);
    bluetooth.printCustom("Meter No:      ${m['meter_no']}", 0, 0);
    bluetooth.printCustom("Account No:    ${m['account_no']}", 0, 0);
    bluetooth.printCustom("Consumer:      ${m['fname']} ${m['lname']}", 0, 0);
    bluetooth.printCustom("Address:       $purok, ${m['barangay']}, ${m['municipality']}", 0, 0);
    bluetooth.printCustom("Date:          ${DateTime.now().toString().split(' ')[0]}", 0, 0);
    bluetooth.printCustom("--------------------------------", 0, 0);
    bluetooth.printCustom("Prev Reading:  $prevReading", 0, 0);
    bluetooth.printCustom("Pres Reading:  $newReading", 0, 0);
    bluetooth.printCustom("Free CUM/mo:   $freeCUM C.U.M", 0, 0);
    bluetooth.printCustom("Consumption:   $consumption C.U.M", 0, 0);
    bluetooth.printCustom("--------------------------------", 0, 0);
    bluetooth.printCustom("Minimum:       ${minAmount.toStringAsFixed(2)} PHP", 0, 0);
    bluetooth.printCustom("Excess:        ${excess.toStringAsFixed(2)} PHP", 0, 0);
    bluetooth.printCustom("Subtotal:      ${subtotal.toStringAsFixed(2)} PHP", 0, 0);
    bluetooth.printCustom("Other Charges: ${otherCharges.toStringAsFixed(2)} PHP", 0, 0);
    bluetooth.printCustom("  Loss/Damage: ${lossDamage.toStringAsFixed(2)} PHP", 0, 0);
    bluetooth.printCustom("  Electricity: ${electricity.toStringAsFixed(2)} PHP", 0, 0);
    bluetooth.printCustom("  Generator:   ${generator.toStringAsFixed(2)} PHP", 0, 0);
    bluetooth.printCustom("--------------------------------", 0, 0);
    bluetooth.printCustom("--------------------------------", 0, 0);
    bluetooth.printCustom("TOTAL:         ${total.toStringAsFixed(2)} PHP", 1, 0);
    bluetooth.printNewLine();
    bluetooth.printCustom("READER: JUSTINIANO S. TAGAAN", 0, 0);
    bluetooth.printCustom("\nPAHIBALO:", 1, 0);
    bluetooth.printCustom(announcement, 0, 0);
    bluetooth.printNewLine();
    bluetooth.paperCut();
  }
}
