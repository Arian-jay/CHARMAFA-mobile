import 'package:flutter/material.dart';
import '../services/database_helper.dart';
import 'login_page.dart';
import 'meter_input_page.dart';
import 'package:blue_thermal_printer/blue_thermal_printer.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Map<String, dynamic>> _meters = [];
  bool _filterByTs = false;
  bool _filterByPurok = false;
  Map<String, dynamic>? _selectedMeter;
  String _consumptionInput = '';
  String? _selectedPrinter;
  List<BluetoothDevice> _devices = [];
  BlueThermalPrinter bluetooth = BlueThermalPrinter.instance;

  @override
  void initState() {
    super.initState();
    _loadMeters();
    _getBluetoothDevices();
    _resetIsReadIfNeeded();
  }

  void _resetIsReadIfNeeded() async {
    final now = DateTime.now();
    if (now.day == 10) {
      final db = await DatabaseHelper.instance.database;
      await db.rawUpdate('UPDATE members SET is_read = 0');
      await _loadMeters();
    }
  }

  Future<void> _getBluetoothDevices() async {
    try {
      final devices = await bluetooth.getBondedDevices();
      setState(() {
        _devices = devices;
      });
    } catch (e) {
      // Show error if Bluetooth is off or permission denied
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Bluetooth error: ${e.toString()}')),
      );
    }
  }

  Future<void> _loadMeters() async {
    final meters = await DatabaseHelper.instance.getAllMeterDetails();
    setState(() {
      _meters = meters;
    });
  }

  List<String> get _uniqueTs {
    final tsList = _meters.map((m) => m['ts_no'] as String).toSet().toList();
    tsList.sort((a, b) => a.compareTo(b));
    return tsList;
  }

  List<String> get _uniquePuroks => _meters.map((m) => m['purok'] as String).toSet().toList();

  Widget _buildFilterButtons() {
    return Row(
      children: [
        Expanded(
          child: ElevatedButton(
            onPressed: () {
              setState(() {
                _filterByTs = true;
                _filterByPurok = false;
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

  Widget _buildPrinterDropdown() {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 12),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.green[100],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.green, width: 2),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          icon: const Icon(Icons.print, color: Colors.green),
          hint: const Text('Select Printer', style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold)),
          value: _selectedPrinter,
          items: _devices.map((d) => DropdownMenuItem(
            value: d.name,
            child: Text(d.name ?? '', style: const TextStyle(color: Colors.green, fontWeight: FontWeight.bold)),
          )).toList(),
          onChanged: (v) => setState(() => _selectedPrinter = v),
        ),
      ),
    );
  }

  Widget _buildList() {
    if (_filterByTs) {
      final tsGroups = _uniqueTs;
      return ListView(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        children: tsGroups.map((ts) {
          final metersInTs = _meters.where((m) => m['ts_no'] == ts).toList();
          return ExpansionTile(
            title: Text("TS $ts"),
            children: metersInTs.map((meter) {
              final isSelected = _selectedMeter == meter;
              final isRead = meter['is_read'] == 1;
              return Card(
                color: isRead ? const Color(0xFF44FF00).withOpacity(0.34) : (isSelected ? Colors.grey[300] : Colors.white),
                child: ListTile(
                  title: Text("Meter No: ${meter['meter_no']}"),
                  subtitle: Text("Name: ${meter['fname']} | Purok: ${meter['purok']}"),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => MeterInputPage(
                          meter: meter,
                          selectedPrinter: _selectedPrinter,
                          devices: _devices,
                        ),
                      ),
                    ).then((_) => _loadMeters());
                  },
                ),
              );
            }).toList(),
          );
        }).toList(),
      );
    }
    if (_filterByPurok) {
      final purokGroups = _uniquePuroks;
      return ListView(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        children: purokGroups.map((purok) {
          final tsInPurok = _uniqueTs
              .where((ts) => _meters.any((m) => m['purok'] == purok && m['ts_no'] == ts))
              .toList();

          return ExpansionTile(
            title: Text("$purok"),
            children: tsInPurok.map((ts) {
              final metersInTs =
                  _meters.where((m) => m['purok'] == purok && m['ts_no'] == ts).toList();

              return ExpansionTile(
                title: Text("TS $ts"),
                children: metersInTs.map((meter) {
                  final isSelected = _selectedMeter == meter;
                  final isRead = meter['is_read'] == 1;
                  return Card(
                    color: isRead ? const Color(0xFF44FF00).withOpacity(0.34) : (isSelected ? Colors.grey[300] : Colors.white),
                    child: ListTile(
                      title: Text("Meter No: ${meter['meter_no']}"),
                      subtitle: Text("Name: ${meter['fname']}"),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => MeterInputPage(
                              meter: meter,
                              selectedPrinter: _selectedPrinter,
                              devices: _devices,
                            ),
                          ),
                        ).then((_) => _loadMeters());
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('CHARMAFA'),
        actions: [
          _buildPrinterDropdown(),
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
            ],
          ),
        ),
      ),
    );
  }
}
