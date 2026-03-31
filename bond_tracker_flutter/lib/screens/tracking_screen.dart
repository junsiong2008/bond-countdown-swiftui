import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/bond_data.dart';
import '../services/bond_store.dart';
import '../widgets/stat_card.dart';
import '../widgets/detail_row.dart';
import 'setup_screen.dart';

class TrackingScreen extends StatefulWidget {
  final BondData data;

  const TrackingScreen({super.key, required this.data});

  @override
  State<TrackingScreen> createState() => _TrackingScreenState();
}

class _TrackingScreenState extends State<TrackingScreen> {
  late BondData _data;
  final _store = BondStore();

  @override
  void initState() {
    super.initState();
    _data = widget.data;
  }

  Future<void> _openSettings() async {
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => SetupScreen(
          existingData: _data,
          onSaved: () async {
            Navigator.of(context).pop();
            final updated = await _store.load();
            if (updated != null) {
              setState(() => _data = updated);
            }
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final currencyFormat =
        NumberFormat.currency(locale: 'en_US', symbol: '\$');
    final dateFormat = DateFormat.yMMMd();

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text('Bond Tracker'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: _openSettings,
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Bond Remaining Card
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Bond Remaining',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            color: Colors.grey[600],
                          ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      currencyFormat.format(_data.bondRemaining),
                      style: const TextStyle(
                        fontSize: 48,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Progress Section
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Progress',
                          style:
                              Theme.of(context).textTheme.titleMedium?.copyWith(
                                    fontWeight: FontWeight.w600,
                                  ),
                        ),
                        Text(
                          '${_data.completionPercentage.toStringAsFixed(1)}%',
                          style:
                              Theme.of(context).textTheme.titleMedium?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.blue,
                                  ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: LinearProgressIndicator(
                        value: _data.completionPercentage / 100,
                        minHeight: 16,
                        backgroundColor: Colors.grey[200],
                        valueColor:
                            const AlwaysStoppedAnimation<Color>(Colors.blue),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Stats Grid
              Text(
                'Statistics',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
              ),
              const SizedBox(height: 10),
              GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                childAspectRatio: 1.3,
                children: [
                  StatCard(
                    icon: Icons.event_available,
                    value: _data.daysServed.toString(),
                    title: 'Days Served',
                    color: Colors.green,
                  ),
                  StatCard(
                    icon: Icons.pending_actions,
                    value: _data.daysRemaining.toString(),
                    title: 'Days Remaining',
                    color: Colors.orange,
                  ),
                  StatCard(
                    icon: Icons.attach_money,
                    value: currencyFormat.format(_data.dailyBondCost),
                    title: 'Daily Cost',
                    color: Colors.purple,
                  ),
                  StatCard(
                    icon: Icons.calendar_month,
                    value: _data.totalServiceDays.toString(),
                    title: 'Total Days',
                    color: Colors.blue,
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Bond Details Section
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Bond Details',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                    const SizedBox(height: 12),
                    const Divider(height: 1),
                    const SizedBox(height: 8),
                    DetailRow(
                      label: 'Total Bond',
                      value: currencyFormat.format(_data.totalBondAmount),
                    ),
                    DetailRow(
                      label: 'Start Date',
                      value: dateFormat.format(_data.startDate),
                    ),
                    DetailRow(
                      label: 'End Date',
                      value: _data.isComplete
                          ? 'Service Complete!'
                          : dateFormat.format(_data.estimatedEndDate),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}
