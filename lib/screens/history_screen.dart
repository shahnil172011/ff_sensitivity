import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/history_provider.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<HistoryProvider>(context);
    final history = provider.history;

    return Scaffold(
      appBar: AppBar(
        title: const Text('History'),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_sweep),
            onPressed: () {
              provider.clearHistory();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('History cleared'), backgroundColor: Colors.red),
              );
            },
          ),
        ],
      ),
      body: history.isEmpty
          ? const Center(child: Text('No history', style: TextStyle(color: Colors.grey)))
          : ListView.builder(
              itemCount: history.length,
              itemBuilder: (ctx, i) {
                final entry = history[i];
                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: ListTile(
                    title: Text(entry['name'] ?? 'Profile'),
                    subtitle: Text('Device: ${entry['device'] ?? 'Unknown'} | Style: ${entry['style'] ?? 'balanced'}'),
                    trailing: Text(
                      entry['date']?.toString().substring(0, 16) ?? '',
                      style: const TextStyle(color: Colors.grey, fontSize: 12),
                    ),
                  ),
                );
              },
            ),
    );
  }
}