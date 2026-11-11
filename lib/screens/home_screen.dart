import 'package:flutter/material.dart';
import '../config/app_config.dart';
import '../utils/logger.dart';
import '../utils/validators.dart';
import 'post_list_screen.dart';
import 'user_list_screen.dart';

/// Halaman Beranda Praktikum RPL & Keamanan.
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _phoneController = TextEditingController();
  final _urlController = TextEditingController();
  final _passwordController = TextEditingController();
  final _inputController = TextEditingController();
  String _sanitizedOutput = '';

  String? _phoneError;
  String? _urlError;
  String? _passwordError;

  @override
  void dispose() {
    _phoneController.dispose();
    _urlController.dispose();
    _passwordController.dispose();
    _inputController.dispose();
    super.dispose();
  }

  void _testValidation() {
    setState(() {
      _phoneError = Validators.validatePhone(_phoneController.text);
      _urlError = Validators.validateUrl(_urlController.text);
      _passwordError = Validators.validatePassword(_passwordController.text);
    });

    if (_phoneError == null && _urlError == null && _passwordError == null) {
      AppLogger.info('Validasi form input berhasil');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Semua validasi berhasil!')),
      );
    } else {
      AppLogger.warning('Validasi form gagal');
    }
  }

  void _runSanitize() {
    setState(() {
      _sanitizedOutput = Validators.sanitize(_inputController.text);
    });
    AppLogger.debug('Sanitasi input dijalankan');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('RPL & Keamanan (Pertemuan 6)'),
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Info Config .env
          Card(
            color: Colors.deepPurple.shade50,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    children: [
                      Icon(Icons.security, color: Colors.deepPurple),
                      SizedBox(width: 8),
                      Text(
                        'Status Konfigurasi (.env)',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text('Base URL: ${AppConfig.baseUrl}'),
                  Text('API Key: ${AppConfig.apiKey.isNotEmpty ? "Tersembunyi (${AppConfig.apiKey.substring(0, 4)}***)" : "Belum diatur"}'),
                  Text('Status: ${AppConfig.isConfigured() ? "✅ Terkonfigurasi" : "❌ Belum Lengkap"}'),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Menu Navigasi Repository
          const Text(
            'Navigasi Repository Pattern',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const UserListScreen()),
                    );
                  },
                  icon: const Icon(Icons.people),
                  label: const Text('User List'),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const PostListScreen()),
                    );
                  },
                  icon: const Icon(Icons.article),
                  label: const Text('Post List (Latihan 1)'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.teal,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Demo Latihan 3 & 4 (Validators & Sanitasi)
          const Text(
            'Pengujian Validasi & Sanitasi (Latihan 3 & 4)',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          const SizedBox(height: 8),
          TextField(
            controller: _phoneController,
            keyboardType: TextInputType.phone,
            decoration: InputDecoration(
              labelText: 'Nomor Telepon (10-13 digit)',
              errorText: _phoneError,
              border: const OutlineInputBorder(),
              isDense: true,
            ),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _urlController,
            decoration: InputDecoration(
              labelText: 'URL (http:// atau https://)',
              errorText: _urlError,
              border: const OutlineInputBorder(),
              isDense: true,
            ),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _passwordController,
            obscureText: true,
            decoration: InputDecoration(
              labelText: 'Password (min 8 char, besar, angka, simbol)',
              errorText: _passwordError,
              border: const OutlineInputBorder(),
              isDense: true,
            ),
          ),
          const SizedBox(height: 12),
          ElevatedButton(
            onPressed: _testValidation,
            child: const Text('Uji Validasi Form'),
          ),
          const Divider(height: 32),

          // Sanitasi input demo
          TextField(
            controller: _inputController,
            decoration: const InputDecoration(
              labelText: 'Input teks dengan tag HTML / script berbahaya',
              hintText: '<script>alert("XSS")</script>',
              border: OutlineInputBorder(),
              isDense: true,
            ),
          ),
          const SizedBox(height: 8),
          ElevatedButton(
            onPressed: _runSanitize,
            child: const Text('Sanitasi Input'),
          ),
          if (_sanitizedOutput.isNotEmpty) ...[
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(12),
              color: Colors.grey.shade100,
              child: SelectableText(
                'Hasil Sanitasi:\n$_sanitizedOutput',
                style: const TextStyle(fontFamily: 'monospace'),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
