import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:subs_track/core/utils/currency_utils.dart';
import 'package:subs_track/models/subscription/subscription_model.dart';
import 'package:subs_track/viewmodels/subscription/subscription_notifier.dart';

class HomeView extends ConsumerWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final subscriptions = ref.watch(subscriptionProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('구독 관리 앱')),
      body: subscriptions.when(
        data: (subscriptions) {
          final monthlyExpense =
              ref
                  .read(subscriptionProvider.notifier)
                  .calculateMonthlyExpenses();

          return Column(
            children: [
              _createTitle(monthlyExpense: monthlyExpense),
              _createSubscriptions(subscriptions),
            ],
          );
        },
        error: (error, _) {
          debugPrint(error.toString());
          return Center(
            child: FilledButton(
              onPressed: () {
                ref.read(subscriptionProvider.notifier).refresh();
              },
              child: const Text('새로고침'),
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed:
            () async => await Navigator.pushNamed(context, '/registration'),
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _createTitle({required int monthlyExpense}) {
    return Padding(
      padding: EdgeInsets.all(16.0),
      child: Text(
        '이번 달 총 구독 비용: ${CurrencyUtils.formatCurrency(monthlyExpense, Currency.krw)}원',
        style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _createSubscriptions(List<SubscriptionModel> subscriptions) {
    return Expanded(
      child: ListView.builder(
        itemCount: subscriptions.length,
        itemBuilder: (_, index) {
          final sub = subscriptions[index];

          return ListTile(
            title: Text(sub.serviceName),
            subtitle: Text(
              '구독료: ${CurrencyUtils.formatCurrency(sub.amount, sub.currency)}원 '
              '(매 ${sub.frequency.isMonthly ? "월" : "년"} ${sub.paymentDay}일 결제)',
            ),
          );
        },
      ),
    );
  }
}
