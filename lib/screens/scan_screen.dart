import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/device_service.dart';
import '../models/device_model.dart';
import '../providers/profile_provider.dart';
import 'questions_screen.dart';
import '../widgets/loading_overlay.dart';

class ScanScreen extends StatefulWidget {
  const ScanScreen({super.key});

  @override
  State<ScanScreen> createState() => _ScanScreenState();
}

class _ScanScreenState extends State<ScanScreen> {
  bool _scanning = false;
  DeviceModel? _device;

  Future<void> _startScan() async {
    setState(() => _scanning = true);
    try {
      _device = await DeviceService.scanDevice();
      setState(() => _scanning = false);
      if (_device != null) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => QuestionsScreen(device: _device!),
          ),
        );
      }
    } catch (e) {
      setState(() => _scanning = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Scan failed: $e'), backgroundColor: Colors.red),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Device Scan')),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.phone_android, size: 100, color: Color(0xFF00D2FF)),
            const SizedBox(height: 30),
            const Text(
              'Scan Your Device',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            const Text(
              'We\'ll detect your phone specs for optimal sensitivity',
              style: TextStyle(color: Colors.grey, fontSize: 16),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 40),
            if (_scanning) ...[
              const LoadingOverlay(),
              const SizedBox(height: 20),
              const Text('Detecting device...', style: TextStyle(fontSize: 16, color: Colors.grey)),
            ] else ...[
              ElevatedButton.icon(
                onPressed: _startScan,
                icon: const Icon(Icons.scanner),
                label: const Text('Start Scan', style: TextStyle(fontSize: 18)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF00D2FF),
                  foregroundColor: Colors.black,
                  minimumSize: const Size(double.infinity, 60),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                ),
              ),
            ],
            if (_device != null) ...[
              const SizedBox(height: 30),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      _buildDetail('Brand', _device!.brand),
                      _buildDetail('Model', _device!.model),
                      _buildDetail('Android', _device!.androidVersion),
                      _buildDetail('RAM', '${_device!.ramGB} GB'),
                      _buildDetail('Storage', '${_device!.storageGB} GB'),
                      _buildDetail('Resolution', _device!.screenResolution),
                      _buildDetail('Refresh Rate', '${_device!.refreshRate} Hz'),
                    ],
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildDetail(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: Colors.grey, fontSize: 14)),
          Text(value, style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }
}