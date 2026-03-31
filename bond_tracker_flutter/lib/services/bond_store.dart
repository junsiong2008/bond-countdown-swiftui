import 'package:shared_preferences/shared_preferences.dart';
import '../models/bond_data.dart';

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
  }

  Future<void> clear() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_keyTotalBondAmount);
    await prefs.remove(_keyTotalServiceDays);
    await prefs.remove(_keyStartDate);
  }
}
