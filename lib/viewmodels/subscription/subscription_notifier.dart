import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:subs_track/extensions/mappers/model_mapper.dart';
import 'package:subs_track/models/db/subscription_entity.dart';
import 'package:subs_track/models/subscription/subscription_data.dart';

final subscriptionProvider =
    AsyncNotifierProvider<SubscriptionNotifier, List<SubscriptionData>>(
      SubscriptionNotifier.new,
    );

class SubscriptionNotifier extends AsyncNotifier<List<SubscriptionData>> {
  @override
  Future<List<SubscriptionData>> build() async {
    return await _fetchSubscriptions();
  }

  /// 구독 목록 조회
  ///
  /// FIXME: DB에서 데이터를 조회하도록 코드를 수정해야합니다.
  Future<List<SubscriptionData>> _fetchSubscriptions() async {
    await Future.delayed(const Duration(seconds: 2));

    final dummy = [
      SubscriptionEntity(
        id: 1,
        serviceName: 'Apple One',
        currencyIndex: Currency.krw.index,
        amount: 14900,
        frequencyIndex: PaymentFrequency.monthly.index,
        paymentDay: 4,
        createdAt: DateTime.now(),
      ),
      SubscriptionEntity(
        id: 2,
        serviceName: '신한은행 IRP',
        currencyIndex: Currency.krw.index,
        amount: 750000,
        frequencyIndex: PaymentFrequency.monthly.index,
        paymentDay: 4,
        createdAt: DateTime.now(),
      ),
      SubscriptionEntity(
        id: 3,
        serviceName: '네이버플러스 멤버쉽',
        currencyIndex: Currency.krw.index,
        amount: 4900,
        frequencyIndex: PaymentFrequency.monthly.index,
        paymentDay: 8,
        createdAt: DateTime.now(),
      ),
    ];

    return dummy.map((e) => e.toDomain()).toList();
  }

  /// 구독 목록 새로고침
  Future<void> refresh() async {
    state = const AsyncValue.loading();
    state = AsyncValue.data(await _fetchSubscriptions());
  }

  /// 구독 추가
  ///
  /// FIXME: DB에 데이터를 추가하도록 코드를 수정해야합니다.
  void addSubscription(SubscriptionData subscription) {
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
