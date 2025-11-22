import 'package:objectbox/objectbox.dart';

@Entity()
class SubscriptionEntity {
  @Id()
  int id = 0;
  String serviceName;
  int currencyIndex;
  int amount;
  int frequencyIndex;
  int paymentDay;
  DateTime createdAt;
  DateTime? updatedAt;

  SubscriptionEntity({
    this.id = 0,
    required this.serviceName,
    required this.currencyIndex,
    required this.amount,
    required this.frequencyIndex,
    required this.paymentDay,
    required this.createdAt,
    this.updatedAt,
  });
}
