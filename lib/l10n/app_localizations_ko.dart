// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Korean (`ko`).
class AppLocalizationsKo extends AppLocalizations {
  AppLocalizationsKo([String locale = 'ko']) : super(locale);

  @override
  String get appName => '한끼한판';

  @override
  String get navToday => '오늘';

  @override
  String get navHistory => '기록';

  @override
  String get homeTitle => '한끼한판';

  @override
  String get homeEmptyMessage => '아직 기록된 식사가 없습니다.';

  @override
  String get homeEmptyHint => '음식을 검색해 첫 식단을 점검해보세요.';

  @override
  String get homeSearchButton => '음식 검색하기';

  @override
  String get homeTodayTotal => '오늘 총합';

  @override
  String get homeNoRecord => '기록 없음';

  @override
  String get homeFabLabel => '촬영하기';

  @override
  String calRange(int min, int max) {
    return '약 $min~$max kcal';
  }

  @override
  String get mealBreakfast => '아침';

  @override
  String get mealLunch => '점심';

  @override
  String get mealDinner => '저녁';

  @override
  String get mealSnack => '간식';

  @override
  String get macroProtein => '단백질';

  @override
  String get macroCarbs => '탄수화물';

  @override
  String get macroFat => '지방';

  @override
  String get levelHigh => '높음';

  @override
  String get levelMid => '보통';

  @override
  String get levelLow => '낮음';

  @override
  String get judgeGood => '좋음';

  @override
  String get judgeCaution => '주의';

  @override
  String get judgeAdjust => '조정 필요';

  @override
  String get captureTitle => '음식 검색';

  @override
  String get captureSearchHint => '음식명을 검색하세요 (예: 김치찌개)';

  @override
  String get captureSelectedLabel => '선택된 음식';

  @override
  String get captureApiLabel => '공공DB';

  @override
  String get captureEmptyTitle => '음식명을 입력하면 검색합니다';

  @override
  String get captureEmptySubtitle => '로컬 DB → 공공 DB 순으로 검색합니다';

  @override
  String captureNoResult(String query) {
    return '\"$query\" 검색 결과가 없습니다.';
  }

  @override
  String get captureNoResultHint => '다른 이름으로 검색해보세요';

  @override
  String get captureApiLoading => '공공 DB 검색 중...';

  @override
  String captureKcalPer100g(int kcal) {
    return '${kcal}kcal / 100g';
  }

  @override
  String captureDefaultServing(int g) {
    return '기본 ${g}g';
  }

  @override
  String captureAnalyzeButton(int count) {
    return '분석하기 ($count개)';
  }

  @override
  String get captureSelectAtLeastOne => '음식을 하나 이상 선택해주세요.';

  @override
  String get analysisTitle => '식단 분석';

  @override
  String get analysisFoodList => '음식 목록';

  @override
  String get analysisTotal => '합계';

  @override
  String get analysisNutrition => '영양 균형';

  @override
  String get analysisNextAdviceTitle => '다음 식사 조언';

  @override
  String get analysisMealTypeLabel => '식사 종류';

  @override
  String get analysisSaveButton => '식단 저장하기';

  @override
  String get analysisSaveSuccess => '식단이 저장되었습니다.';

  @override
  String get analysisSaveFail => '저장 실패. 다시 시도해주세요.';

  @override
  String analysisKcal(int kcal) {
    return '${kcal}kcal';
  }

  @override
  String analysisTotalKcal(int kcal) {
    return '$kcal kcal';
  }

  @override
  String get historyTitle => '식단 기록';

  @override
  String get historyDailyTotal => '하루 총 칼로리';

  @override
  String get historyEmpty => '이 날짜에 기록된 식단이 없습니다.';

  @override
  String judgeReasonGood(int totalKcal) {
    return '영양 균형이 적절하고 칼로리(${totalKcal}kcal)가 적당합니다.';
  }

  @override
  String judgeReasonCautionHighCal(int totalKcal) {
    return '${totalKcal}kcal로 칼로리가 다소 높습니다. 식사량 조절을 권장합니다.';
  }

  @override
  String get judgeReasonCautionHighFat => '지방 섭취(높음)가 많습니다. 기름진 음식을 줄여보세요.';

  @override
  String judgeReasonCautionLowCal(int totalKcal) {
    return '칼로리(${totalKcal}kcal)가 너무 낮습니다. 충분한 영양 섭취가 필요합니다.';
  }

  @override
  String judgeReasonAdjustHighCal(int totalKcal) {
    return '칼로리가 ${totalKcal}kcal로 1회 식사 권장량을 크게 초과합니다.';
  }

  @override
  String get judgeReasonAdjustImbalance => '지방 섭취가 높고 단백질이 부족해 영양 균형이 맞지 않습니다.';

  @override
  String get adviceAdjust =>
      '다음 식사는 채소·두부 위주의 가볍고 담백한 식사를 권장합니다. 수분도 충분히 섭취하세요.';

  @override
  String get adviceLowProtein => '단백질이 부족합니다. 다음 식사에 달걀·닭가슴살·두부 등을 추가해보세요.';

  @override
  String get adviceHighFat => '채소 반찬과 나물 위주로 가볍게 드시고, 기름진 음식은 피해주세요.';

  @override
  String get adviceHighCarbs => '탄수화물 섭취가 많았습니다. 다음 식사는 단백질과 채소 위주로 구성해보세요.';

  @override
  String get adviceLowAll => '전체적으로 섭취량이 적습니다. 다음 식사에서 균형 잡힌 식단을 충분히 드세요.';

  @override
  String get adviceGood => '현재 식사 패턴을 유지하세요. 간식은 과일·견과류·요구르트 등으로 가볍게 드세요.';
}
