import 'package:shared_preferences/shared_preferences.dart';
import 'package:home_widget/home_widget.dart';
import '../models/bond_data.dart';

const _appGroupId = 'group.xyz.jsdevexperiment.bondtracker';

class BondStore {
  static const _keyTotalBondAmount = 'totalBondAmount';
  static const _keyTotalServiceDays = 'totalServiceDays';
  static const _keyStartDate = 'startDate';

  Future<BondData?> load() async {
    final prefs = await SharedPreferences.getInstance();
    final amount = prefs.getDouble(_keyTotalBondAmount);
    final days = prefs.getInt(_keyTotalServiceDays);
    final dateMs = prefs.getInt(_keyStartDate);

    if (amount == null || days == null || dateMs == null) return null;

    return BondData(
      totalBondAmount: amount,
      totalServiceDays: days,
      startDate: DateTime.fromMillisecondsSinceEpoch(dateMs),
    );
  }

  Future<void> save(BondData data) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble(_keyTotalBondAmount, data.totalBondAmount);
    await prefs.setInt(_keyTotalServiceDays, data.totalServiceDays);
    await prefs.setInt(_keyStartDate, data.startDate.millisecondsSinceEpoch);

    await _updateWidget(data);
  }

  Future<void> clear() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_keyTotalBondAmount);
    await prefs.remove(_keyTotalServiceDays);
    await prefs.remove(_keyStartDate);

    await HomeWidget.saveWidgetData<bool>('isConfigured', false);
    await HomeWidget.updateWidget(
      iOSName: 'BondTrackerWidget',
      androidName: 'BondTrackerWidgetProvider',
    );
  }

  /// Push computed values to the widget and trigger a refresh.
  static Future<void> _updateWidget(BondData data) async {
    await HomeWidget.setAppGroupId(_appGroupId);
    await Future.wait([
      HomeWidget.saveWidgetData<bool>('isConfigured', true),
      HomeWidget.saveWidgetData<double>('bondRemaining', data.bondRemaining),
      HomeWidget.saveWidgetData<double>(
          'completionPercentage', data.completionPercentage),
      HomeWidget.saveWidgetData<int>('daysRemaining', data.daysRemaining),
      HomeWidget.saveWidgetData<double>(
          'totalBondAmount', data.totalBondAmount),
    ]);
    await HomeWidget.updateWidget(
      iOSName: 'BondTrackerWidget',
      androidName: 'BondTrackerWidgetProvider',
    );
  }

  /// Call once at app startup to initialise the widget bridge.
  static Future<void> init() async {
    await HomeWidget.setAppGroupId(_appGroupId);
  }
}
