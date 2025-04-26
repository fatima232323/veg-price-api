import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as path;

class ServerManager {
  static final ServerManager _instance = ServerManager._internal();
  static const String baseUrl = 'http://127.0.0.1:5000';
  Process? _serverProcess;
  bool _isServerRunning = false;

  factory ServerManager() {
    return _instance;
  }

  ServerManager._internal();

  Future<bool> startServer() async {
    if (_isServerRunning) return true;

    try {
      final scriptPath = path.join(
        Directory.current.path,
        'servicehub_ml',
        'api.py',
      );

      if (!await File(scriptPath).exists()) {
        print('Error: Server script not found at $scriptPath');
        return false;
      }

      _serverProcess = await Process.start(
        'python',
        [scriptPath],
        runInShell: true,
      );

      _serverProcess?.stdout.listen((data) {
        print('Server output: ${String.fromCharCodes(data)}');
      });

      _serverProcess?.stderr.listen((data) {
        print('Server error: ${String.fromCharCodes(data)}');
      });

      // Wait for server to start
      await Future.delayed(const Duration(seconds: 2));

      // Check if server is actually running
      _isServerRunning = await checkServerStatus();
      return _isServerRunning;
    } catch (e) {
      print('Error starting server: $e');
      await stopServer();
      return false;
    }
  }

  Future<bool> checkServerStatus() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/health'));
      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }

  Future<void> stopServer() async {
    if (_serverProcess != null) {
      try {
        _serverProcess?.kill();
        await _serverProcess?.exitCode;
      } catch (e) {
        print('Error stopping server: $e');
      } finally {
        _serverProcess = null;
        _isServerRunning = false;
      }
    }
  }

  bool get serverStatus => _isServerRunning;
}
