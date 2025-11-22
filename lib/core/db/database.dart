import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:subs_track/objectbox.g.dart';

class Database {
  static Database? _instance;

  final Store store;

  Database._internal(this.store);

  static Database get instance {
    if (_instance == null) {
      throw StateError("데이터 베이스가 초기화되지 않았습니다. Database.initialize()를 호출해주세요.");
    }

    return _instance!;
  }

  static Future<void> initialize() async {
    if (_instance != null) {
      return;
    }

    final dir = await getApplicationDocumentsDirectory();
    final store = await openStore(directory: p.join(dir.path, 'subs_track.db'));

    _instance = Database._internal(store);
  }
}
