import 'package:hankki_pandan/l10n/app_localizations.dart';

class NutritionJudge {
  // ── 내부 수준 분류 (한국어 키 - 저장·비교용) ───────────────────────────────
  static String proteinLevel(double g) {
    if (g >= 25) return '높음';
    if (g >= 10) return '보통';
    return '낮음';
  }

  static String carbsLevel(double g) {
    if (g >= 80) return '높음';
    if (g >= 30) return '보통';
    return '낮음';
  }

  static String fatLevel(double g) {
    if (g >= 20) return '높음';
    if (g >= 8) return '보통';
    return '낮음';
  }

  static String judge({
    required int totalKcal,
    required String protein,
    required String carbs,
    required String fat,
  }) {
    if (totalKcal > 1000) return 'adjust';
    if (fat == '높음' && protein == '낮음') return 'adjust';
    if (totalKcal > 700 || fat == '높음' || totalKcal < 150) return 'caution';
    return 'good';
  }

  // ── 표시용 현지화 ─────────────────────────────────────────────────────────

  static String localizeLevel(String level, AppLocalizations l10n) {
    switch (level) {
      case '높음': return l10n.levelHigh;
      case '보통': return l10n.levelMid;
      default:    return l10n.levelLow;
    }
  }

  static String localizeJudge(String judge, AppLocalizations l10n) {
    switch (judge) {
      case 'good':    return l10n.judgeGood;
      case 'caution': return l10n.judgeCaution;
      default:        return l10n.judgeAdjust;
    }
  }

  static String localizeMealType(String mealType, AppLocalizations l10n) {
    switch (mealType) {
      case '아침': return l10n.mealBreakfast;
      case '점심': return l10n.mealLunch;
      case '저녁': return l10n.mealDinner;
      default:    return l10n.mealSnack;
    }
  }

  static String judgeReason({
    required AppLocalizations l10n,
    required String judge,
    required int totalKcal,
    required String protein,
    required String carbs,
    required String fat,
  }) {
    if (judge == 'adjust') {
      if (totalKcal > 1000) return l10n.judgeReasonAdjustHighCal(totalKcal);
      return l10n.judgeReasonAdjustImbalance;
    }
    if (judge == 'caution') {
      if (totalKcal < 150) return l10n.judgeReasonCautionLowCal(totalKcal);
      if (fat == '높음')   return l10n.judgeReasonCautionHighFat;
      return l10n.judgeReasonCautionHighCal(totalKcal);
    }
    return l10n.judgeReasonGood(totalKcal);
  }

  static String nextMealAdvice({
    required AppLocalizations l10n,
    required String judge,
    required String protein,
    required String carbs,
    required String fat,
  }) {
    if (judge == 'adjust')              return l10n.adviceAdjust;
    if (protein == '낮음')              return l10n.adviceLowProtein;
    if (fat == '높음')                  return l10n.adviceHighFat;
    if (carbs == '높음')                return l10n.adviceHighCarbs;
    if (carbs == '낮음' && protein == '낮음') return l10n.adviceLowAll;
    return l10n.adviceGood;
  }
}
