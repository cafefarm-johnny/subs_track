enum PaymentFrequency {
  monthly,
  yearly;

  bool get isMonthly => this == monthly;
  bool get isYearly => this == yearly;
}

enum Currency {
  krw,
  usd;

  bool get isKRW => this == krw;
}

class SubscriptionData {
  final int? id;
  final String serviceName;
  final Currency currency;
  final int amount;
  final PaymentFrequency frequency;
  final int paymentDay;
  final DateTime createdAt;
  final DateTime? updatedAt;

  SubscriptionData({
    this.id,
    required this.serviceName,
    required this.currency,
    required this.amount,
    required this.frequency,
    required this.paymentDay,
    this.updatedAt,
  }) : createdAt = DateTime.now();

  bool isDueToday(DateTime date) {
    return frequency.isMonthly && date.day == paymentDay;
  }
}
