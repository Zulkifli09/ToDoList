import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';
import 'package:task_flow/domain/models/task_model.dart';

class IsarDb {
  static late Isar instance;

  static Future<void> initialize() async {
    final dir = await getApplicationDocumentsDirectory();
    instance = await Isar.open([TaskModelSchema], directory: dir.path);
  }
}
