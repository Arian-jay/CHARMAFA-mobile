import 'package:flutter/material.dart';
import '../models/meter_record.dart';
import '../utils/billing.dart';
import 'preview_dialog.dart';

class MeterInputPage extends StatefulWidget {
  final MeterRecord meter;

  const MeterInputPage({super.key, required this.meter});

  @override
  State<MeterInputPage> createState() => _MeterInputPageState();
}

class _MeterInputPageState extends State<MeterInputPage> {
  final TextEditingController _consumptionController = TextEditingController();

  void _onEnterConsumption() {
    final value = double.tryParse(_consumptionController.text);
    if (value == null) return;

    final bill = computeBill(value);

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => PreviewDialog(
        meterId: widget.meter.meterNo,
        customerName: widget.meter.name,
        consumption: value,
        amount: bill,
        onCancel: () => Navigator.pop(context),
        onPrint: () {
          debugPrint('Printing layout for ${widget.meter.meterNo}...');
          Navigator.pop(context);
          ScaffoldMessenger.of(context)
              .showSnackBar(const SnackBar(content: Text('Printing...')));
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final meter = widget.meter;

    return Scaffold(
      appBar: AppBar(
        title: Text("Meter Input (${meter.meterNo})"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Meter: ${meter.meterNo} (TS: ${meter.tsNo}, ${meter.purok})'),
            Text('Customer: ${meter.name}'),
            const SizedBox(height: 16),
            TextField(
              controller: _consumptionController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Consumption (m³)'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _onEnterConsumption,
              child: const Text('Enter'),
            ),
          ],
        ),
      ),
    );
  }
}
