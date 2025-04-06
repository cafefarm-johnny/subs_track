import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:subs_track/models/subscription/subscription_model.dart';

final subscriptionProvider =
    StateNotifierProvider<SubscriptionNotifier, List<SubscriptionModel>>(
      (ref) => SubscriptionNotifier(),
    );

class SubscriptionNotifier extends StateNotifier<List<SubscriptionModel>> {
  SubscriptionNotifier() : super([]);

  Future<void> fetchSubscriptions() async {
    await Future.delayed(const Duration(seconds: 2));

    state = [
      SubscriptionModel(
        id: '1',
        serviceName: 'Apple One',
        currency: Currency.krw,
        amount: 14900,
        frequency: PaymentFrequency.monthly,
        paymentDay: 4,
      ),
      SubscriptionModel(
        id: '2',
        serviceName: '신한은행 IRP',
        currency: Currency.krw,
        amount: 750000,
        frequency: PaymentFrequency.monthly,
        paymentDay: 4,
      ),
      SubscriptionModel(
        id: '3',
        serviceName: '네이버플러스 멤버쉽',
        currency: Currency.krw,
        amount: 4900,
        frequency: PaymentFrequency.monthly,
        paymentDay: 8,
      ),
    ];
  }

  void addSubscription(SubscriptionModel subscription) {
    state = [...state, subscription];
  }

  void removeSubscription(String id) {
    state = state.where((subscription) => subscription.id != id).toList();
  }

  int calculateMonthlyExpenses() {
    return state.fold(0, (total, sub) {
      if (sub.frequency.isMonthly) {
        return total + sub.amount;
      }

      if (sub.frequency.isYearly) {
        return total + (sub.amount / 12).toInt();
      }

      return total;
    });
  }
}
