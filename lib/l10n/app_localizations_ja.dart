// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Japanese (`ja`).
class AppLocalizationsJa extends AppLocalizations {
  AppLocalizationsJa([String locale = 'ja']) : super(locale);

  @override
  String get appName => '一食判断';

  @override
  String get navToday => '今日';

  @override
  String get navHistory => '記録';

  @override
  String get homeTitle => '一食判断';

  @override
  String get homeEmptyMessage => 'まだ食事の記録がありません。';

  @override
  String get homeEmptyHint => '食べ物を検索して最初の食事を記録しましょう。';

  @override
  String get homeSearchButton => '食べ物を検索';

  @override
  String get homeTodayTotal => '今日の合計';

  @override
  String get homeNoRecord => '記録なし';

  @override
  String get homeFabLabel => '撮影する';

  @override
  String calRange(int min, int max) {
    return '約 $min~$max kcal';
  }

  @override
  String get mealBreakfast => '朝食';

  @override
  String get mealLunch => '昼食';

  @override
  String get mealDinner => '夕食';

  @override
  String get mealSnack => 'おやつ';

  @override
  String get macroProtein => 'タンパク質';

  @override
  String get macroCarbs => '炭水化物';

  @override
  String get macroFat => '脂質';

  @override
  String get levelHigh => '高い';

  @override
  String get levelMid => '普通';

  @override
  String get levelLow => '低い';

  @override
  String get judgeGood => '良好';

  @override
  String get judgeCaution => '注意';

  @override
  String get judgeAdjust => '要改善';

  @override
  String get captureTitle => '食べ物検索';

  @override
  String get captureSearchHint => '食べ物の名前を検索（例：キムチ鍋）';

  @override
  String get captureSelectedLabel => '選択済み';

  @override
  String get captureApiLabel => '公共DB';

  @override
  String get captureEmptyTitle => '食べ物の名前を入力して検索';

  @override
  String get captureEmptySubtitle => 'ローカルDB → 公共DBの順で検索します';

  @override
  String captureNoResult(String query) {
    return '「$query」の検索結果がありません。';
  }

  @override
  String get captureNoResultHint => '別の名前で検索してみてください';

  @override
  String get captureApiLoading => '公共DBを検索中...';

  @override
  String captureKcalPer100g(int kcal) {
    return '${kcal}kcal / 100g';
  }

  @override
  String captureDefaultServing(int g) {
    return 'デフォルト ${g}g';
  }

  @override
  String captureAnalyzeButton(int count) {
    return '分析する（$count個）';
  }

  @override
  String get captureSelectAtLeastOne => '食べ物を1つ以上選択してください。';

  @override
  String get analysisTitle => '食事分析';

  @override
  String get analysisFoodList => '食べ物リスト';

  @override
  String get analysisTotal => '合計';

  @override
  String get analysisNutrition => '栄養バランス';

  @override
  String get analysisNextAdviceTitle => '次の食事へのアドバイス';

  @override
  String get analysisMealTypeLabel => '食事の種類';

  @override
  String get analysisSaveButton => '食事を保存';

  @override
  String get analysisSaveSuccess => '食事を保存しました。';

  @override
  String get analysisSaveFail => '保存に失敗しました。もう一度お試しください。';

  @override
  String analysisKcal(int kcal) {
    return '${kcal}kcal';
  }

  @override
  String analysisTotalKcal(int kcal) {
    return '$kcal kcal';
  }

  @override
  String get historyTitle => '食事記録';

  @override
  String get historyDailyTotal => '1日の合計カロリー';

  @override
  String get historyEmpty => 'この日の食事記録はありません。';

  @override
  String judgeReasonGood(int totalKcal) {
    return '栄養バランスが良く、カロリー（${totalKcal}kcal）も適切です。';
  }

  @override
  String judgeReasonCautionHighCal(int totalKcal) {
    return 'カロリー（${totalKcal}kcal）がやや高めです。食事量を調整してください。';
  }

  @override
  String get judgeReasonCautionHighFat => '脂質の摂取量が多いです。油っこい食べ物を減らしましょう。';

  @override
  String judgeReasonCautionLowCal(int totalKcal) {
    return 'カロリー（${totalKcal}kcal）が低すぎます。十分な栄養を摂取してください。';
  }

  @override
  String judgeReasonAdjustHighCal(int totalKcal) {
    return 'カロリー（${totalKcal}kcal）が1回の食事の推奨量を大幅に超えています。';
  }

  @override
  String get judgeReasonAdjustImbalance => '脂質が多くタンパク質が不足しており、栄養バランスが崩れています。';

  @override
  String get adviceAdjust => '次の食事は野菜・豆腐中心の軽い食事がおすすめです。水分も十分に摂ってください。';

  @override
  String get adviceLowProtein => 'タンパク質が不足しています。次の食事に卵・鶏むね肉・豆腐などを加えましょう。';

  @override
  String get adviceHighFat => '野菜中心の副菜を選び、油っこい食べ物は避けましょう。';

  @override
  String get adviceHighCarbs => '炭水化物が多かったです。次の食事はタンパク質と野菜中心にしましょう。';

  @override
  String get adviceLowAll => '全体的に摂取量が少ないです。次の食事では十分にバランスよく食べましょう。';

  @override
  String get adviceGood => '良い食事パターンを続けてください。おやつは果物・ナッツ・ヨーグルトなどにしましょう。';
}
