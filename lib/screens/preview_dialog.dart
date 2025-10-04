import 'package:flutter/material.dart';

class PreviewDialog extends StatelessWidget {
  final String meterId;
  final String customerName;
  final double consumption;
  final double amount;
  final VoidCallback onCancel;
  final VoidCallback onPrint;

  const PreviewDialog({
    super.key,
    required this.meterId,
    required this.customerName,
    required this.consumption,
    required this.amount,
    required this.onCancel,
    required this.onPrint,
  });

  @override
  Widget build(BuildContext context) {
    // Billing calculation logic (should match printer_service.dart)
    // For preview, assume freeCUM = 5, excessRate = 15, minAmount = 160 (or use your actual DB values if available)
    const int freeCUM = 5;
    const double excessRate = 15.0;
    const double minAmount = 160.0;
    const double lossDamage = 0.0;
    const double electricity = 0.0;
    const double generator = 0.0;
    final int consumptionInt = consumption.toInt();
    final int excessCUM = consumptionInt > freeCUM ? (consumptionInt - freeCUM) : 0;
    final double excess = excessCUM * excessRate;
    final double subtotal = minAmount + excess;
    final double otherCharges = lossDamage + electricity + generator;
    final double total = subtotal + otherCharges;
    return AlertDialog(
      title: const Text('Billing Preview', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Meter No: $meterId', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          Text('Customer: $customerName', style: const TextStyle(fontSize: 20)),
          Text('Consumption: $consumptionInt C.U.M', style: const TextStyle(fontSize: 20)),
          const SizedBox(height: 8),
          Text('TOTAL: ₱${total.toStringAsFixed(2)}', style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.green)),
        ],
      ),
      actions: [
        TextButton(
          style: TextButton.styleFrom(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
          ),
          onPressed: onCancel,
          child: const Text('Cancel', style: TextStyle(fontSize: 18)),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.green,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
            textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          onPressed: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Printing...')),
            );
            onPrint();
          },
          child: const Text('Print'),
        ),
      ],
    );
  }
}
