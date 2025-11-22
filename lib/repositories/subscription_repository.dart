import 'package:subs_track/core/db/database.dart';
import 'package:subs_track/core/utils/log_utils.dart';
import 'package:subs_track/models/db/subscription_entity.dart';

class SubscriptionRepository {
  final _subscriptionBox = Database.instance.store.box<SubscriptionEntity>();

  List<SubscriptionEntity> getAll() {
    final entities = _subscriptionBox.getAll();
    LogUtils.d(entities.map((e) => e.toString()).join('\n'));

    return _subscriptionBox.getAll();
  }

  void add(SubscriptionEntity entity) {
    _subscriptionBox.put(entity);
  }

  bool delete(int id) {
    return _subscriptionBox.remove(id);
  }
}
