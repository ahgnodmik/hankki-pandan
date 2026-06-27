// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Chinese (`zh`).
class AppLocalizationsZh extends AppLocalizations {
  AppLocalizationsZh([String locale = 'zh']) : super(locale);

  @override
  String get appName => '一餐判断';

  @override
  String get navToday => '今日';

  @override
  String get navHistory => '记录';

  @override
  String get homeTitle => '一餐判断';

  @override
  String get homeEmptyMessage => '尚无饮食记录';

  @override
  String get homeEmptyHint => '搜索食物，记录您的第一餐';

  @override
  String get homeSearchButton => '搜索食物';

  @override
  String get homeTodayTotal => '今日合计';

  @override
  String get homeNoRecord => '无记录';

  @override
  String get homeFabLabel => '拍照';

  @override
  String calRange(int min, int max) {
    return '约 $min~$max 千卡';
  }

  @override
  String get mealBreakfast => '早餐';

  @override
  String get mealLunch => '午餐';

  @override
  String get mealDinner => '晚餐';

  @override
  String get mealSnack => '零食';

  @override
  String get macroProtein => '蛋白质';

  @override
  String get macroCarbs => '碳水';

  @override
  String get macroFat => '脂肪';

  @override
  String get levelHigh => '高';

  @override
  String get levelMid => '中';

  @override
  String get levelLow => '低';

  @override
  String get judgeGood => '良好';

  @override
  String get judgeCaution => '注意';

  @override
  String get judgeAdjust => '需调整';

  @override
  String get captureTitle => '搜索食物';

  @override
  String get captureSearchHint => '搜索食物名称（例：泡菜汤）';

  @override
  String get captureSelectedLabel => '已选食物';

  @override
  String get captureApiLabel => '公共DB';

  @override
  String get captureEmptyTitle => '输入食物名称进行搜索';

  @override
  String get captureEmptySubtitle => '先搜索本地数据库，再搜索公共食品数据库';

  @override
  String captureNoResult(String query) {
    return '未找到\"$query\"的结果';
  }

  @override
  String get captureNoResultHint => '请尝试其他名称';

  @override
  String get captureApiLoading => '正在搜索公共数据库...';

  @override
  String captureKcalPer100g(int kcal) {
    return '$kcal千卡 / 100g';
  }

  @override
  String captureDefaultServing(int g) {
    return '默认 ${g}g';
  }

  @override
  String captureAnalyzeButton(int count) {
    return '分析 ($count)';
  }

  @override
  String get captureSelectAtLeastOne => '请至少选择一种食物。';

  @override
  String get analysisTitle => '饮食分析';

  @override
  String get analysisFoodList => '食物列表';

  @override
  String get analysisTotal => '合计';

  @override
  String get analysisNutrition => '营养均衡';

  @override
  String get analysisNextAdviceTitle => '下餐建议';

  @override
  String get analysisMealTypeLabel => '餐次';

  @override
  String get analysisSaveButton => '保存记录';

  @override
  String get analysisSaveSuccess => '饮食已保存。';

  @override
  String get analysisSaveFail => '保存失败，请重试。';

  @override
  String analysisKcal(int kcal) {
    return '$kcal千卡';
  }

  @override
  String analysisTotalKcal(int kcal) {
    return '$kcal 千卡';
  }

  @override
  String get historyTitle => '饮食记录';

  @override
  String get historyDailyTotal => '日摄入量';

  @override
  String get historyEmpty => '该日期没有饮食记录。';

  @override
  String judgeReasonGood(int totalKcal) {
    return '营养均衡，热量（$totalKcal千卡）适中。';
  }

  @override
  String judgeReasonCautionHighCal(int totalKcal) {
    return '热量（$totalKcal千卡）偏高，建议控制饮食量。';
  }

  @override
  String get judgeReasonCautionHighFat => '脂肪摄入量较高，请减少油腻食物。';

  @override
  String judgeReasonCautionLowCal(int totalKcal) {
    return '热量（$totalKcal千卡）过低，需要摄入足够的营养。';
  }

  @override
  String judgeReasonAdjustHighCal(int totalKcal) {
    return '热量（$totalKcal千卡）远超单餐推荐量。';
  }

  @override
  String get judgeReasonAdjustImbalance => '脂肪过高且蛋白质不足，营养不均衡。';

  @override
  String get adviceAdjust => '下一餐建议以蔬菜、豆腐为主，清淡饮食，并补充足够水分。';

  @override
  String get adviceLowProtein => '蛋白质不足，下一餐可以添加鸡蛋、鸡胸肉或豆腐。';

  @override
  String get adviceHighFat => '下一餐以蔬菜为主，避免油腻食物。';

  @override
  String get adviceHighCarbs => '本餐碳水化合物摄入较多，下一餐请以蛋白质和蔬菜为主。';

  @override
  String get adviceLowAll => '整体摄入量偏低，下一餐请保证均衡且充足的饮食。';

  @override
  String get adviceGood => '保持良好的饮食习惯，零食可选择水果、坚果或酸奶。';
}
