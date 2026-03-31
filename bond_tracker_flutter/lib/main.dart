import 'package:flutter/material.dart';
import 'models/bond_data.dart';
import 'services/bond_store.dart';
import 'screens/setup_screen.dart';
import 'screens/tracking_screen.dart';

void main() {
  runApp(const BondTrackerApp());
}

class BondTrackerApp extends StatelessWidget {
  const BondTrackerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Bond Tracker',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
        fontFamily: 'SF Pro Display',
      ),
      home: const _RootScreen(),
    );
  }
}

class _RootScreen extends StatefulWidget {
  const _RootScreen();

  @override
  State<_RootScreen> createState() => _RootScreenState();
}

class _RootScreenState extends State<_RootScreen> with WidgetsBindingObserver {
  final _store = BondStore();
  BondData? _bondData;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _load();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _load();
    }
  }

  Future<void> _load() async {
    final data = await _store.load();
    setState(() {
      _bondData = data;
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    final data = _bondData;

    if (data == null || !data.isConfigured) {
      return SetupScreen(
        onSaved: _load,
      );
    }

    return TrackingScreen(data: data);
  }
}
