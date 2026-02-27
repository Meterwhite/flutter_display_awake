import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_display_awake/flutter_display_awake.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final _plugin = FlutterDisplayAwake();
  bool? _isKeepingScreenOn;

  @override
  void initState() {
    super.initState();
    _syncState();
  }

  Future<void> _syncState() async {
    try {
      final held = await _plugin.isKeptOn();
      setState(() => _isKeepingScreenOn = held);
    } on MissingPluginException {
      setState(() => _isKeepingScreenOn = null);
    } catch (_) {
      setState(() => _isKeepingScreenOn = null);
    }
  }

  Future<void> _keepScreenOn() async {
    try {
      await _plugin.keepScreenOn();
      await _syncState();
    } on PlatformException catch (e) {
      _showSnackBar('Error: ${e.message}');
    } on UnsupportedError catch (e) {
      _showSnackBar('Unsupported: ${e.message}');
    }
  }

  Future<void> _keepScreenOff() async {
    try {
      await _plugin.keepScreenOff();
      await _syncState();
    } on PlatformException catch (e) {
      _showSnackBar('Error: ${e.message}');
    } on UnsupportedError catch (e) {
      _showSnackBar('Unsupported: ${e.message}');
    }
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Display Awake Example',
      home: Scaffold(
        appBar: AppBar(title: const Text('Display Awake Example')),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                _isKeepingScreenOn == true
                    ? Icons.brightness_high
                    : Icons.brightness_low,
                size: 80,
                color: _isKeepingScreenOn == true ? Colors.amber : Colors.grey,
              ),
              const SizedBox(height: 24),
              Text(
                _isKeepingScreenOn == null
                    ? 'Screen state is unknown on this platform'
                    : _isKeepingScreenOn!
                    ? 'Screen will stay on'
                    : 'Screen may turn off',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 40),
              ElevatedButton.icon(
                onPressed: _isKeepingScreenOn == true ? null : _keepScreenOn,
                icon: const Icon(Icons.lock_open),
                label: const Text('Keep Screen On'),
              ),
              const SizedBox(height: 16),
              ElevatedButton.icon(
                onPressed: _isKeepingScreenOn == true ? _keepScreenOff : null,
                icon: const Icon(Icons.lock),
                label: const Text('Allow Screen Off'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
