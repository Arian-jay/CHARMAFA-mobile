import 'package:flutter/material.dart';
import '../models/meter_record.dart';
import '../utils/billing.dart';
import 'login_page.dart';
import 'preview_dialog.dart';
import 'meter_input_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}


final List<MeterRecord> _meters = [
  MeterRecord(tsNo: 'TS-001', meterNo: 'M-1001', name: 'Customer 1', purok: 'Purok 1'),
  MeterRecord(tsNo: 'TS-001', meterNo: 'M-1002', name: 'Customer 2', purok: 'Purok 1'),
  MeterRecord(tsNo: 'TS-002', meterNo: 'M-2001', name: 'Customer 3', purok: 'Purok 1'),
  MeterRecord(tsNo: 'TS-002', meterNo: 'M-2002', name: 'Customer 4', purok: 'Purok 2'),
  MeterRecord(tsNo: 'TS-003', meterNo: 'M-3001', name: 'Customer 5', purok: 'Purok 2'),
];


class _HomePageState extends State<HomePage> {
  bool _filterByTs = false;
  bool _filterByPurok = false;
  MeterRecord? _selectedMeter;
  String? _selectedTsNo;
  String? _selectedPurok;
  String _consumptionInput = '';

  List<String> get _uniqueTs => _meters.map((m) => m.tsNo).toSet().toList();
  List<String> get _uniquePuroks => _meters.map((m) => m.purok).toSet().toList();


  void _selectTs(String tsNo) {
    setState(() {
      _selectedTsNo = tsNo;
      _selectedPurok = null;
      _selectedMeter = null;
      _consumptionInput = '';
    });
  }

  void _selectPurok(String purok) {
    setState(() {
      _selectedPurok = purok;
      _selectedTsNo = null;
      _selectedMeter = null;
      _consumptionInput = '';
    });
  }

  void _selectMeter(MeterRecord meter) {
    setState(() {
      _selectedMeter = meter;
      _consumptionInput = '';
    });
  }

  void _onEnterConsumption() {
    if (_consumptionInput.isEmpty || _selectedMeter == null) return;
    final parsed = double.tryParse(_consumptionInput);
    if (parsed == null) return;
    final bill = computeBill(parsed);
    final meter = _selectedMeter!;
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => PreviewDialog(
        meterId: meter.meterNo,
        customerName: meter.name,
        consumption: parsed,
        amount: bill,
        onCancel: () => Navigator.pop(context),
        onPrint: () {
          debugPrint('Printing layout for ${meter.meterNo}...');
          Navigator.pop(context);
          ScaffoldMessenger.of(context)
              .showSnackBar(const SnackBar(content: Text('Printing...')));
        },
      ),
    );
  }

  Widget _buildFilterButtons() {
    return Row(
      children: [
        Expanded(
          child: ElevatedButton(
            onPressed: () {
              setState(() {
                _filterByTs = true;
                _filterByPurok = false;
                _selectedTsNo = null;
                _selectedPurok = null;
                _selectedMeter = null;
                _consumptionInput = '';
              });
            },
            child: const Text('TS no.'),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: ElevatedButton(
            onPressed: () {
              setState(() {
                _filterByPurok = true;
                _filterByTs = false;
                _selectedTsNo = null;
                _selectedPurok = null;
                _selectedMeter = null;
                _consumptionInput = '';
              });
            },
            child: const Text('Purok'),
          ),
        ),
      ],
    );
  }

  Widget _buildList() {
    if (_filterByTs) {
      // Show all TS numbers with dropdown meters
      final tsGroups = _uniqueTs;
      return ListView(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        children: tsGroups.map((ts) {
          final metersInTs = _meters.where((m) => m.tsNo == ts).toList();
          return ExpansionTile(
            title: Text("TS $ts"),
            children: metersInTs.map((meter) {
              final isSelected = _selectedMeter == meter;
              return Card(
                color: isSelected ? Colors.grey[300] : Colors.white,
                child: ListTile(
                  title: Text("Meter No: ${meter.meterNo}"),
                  subtitle: Text("Name: ${meter.name} | Purok: ${meter.purok}"),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => MeterInputPage(meter: meter),
                      ),
                    );
                  },

                ),
              );
            }).toList(),
          );
        }).toList(),
      );
    }

    if (_filterByPurok) {
      // Show all Puroks with dropdown TS and meters
      final purokGroups = _uniquePuroks;
      return ListView(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        children: purokGroups.map((purok) {
          final tsInPurok = _uniqueTs
              .where((ts) => _meters.any((m) => m.purok == purok && m.tsNo == ts))
              .toList();

          return ExpansionTile(
            title: Text("Purok $purok"),
            children: tsInPurok.map((ts) {
              final metersInTs =
                  _meters.where((m) => m.purok == purok && m.tsNo == ts).toList();

              return ExpansionTile(
                title: Text("TS $ts"),
                children: metersInTs.map((meter) {
                  final isSelected = _selectedMeter == meter;
                  return Card(
                    color: isSelected ? Colors.grey[300] : Colors.white,
                    child: ListTile(
                      title: Text("Meter No: ${meter.meterNo}"),
                      subtitle: Text("Name: ${meter.name}"),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => MeterInputPage(meter: meter),
                          ),
                        );
                      },

                    ),
                  );
                }).toList(),
              );
            }).toList(),
          );
        }).toList(),
      );
    }

    return const Center(child: Text("Please select a filter"));
  }


  Widget _buildConsumptionInput() {
    if (_selectedMeter == null) return const SizedBox.shrink();
    final meter = _selectedMeter!;
    return Card(
      margin: const EdgeInsets.only(top: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Text('Meter: ${meter.meterNo} (TS: ${meter.tsNo}, ${meter.purok})'),
            Text('Customer: ${meter.name}'),
            TextField(
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Consumption (m³)'),
              onChanged: (v) => setState(() => _consumptionInput = v),
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: _onEnterConsumption,
              child: const Text('Enter'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('CHARMAFA'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => const LoginPage()),
              );
            },
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            children: [
              _buildFilterButtons(),
              const SizedBox(height: 16),
              _buildList(),
              _buildConsumptionInput(),
            ],
          ),
        ),
      ),
    );
  }
}
