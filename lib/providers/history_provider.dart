import 'package:flutter/material.dart';
import '../services/storage_service.dart';

class HistoryProvider extends ChangeNotifier {
  List<Map<String, dynamic>> _history = [];

  List<Map<String, dynamic>> get history => _history;

  HistoryProvider() {
    _loadHistory();
  }

  Future<void> _loadHistory() async {
    _history = await StorageService.loadHistory();
    notifyListeners();
  }

  Future<void> addEntry(Map<String, dynamic> entry) async {
    _history.insert(0, entry);
    if (_history.length > 100) _history.removeLast();
    await StorageService.saveHistory(_history);
    notifyListeners();
  }

  Future<void> clearHistory() async {
    _history.clear();
    await StorageService.saveHistory(_history);
    notifyListeners();
  }
}