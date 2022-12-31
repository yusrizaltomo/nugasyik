import 'package:flutter/foundation.dart';
import 'package:nugasyik/homework.dart';

import 'database_helper.dart';

class DbProvider extends ChangeNotifier {
  late DatabaseHelper _dbHelper;

  List<Homework> _homeworks = [];

  List<Homework> get homeworks => _homeworks;

  DbProvider() {
    _dbHelper = DatabaseHelper();
    _getAllHomeworks();
  }

  void _getAllHomeworks() async {
    _homeworks = await _dbHelper.getHomeworks();
    notifyListeners();
  }

  Future<void> addHomework(Homework homework) async {
    await _dbHelper.insertHomework(homework);
    _getAllHomeworks();
  }

  Future<void> removeHomework(int? id) async {
    await _dbHelper.deleteHomework(id);
    _getAllHomeworks();
  }

  Future<void> editHomework(Homework homework) async {
    await _dbHelper.updateHomework(homework);
    _getAllHomeworks();
  }
}
