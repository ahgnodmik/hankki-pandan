import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/meal_record.dart';
import '../repositories/meal_repository.dart';
import '../services/food_search_service.dart';

// ── Infrastructure ──────────────────────────────────────────────────────────

final sharedPrefsProvider = Provider<SharedPreferences>(
  (_) => throw UnimplementedError('override in main'),
);

final mealRepositoryProvider = Provider<MealRepository>(
  (ref) => MealRepository(ref.watch(sharedPrefsProvider)),
);

final foodSearchServiceProvider = Provider<FoodSearchService>(
  (_) => FoodSearchService(),
);

// ── Today's meals ────────────────────────────────────────────────────────────

final todayMealsProvider = StreamProvider<List<MealRecord>>((ref) {
  final repo = ref.watch(mealRepositoryProvider);
  return repo.watchByDate(DateTime.now());
});

// ── Delete meal ───────────────────────────────────────────────────────────────

class DeleteMealNotifier extends AsyncNotifier<void> {
  @override
  Future<void> build() async {}

  Future<bool> delete(String id) async {
    state = const AsyncLoading();
    final result = await AsyncValue.guard(
      () => ref.read(mealRepositoryProvider).delete(id),
    );
    state = result;
    return result is AsyncData;
  }
}

final deleteMealProvider =
    AsyncNotifierProvider<DeleteMealNotifier, void>(DeleteMealNotifier.new);

// ── Save meal ─────────────────────────────────────────────────────────────────

class SaveMealNotifier extends AsyncNotifier<void> {
  @override
  Future<void> build() async {}

  Future<bool> save(MealRecord record) async {
    state = const AsyncLoading();
    final result = await AsyncValue.guard(
      () => ref.read(mealRepositoryProvider).save(record),
    );
    state = result;
    return result is AsyncData;
  }
}

final saveMealProvider =
    AsyncNotifierProvider<SaveMealNotifier, void>(SaveMealNotifier.new);

// ── Selected date (for history) ───────────────────────────────────────────────

class SelectedDateNotifier extends Notifier<DateTime> {
  @override
  DateTime build() => DateTime.now();

  void select(DateTime date) => state = date;
}

final selectedDateProvider =
    NotifierProvider<SelectedDateNotifier, DateTime>(SelectedDateNotifier.new);

final selectedDateMealsProvider = StreamProvider<List<MealRecord>>((ref) {
  final date = ref.watch(selectedDateProvider);
  final repo = ref.watch(mealRepositoryProvider);
  return repo.watchByDate(date);
});
