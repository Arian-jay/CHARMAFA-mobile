import 'package:flutter/material.dart';
import 'preview_dialog.dart';
import '../services/database_helper.dart';
import 'package:blue_thermal_printer/blue_thermal_printer.dart';
import '../services/printer_service.dart';

class MeterInputPage extends StatefulWidget {
  final Map<String, dynamic> meter;
  final String? selectedPrinter;
  final List<BluetoothDevice> devices;

  const MeterInputPage({super.key, required this.meter, required this.selectedPrinter, required this.devices});

  @override
  State<MeterInputPage> createState() => _MeterInputPageState();
}

class _MeterInputPageState extends State<MeterInputPage> {
  final TextEditingController _consumptionController = TextEditingController();
  BlueThermalPrinter bluetooth = BlueThermalPrinter.instance;

  void _onEnterConsumption() async {
    final value = double.tryParse(_consumptionController.text);
    if (value == null) return;
    final meter = widget.meter;
    final db = await DatabaseHelper.instance.database;
    // Get previous readings from water_consumptions table
    final waterRows = await db.query('water_consumptions', where: 'member_Id = ?', whereArgs: [meter['member_id']], limit: 1);
    Map<String, dynamic>? water = waterRows.isNotEmpty ? waterRows.first : null;
    final prevMeterReading = water?['present_meter_reading'] ?? 0;
    // Constraint: inputted meter reading must not be less than previous present_meter_reading
    if (value < prevMeterReading) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Meter reading cannot be less than previous reading!')),
      );
      return;
    }
    final presentMeterReading = value;
    final prevCUMConsumption = water?['present_CUM_consumption'] ?? 0;
    final presentCUMConsumption = presentMeterReading - prevMeterReading;
    final bill = presentCUMConsumption; // Or use computeBill(presentCUMConsumption) if needed
    // Show preview dialog before printing
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => PreviewDialog(
        meterId: meter['meter_no'].toString(),
        customerName: "${meter['fname'] ?? ''}",
        consumption: presentCUMConsumption,
        amount: bill,
        onCancel: () => Navigator.pop(context),
        onPrint: () async {
          // Print logic first
          if (widget.selectedPrinter == null) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Please connect to printer')),
            );
            return;
          }
          bool isConnected = await bluetooth.isConnected ?? false;
          if (!isConnected) {
            // Try to connect to the selected printer
            try {
              await bluetooth.connect(widget.devices.firstWhere((d) => d.name == widget.selectedPrinter));
              isConnected = await bluetooth.isConnected ?? false;
            } catch (e) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Failed to connect to printer: ${e.toString()}')),
              );
              return;
            }
          }
          if (!isConnected) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Please connect to printer')),
            );
            return;
          }
          try {
            await PrinterService.printBill(memberId: meter['member_id'], newReading: presentMeterReading.toInt());
            bluetooth.disconnect();
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Printing...')),
            );
          } catch (e) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Print error: ${e.toString()}')),
            );
            return;
          }
          // Only update DB if printing succeeded
          if (water != null) {
            await db.update(
              'water_consumptions',
              {
                'prev_meter_reading': prevMeterReading,
                'present_meter_reading': presentMeterReading,
                'prev_CUM_consumption': prevCUMConsumption,
                'present_CUM_consumption': presentCUMConsumption,
              },
              where: 'id = ?',
              whereArgs: [water['id']],
            );
          } else {
            await db.insert('water_consumptions', {
              'member_Id': meter['member_id'],
              'prev_meter_reading': prevMeterReading,
              'present_meter_reading': presentMeterReading,
              'prev_CUM_consumption': prevCUMConsumption,
              'present_CUM_consumption': presentCUMConsumption,
            });
          }
          await DatabaseHelper.instance.updateMember({
            'member_id': meter['member_id'],
            'is_read': 1,
          });
          Navigator.pop(context); // Close preview dialog
          Navigator.pop(context); // Go back to meter list
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final meter = widget.meter;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green[700],
        title: const Text("Meter Reading", style: TextStyle(color: Colors.white)),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 8),
            Text('Meter No:', style: TextStyle(fontSize: 16, color: Colors.black)),
            Text(meter['meter_no'] ?? '', style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.black)),
            const SizedBox(height: 8),
            Text('Owner:', style: TextStyle(fontSize: 16, color: Colors.black)),
            Text(meter['fname'] ?? '',style: TextStyle(fontSize: 20, color: Colors.black),),
            const SizedBox(height: 24),
            Text('Consumption:', style: TextStyle(fontSize: 16, color: Colors.black)),
            TextField(
              controller: _consumptionController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                filled: true,
                fillColor: Colors.white,
              ),
              style: const TextStyle(fontSize: 20),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF558B2F),
                  foregroundColor: Colors.black,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5),
                  ),
                ),
                onPressed: _onEnterConsumption,
                child: const Text('Enter'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
