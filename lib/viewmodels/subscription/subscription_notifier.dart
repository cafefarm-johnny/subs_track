import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:subs_track/models/subscription/subscription_model.dart';

final subscriptionProvider =
    AsyncNotifierProvider<SubscriptionNotifier, List<SubscriptionModel>>(
      SubscriptionNotifier.new,
    );

class SubscriptionNotifier extends AsyncNotifier<List<SubscriptionModel>> {
  @override
  Future<List<SubscriptionModel>> build() async {
    return await _fetchSubscriptions();
  }

  /// 구독 목록 조회
  ///
  /// FIXME: DB에서 데이터를 조회하도록 코드를 수정해야합니다.
  Future<List<SubscriptionModel>> _fetchSubscriptions() async {
    await Future.delayed(const Duration(seconds: 2));

    return [
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

  /// 구독 목록 새로고침
  Future<void> refresh() async {
    state = const AsyncValue.loading();
    state = AsyncValue.data(await _fetchSubscriptions());
  }

  /// 구독 추가
  ///
  /// FIXME: DB에 데이터를 추가하도록 코드를 수정해야합니다.
  void addSubscription(SubscriptionModel subscription) {
    if (state.hasValue) {
      state = AsyncValue.data([...state.requireValue, subscription]);
    }
  }

  /// 구독 삭제
  ///
  /// FIXME: DB에서 데이터를 삭제하도록 코드를 수정해야합니다.
  void removeSubscription(String id) {
    if (state.hasValue) {
      state = AsyncValue.data(
        state.requireValue
            .where((subscription) => subscription.id != id)
            .toList(),
      );
    }
  }

  /// 월간 비용 합산
  int calculateMonthlyExpenses() {
    if (state.hasValue) {
      return state.requireValue.fold(0, (total, sub) {
        if (sub.frequency.isMonthly) {
          return total + sub.amount;
        }

        if (sub.frequency.isYearly) {
          return total + (sub.amount / 12).toInt();
        }

        return total;
      });
    }

    return 0;
  }
}
