import 'package:flutter/material.dart';

class ProgressScreen extends StatefulWidget {
  const ProgressScreen({super.key});

  @override
  State<ProgressScreen> createState() => _ProgressScreenState();
}

class _ProgressScreenState extends State<ProgressScreen> {
  String mode = 'Workouts';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Progress')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _toggleButton('Workouts'),
                const SizedBox(width: 8),
                _toggleButton('Volume'),
                const SizedBox(width: 8),
                _toggleButton('Streak'),
              ],
            ),
            const SizedBox(height: 16),
            Expanded(
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.orange),
                  borderRadius: BorderRadius.circular(8),
                ),
                alignment: Alignment.center,
                child: Text(
                  'Simple chart: $mode over time',
                  style: const TextStyle(fontSize: 16),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                _summaryCard('Current streak', '3 days'),
                const SizedBox(width: 8),
                _summaryCard('This week', '4 workouts'),
                const SizedBox(width: 8),
                _summaryCard('Challenges joined', '2'),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _toggleButton(String label) {
    final selected = mode == label;
    return Expanded(
      child: ElevatedButton(
        onPressed: () {
          setState(() {
            mode = label;
          });
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: selected ? Colors.orange : null,
        ),
        child: Text(label),
      ),
    );
  }

  Widget _summaryCard(String title, String value) {
    return Expanded(
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            children: [
              Text(
                value,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 4),
              Text(title),
            ],
          ),
        ),
      ),
    );
  }
}
