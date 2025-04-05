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

class SubscriptionModel {
  final String id;
  final String serviceName;
  final Currency currency;
  final int amount;
  final PaymentFrequency frequency;
  final int paymentDay;

  SubscriptionModel({
    required this.id,
    required this.serviceName,
    required this.currency,
    required this.amount,
    required this.frequency,
    required this.paymentDay,
  });

  bool isDueToday(DateTime date) {
    return frequency.isMonthly && date.day == paymentDay;
  }
}
