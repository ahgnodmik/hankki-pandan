import 'dart:async';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/meal_record.dart';

class MealRepository {
  final SharedPreferences _prefs;
  static const _key = 'meals_v1';

  final _controller = StreamController<List<MealRecord>>.broadcast();

  MealRepository(this._prefs);

  List<MealRecord> _loadAll() {
    final jsonStr = _prefs.getString(_key);
    if (jsonStr == null) return [];
    final list = jsonDecode(jsonStr) as List;
    return list
        .map((e) => MealRecord.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<void> _saveAll(List<MealRecord> records) async {
    await _prefs.setString(
        _key, jsonEncode(records.map((r) => r.toJson()).toList()));
    _controller.add(records);
  }

  Future<void> save(MealRecord record) async {
    final all = _loadAll();
    all.removeWhere((r) => r.id == record.id);
    all.add(record);
    all.sort((a, b) => a.recordedAt.compareTo(b.recordedAt));
    await _saveAll(all);
  }

  Future<void> delete(String id) async {
    final all = _loadAll()..removeWhere((r) => r.id == id);
    await _saveAll(all);
  }

  Stream<List<MealRecord>> watchByDate(DateTime date) async* {
    final start = DateTime(date.year, date.month, date.day);
    final end = start.add(const Duration(days: 1));

    bool inRange(MealRecord r) =>
        !r.recordedAt.isBefore(start) && r.recordedAt.isBefore(end);

    yield _loadAll().where(inRange).toList();

    await for (final all in _controller.stream) {
      yield all.where(inRange).toList();
    }
  }
}
