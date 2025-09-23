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
    return AlertDialog(
      title: const Text('Preview'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Meter: $meterId'),
          Text('Customer: $customerName'),
          Text('Consumption: ${consumption.toStringAsFixed(2)} m³'),
          Text('Billing Amount: ₱${amount.toStringAsFixed(2)}'),
        ],
      ),
      actions: [
        TextButton(
          onPressed: onCancel,
          child: const Text('Cancel'),
        ),
        ElevatedButton.icon(
          onPressed: onPrint,
          icon: const Icon(Icons.print),
          label: const Text('Print'),
        ),
      ],
    );
  }
}
