import 'package:subs_track/models/db/subscription_entity.dart';
import 'package:subs_track/models/subscription/subscription_data.dart';

extension SubscriptionDataMapper on SubscriptionEntity {
  SubscriptionData toDomain() {
    return SubscriptionData(
      id: id,
      serviceName: serviceName,
      currency: Currency.from(currencyIndex),
      amount: amount,
      frequency: PaymentFrequency.from(frequencyIndex),
      paymentDay: paymentDay,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }
}

extension SubscriptionEntityMapper on SubscriptionData {
  SubscriptionEntity toEntity() {
    return SubscriptionEntity(
      id: id ?? 0,
      serviceName: serviceName,
      currencyIndex: currency.index,
      amount: amount,
      frequencyIndex: frequency.index,
      paymentDay: paymentDay,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }
}
