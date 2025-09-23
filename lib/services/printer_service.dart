import 'package:blue_thermal_printer/blue_thermal_printer.dart';

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

  // Print sample bill
  static Future<void> printBill(String meterNo, String consumption, String amount) async {
    bool connected = await isConnected();
    if (!connected) {
      await connectPrinter();
    }

    bluetooth.printNewLine();
    bluetooth.printCustom("CHARMAFA Billing", 2, 1);
    bluetooth.printNewLine();
    bluetooth.printCustom("Meter No: $meterNo", 1, 0);
    bluetooth.printCustom("Consumption: $consumption", 1, 0);
    bluetooth.printCustom("Billing Amount: ₱$amount", 1, 0);
    bluetooth.printNewLine();
    bluetooth.printCustom("Thank you!", 1, 1);
    bluetooth.printNewLine();
    bluetooth.paperCut();
  }
}
