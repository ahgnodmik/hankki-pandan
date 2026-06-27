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

// ── Save meal ─────────────────────────────────────────────────────────────────

class SaveMealNotifier extends StateNotifier<AsyncValue<void>> {
  final MealRepository _repo;

  SaveMealNotifier(this._repo) : super(const AsyncValue.data(null));

  Future<bool> save(MealRecord record) async {
    state = const AsyncValue.loading();
    final result = await AsyncValue.guard(() => _repo.save(record));
    state = result;
    return result is AsyncData;
  }
}

final saveMealProvider =
    StateNotifierProvider<SaveMealNotifier, AsyncValue<void>>(
  (ref) => SaveMealNotifier(ref.watch(mealRepositoryProvider)),
);

// ── Selected date (for history) ───────────────────────────────────────────────

final selectedDateProvider = StateProvider<DateTime>(
  (_) => DateTime.now(),
);

final selectedDateMealsProvider = StreamProvider<List<MealRecord>>((ref) {
  final date = ref.watch(selectedDateProvider);
  final repo = ref.watch(mealRepositoryProvider);
  return repo.watchByDate(date);
});
