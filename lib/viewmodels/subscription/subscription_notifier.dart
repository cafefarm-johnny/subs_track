import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:subs_track/extensions/mappers/model_mapper.dart';
import 'package:subs_track/models/subscription/subscription_data.dart';
import 'package:subs_track/repositories/subscription_repository.dart';

final subscriptionProvider =
    AsyncNotifierProvider<SubscriptionNotifier, List<SubscriptionData>>(
      SubscriptionNotifier.new,
    );

class SubscriptionNotifier extends AsyncNotifier<List<SubscriptionData>> {
  final _subscriptionRepository = SubscriptionRepository();

  @override
  Future<List<SubscriptionData>> build() async {
    return await _fetchSubscriptions();
  }

  /// 구독 목록 조회
  Future<List<SubscriptionData>> _fetchSubscriptions() async {
    await Future.delayed(const Duration(seconds: 2));

    return _subscriptionRepository.getAll().map((e) => e.toDomain()).toList();
  }

  /// 구독 목록 새로고침
  Future<void> refresh() async {
    state = const AsyncValue.loading();
    state = AsyncValue.data(await _fetchSubscriptions());
  }

  /// 구독 추가
  void addSubscription(SubscriptionData subscription) {
    _subscriptionRepository.add(subscription.toEntity());

    if (state.hasValue) {
      state = AsyncValue.data([...state.requireValue, subscription]);
    }
  }

  /// 구독 삭제
  void removeSubscription(int id) {
    final isDeleted = _subscriptionRepository.delete(id);

    if (isDeleted && state.hasValue) {
      state = AsyncValue.data(
        state.requireValue
            .where((subscription) => (subscription.id ?? 0) != id)
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
