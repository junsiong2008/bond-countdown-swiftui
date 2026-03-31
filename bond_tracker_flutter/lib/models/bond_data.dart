class BondData {
  final double totalBondAmount;
  final int totalServiceDays;
  final DateTime startDate;

  const BondData({
    required this.totalBondAmount,
    required this.totalServiceDays,
    required this.startDate,
  });

  bool get isConfigured => totalBondAmount > 0 && totalServiceDays > 0;

  int get daysServed {
    final now = DateTime.now();
    final diff = DateTime(now.year, now.month, now.day)
        .difference(DateTime(startDate.year, startDate.month, startDate.day));
    return diff.inDays.clamp(0, totalServiceDays);
  }

  int get daysRemaining => (totalServiceDays - daysServed).clamp(0, totalServiceDays);

  double get completionPercentage =>
      totalServiceDays > 0 ? (daysServed / totalServiceDays * 100).clamp(0, 100) : 0;

  double get dailyBondCost =>
      totalServiceDays > 0 ? totalBondAmount / totalServiceDays : 0;

  double get bondRemaining =>
      (totalBondAmount - dailyBondCost * daysServed).clamp(0, totalBondAmount);

  DateTime get estimatedEndDate =>
      startDate.add(Duration(days: totalServiceDays));

  bool get isComplete => daysServed >= totalServiceDays;
}
