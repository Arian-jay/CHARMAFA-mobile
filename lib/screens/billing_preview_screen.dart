import 'package:flutter/material.dart';
import '../services/printer_service.dart';

class BillingPreviewScreen extends StatelessWidget {
  final String meterNo;
  final String consumption;
  final double amount;

  const BillingPreviewScreen({
    super.key,
    required this.meterNo,
    required this.consumption,
    required this.amount,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Billing Preview")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Text("Meter No: $meterNo", style: const TextStyle(fontSize: 18)),
            Text("Consumption: $consumption", style: const TextStyle(fontSize: 18)),
            Text("Billing Amount: ₱$amount", style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                  onPressed: () {
                    Navigator.pop(context); // mo balik sa consumption input
                  },
                  child: const Text("Cancel"),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                  onPressed: () async {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Printing...")),
                    );
                    await PrinterService.printBill(meterNo, consumption, amount.toStringAsFixed(2));
                  },
                  child: const Text("Print"),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
