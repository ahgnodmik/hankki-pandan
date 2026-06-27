// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appName => 'Meal Check';

  @override
  String get navToday => 'Today';

  @override
  String get navHistory => 'History';

  @override
  String get homeTitle => 'Meal Check';

  @override
  String get homeEmptyMessage => 'No meals recorded yet.';

  @override
  String get homeEmptyHint => 'Search for food to log your first meal.';

  @override
  String get homeSearchButton => 'Search Food';

  @override
  String get homeTodayTotal => 'Today\'s Total';

  @override
  String get homeNoRecord => 'No record';

  @override
  String get homeFabLabel => 'Take Photo';

  @override
  String calRange(int min, int max) {
    return 'approx. $min~$max kcal';
  }

  @override
  String get mealBreakfast => 'Breakfast';

  @override
  String get mealLunch => 'Lunch';

  @override
  String get mealDinner => 'Dinner';

  @override
  String get mealSnack => 'Snack';

  @override
  String get macroProtein => 'Protein';

  @override
  String get macroCarbs => 'Carbs';

  @override
  String get macroFat => 'Fat';

  @override
  String get levelHigh => 'High';

  @override
  String get levelMid => 'Mid';

  @override
  String get levelLow => 'Low';

  @override
  String get judgeGood => 'Good';

  @override
  String get judgeCaution => 'Caution';

  @override
  String get judgeAdjust => 'Needs Adjustment';

  @override
  String get captureTitle => 'Search Food';

  @override
  String get captureSearchHint => 'Search food name (e.g. Kimchi stew)';

  @override
  String get captureSelectedLabel => 'Selected';

  @override
  String get captureApiLabel => 'Public DB';

  @override
  String get captureEmptyTitle => 'Enter a food name to search';

  @override
  String get captureEmptySubtitle =>
      'Searches local DB first, then public food database';

  @override
  String captureNoResult(String query) {
    return 'No results for \"$query\".';
  }

  @override
  String get captureNoResultHint => 'Try a different name';

  @override
  String get captureApiLoading => 'Searching public DB...';

  @override
  String captureKcalPer100g(int kcal) {
    return '${kcal}kcal / 100g';
  }

  @override
  String captureDefaultServing(int g) {
    return 'default ${g}g';
  }

  @override
  String captureAnalyzeButton(int count) {
    return 'Analyze ($count)';
  }

  @override
  String get captureSelectAtLeastOne => 'Please select at least one food.';

  @override
  String get analysisTitle => 'Meal Analysis';

  @override
  String get analysisFoodList => 'Food List';

  @override
  String get analysisTotal => 'Total';

  @override
  String get analysisNutrition => 'Nutrition Balance';

  @override
  String get analysisNextAdviceTitle => 'Next Meal Advice';

  @override
  String get analysisMealTypeLabel => 'Meal Type';

  @override
  String get analysisSaveButton => 'Save Meal';

  @override
  String get analysisSaveSuccess => 'Meal saved.';

  @override
  String get analysisSaveFail => 'Save failed. Please try again.';

  @override
  String analysisKcal(int kcal) {
    return '${kcal}kcal';
  }

  @override
  String analysisTotalKcal(int kcal) {
    return '$kcal kcal';
  }

  @override
  String get historyTitle => 'History';

  @override
  String get historyDailyTotal => 'Daily Total';

  @override
  String get historyEmpty => 'No meals recorded for this date.';

  @override
  String judgeReasonGood(int totalKcal) {
    return 'Well-balanced meal with appropriate calories ($totalKcal kcal).';
  }

  @override
  String judgeReasonCautionHighCal(int totalKcal) {
    return 'Calorie count ($totalKcal kcal) is slightly high. Consider reducing portion size.';
  }

  @override
  String get judgeReasonCautionHighFat =>
      'Fat intake is high. Try to reduce greasy foods.';

  @override
  String judgeReasonCautionLowCal(int totalKcal) {
    return 'Calorie count ($totalKcal kcal) is too low. Make sure to get enough nutrition.';
  }

  @override
  String judgeReasonAdjustHighCal(int totalKcal) {
    return 'Calorie count ($totalKcal kcal) significantly exceeds the recommended amount for one meal.';
  }

  @override
  String get judgeReasonAdjustImbalance =>
      'High fat and low protein make this meal nutritionally unbalanced.';

  @override
  String get adviceAdjust =>
      'For your next meal, opt for light vegetable-based dishes like tofu soup. Stay hydrated.';

  @override
  String get adviceLowProtein =>
      'Protein is low. Add eggs, chicken breast, or tofu to your next meal.';

  @override
  String get adviceHighFat =>
      'Go for vegetable-based side dishes next time and avoid greasy foods.';

  @override
  String get adviceHighCarbs =>
      'Carbs were high this meal. Focus on protein and vegetables for your next meal.';

  @override
  String get adviceLowAll =>
      'Overall intake was low. Make sure to have a balanced and sufficient next meal.';

  @override
  String get adviceGood =>
      'Keep up the good eating pattern. Snack on fruits, nuts, or yogurt when needed.';
}
