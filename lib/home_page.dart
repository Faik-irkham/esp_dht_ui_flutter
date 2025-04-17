import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final DatabaseReference _dbRef = FirebaseDatabase.instance.ref('esp32');

  double? suhu;
  double? kelembaban;

  @override
  void initState() {
    super.initState();

    _dbRef.child('temp').onValue.listen((event) {
      final data = event.snapshot.value;
      if (data != null) {
        setState(() {
          suhu = double.tryParse(data.toString());
        });
      }
    });

    _dbRef.child('humi').onValue.listen((event) {
      final data = event.snapshot.value;
      if (data != null) {
        setState(() {
          kelembaban = double.tryParse(data.toString());
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Realtime Monitoring'),
        backgroundColor: Colors.teal,
        centerTitle: true,
      ),
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.teal, Colors.tealAccent],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child:
            suhu == null || kelembaban == null
                ? const Center(
                  child: CircularProgressIndicator(color: Colors.white),
                )
                : Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildSensorCard(
                      icon: Icons.thermostat,
                      label: 'Suhu',
                      value: '${suhu!.toStringAsFixed(2)} °C',
                      color: Colors.orange,
                    ),
                    const SizedBox(height: 24),
                    _buildSensorCard(
                      icon: Icons.water_drop,
                      label: 'Kelembaban',
                      value: '${kelembaban!.toStringAsFixed(2)} %',
                      color: Colors.blueAccent,
                    ),
                  ],
                ),
      ),
    );
  }

  Widget _buildSensorCard({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 24),
      elevation: 8,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 48, color: color),
            const SizedBox(width: 20),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
