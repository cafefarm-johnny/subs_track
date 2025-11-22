enum PaymentFrequency {
  monthly,
  yearly;

  factory PaymentFrequency.from(int index) {
    try {
      return values[index];
    } catch (e) {
      throw ArgumentError.value(index, 'index', '파라미터가 유효하지 않습니다.');
    }
  }

  bool get isMonthly => this == monthly;
  bool get isYearly => this == yearly;
}

enum Currency {
  krw,
  usd;

  factory Currency.from(int index) {
    try {
      return values[index];
    } catch (e) {
      throw ArgumentError.value(index, 'index', '파라미터가 유효하지 않습니다.');
    }
  }

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
    required this.createdAt,
    this.updatedAt,
  });

  bool isDueToday(DateTime date) {
    return frequency.isMonthly && date.day == paymentDay;
  }
}
