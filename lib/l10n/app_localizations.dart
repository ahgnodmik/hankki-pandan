import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_ja.dart';
import 'app_localizations_ko.dart';
import 'app_localizations_zh.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('ja'),
    Locale('ko'),
    Locale('zh'),
  ];

  /// No description provided for @appName.
  ///
  /// In ko, this message translates to:
  /// **'한끼한판'**
  String get appName;

  /// No description provided for @navToday.
  ///
  /// In ko, this message translates to:
  /// **'오늘'**
  String get navToday;

  /// No description provided for @navHistory.
  ///
  /// In ko, this message translates to:
  /// **'기록'**
  String get navHistory;

  /// No description provided for @homeTitle.
  ///
  /// In ko, this message translates to:
  /// **'한끼한판'**
  String get homeTitle;

  /// No description provided for @homeEmptyMessage.
  ///
  /// In ko, this message translates to:
  /// **'아직 기록된 식사가 없습니다.'**
  String get homeEmptyMessage;

  /// No description provided for @homeEmptyHint.
  ///
  /// In ko, this message translates to:
  /// **'음식을 검색해 첫 식단을 점검해보세요.'**
  String get homeEmptyHint;

  /// No description provided for @homeSearchButton.
  ///
  /// In ko, this message translates to:
  /// **'음식 검색하기'**
  String get homeSearchButton;

  /// No description provided for @homeTodayTotal.
  ///
  /// In ko, this message translates to:
  /// **'오늘 총합'**
  String get homeTodayTotal;

  /// No description provided for @homeNoRecord.
  ///
  /// In ko, this message translates to:
  /// **'기록 없음'**
  String get homeNoRecord;

  /// No description provided for @homeFabLabel.
  ///
  /// In ko, this message translates to:
  /// **'촬영하기'**
  String get homeFabLabel;

  /// No description provided for @calRange.
  ///
  /// In ko, this message translates to:
  /// **'약 {min}~{max} kcal'**
  String calRange(int min, int max);

  /// No description provided for @mealBreakfast.
  ///
  /// In ko, this message translates to:
  /// **'아침'**
  String get mealBreakfast;

  /// No description provided for @mealLunch.
  ///
  /// In ko, this message translates to:
  /// **'점심'**
  String get mealLunch;

  /// No description provided for @mealDinner.
  ///
  /// In ko, this message translates to:
  /// **'저녁'**
  String get mealDinner;

  /// No description provided for @mealSnack.
  ///
  /// In ko, this message translates to:
  /// **'간식'**
  String get mealSnack;

  /// No description provided for @macroProtein.
  ///
  /// In ko, this message translates to:
  /// **'단백질'**
  String get macroProtein;

  /// No description provided for @macroCarbs.
  ///
  /// In ko, this message translates to:
  /// **'탄수화물'**
  String get macroCarbs;

  /// No description provided for @macroFat.
  ///
  /// In ko, this message translates to:
  /// **'지방'**
  String get macroFat;

  /// No description provided for @levelHigh.
  ///
  /// In ko, this message translates to:
  /// **'높음'**
  String get levelHigh;

  /// No description provided for @levelMid.
  ///
  /// In ko, this message translates to:
  /// **'보통'**
  String get levelMid;

  /// No description provided for @levelLow.
  ///
  /// In ko, this message translates to:
  /// **'낮음'**
  String get levelLow;

  /// No description provided for @judgeGood.
  ///
  /// In ko, this message translates to:
  /// **'좋음'**
  String get judgeGood;

  /// No description provided for @judgeCaution.
  ///
  /// In ko, this message translates to:
  /// **'주의'**
  String get judgeCaution;

  /// No description provided for @judgeAdjust.
  ///
  /// In ko, this message translates to:
  /// **'조정 필요'**
  String get judgeAdjust;

  /// No description provided for @captureTitle.
  ///
  /// In ko, this message translates to:
  /// **'음식 검색'**
  String get captureTitle;

  /// No description provided for @captureSearchHint.
  ///
  /// In ko, this message translates to:
  /// **'음식명을 검색하세요 (예: 김치찌개)'**
  String get captureSearchHint;

  /// No description provided for @captureSelectedLabel.
  ///
  /// In ko, this message translates to:
  /// **'선택된 음식'**
  String get captureSelectedLabel;

  /// No description provided for @captureApiLabel.
  ///
  /// In ko, this message translates to:
  /// **'공공DB'**
  String get captureApiLabel;

  /// No description provided for @captureEmptyTitle.
  ///
  /// In ko, this message translates to:
  /// **'음식명을 입력하면 검색합니다'**
  String get captureEmptyTitle;

  /// No description provided for @captureEmptySubtitle.
  ///
  /// In ko, this message translates to:
  /// **'로컬 DB → 공공 DB 순으로 검색합니다'**
  String get captureEmptySubtitle;

  /// No description provided for @captureNoResult.
  ///
  /// In ko, this message translates to:
  /// **'\"{query}\" 검색 결과가 없습니다.'**
  String captureNoResult(String query);

  /// No description provided for @captureNoResultHint.
  ///
  /// In ko, this message translates to:
  /// **'다른 이름으로 검색해보세요'**
  String get captureNoResultHint;

  /// No description provided for @captureApiLoading.
  ///
  /// In ko, this message translates to:
  /// **'공공 DB 검색 중...'**
  String get captureApiLoading;

  /// No description provided for @captureKcalPer100g.
  ///
  /// In ko, this message translates to:
  /// **'{kcal}kcal / 100g'**
  String captureKcalPer100g(int kcal);

  /// No description provided for @captureDefaultServing.
  ///
  /// In ko, this message translates to:
  /// **'기본 {g}g'**
  String captureDefaultServing(int g);

  /// No description provided for @captureAnalyzeButton.
  ///
  /// In ko, this message translates to:
  /// **'분석하기 ({count}개)'**
  String captureAnalyzeButton(int count);

  /// No description provided for @captureSelectAtLeastOne.
  ///
  /// In ko, this message translates to:
  /// **'음식을 하나 이상 선택해주세요.'**
  String get captureSelectAtLeastOne;

  /// No description provided for @analysisTitle.
  ///
  /// In ko, this message translates to:
  /// **'식단 분석'**
  String get analysisTitle;

  /// No description provided for @analysisFoodList.
  ///
  /// In ko, this message translates to:
  /// **'음식 목록'**
  String get analysisFoodList;

  /// No description provided for @analysisTotal.
  ///
  /// In ko, this message translates to:
  /// **'합계'**
  String get analysisTotal;

  /// No description provided for @analysisNutrition.
  ///
  /// In ko, this message translates to:
  /// **'영양 균형'**
  String get analysisNutrition;

  /// No description provided for @analysisNextAdviceTitle.
  ///
  /// In ko, this message translates to:
  /// **'다음 식사 조언'**
  String get analysisNextAdviceTitle;

  /// No description provided for @analysisMealTypeLabel.
  ///
  /// In ko, this message translates to:
  /// **'식사 종류'**
  String get analysisMealTypeLabel;

  /// No description provided for @analysisSaveButton.
  ///
  /// In ko, this message translates to:
  /// **'식단 저장하기'**
  String get analysisSaveButton;

  /// No description provided for @analysisSaveSuccess.
  ///
  /// In ko, this message translates to:
  /// **'식단이 저장되었습니다.'**
  String get analysisSaveSuccess;

  /// No description provided for @analysisSaveFail.
  ///
  /// In ko, this message translates to:
  /// **'저장 실패. 다시 시도해주세요.'**
  String get analysisSaveFail;

  /// No description provided for @analysisKcal.
  ///
  /// In ko, this message translates to:
  /// **'{kcal}kcal'**
  String analysisKcal(int kcal);

  /// No description provided for @analysisTotalKcal.
  ///
  /// In ko, this message translates to:
  /// **'{kcal} kcal'**
  String analysisTotalKcal(int kcal);

  /// No description provided for @historyTitle.
  ///
  /// In ko, this message translates to:
  /// **'식단 기록'**
  String get historyTitle;

  /// No description provided for @historyDailyTotal.
  ///
  /// In ko, this message translates to:
  /// **'하루 총 칼로리'**
  String get historyDailyTotal;

  /// No description provided for @historyEmpty.
  ///
  /// In ko, this message translates to:
  /// **'이 날짜에 기록된 식단이 없습니다.'**
  String get historyEmpty;

  /// No description provided for @judgeReasonGood.
  ///
  /// In ko, this message translates to:
  /// **'영양 균형이 적절하고 칼로리({totalKcal}kcal)가 적당합니다.'**
  String judgeReasonGood(int totalKcal);

  /// No description provided for @judgeReasonCautionHighCal.
  ///
  /// In ko, this message translates to:
  /// **'{totalKcal}kcal로 칼로리가 다소 높습니다. 식사량 조절을 권장합니다.'**
  String judgeReasonCautionHighCal(int totalKcal);

  /// No description provided for @judgeReasonCautionHighFat.
  ///
  /// In ko, this message translates to:
  /// **'지방 섭취(높음)가 많습니다. 기름진 음식을 줄여보세요.'**
  String get judgeReasonCautionHighFat;

  /// No description provided for @judgeReasonCautionLowCal.
  ///
  /// In ko, this message translates to:
  /// **'칼로리({totalKcal}kcal)가 너무 낮습니다. 충분한 영양 섭취가 필요합니다.'**
  String judgeReasonCautionLowCal(int totalKcal);

  /// No description provided for @judgeReasonAdjustHighCal.
  ///
  /// In ko, this message translates to:
  /// **'칼로리가 {totalKcal}kcal로 1회 식사 권장량을 크게 초과합니다.'**
  String judgeReasonAdjustHighCal(int totalKcal);

  /// No description provided for @judgeReasonAdjustImbalance.
  ///
  /// In ko, this message translates to:
  /// **'지방 섭취가 높고 단백질이 부족해 영양 균형이 맞지 않습니다.'**
  String get judgeReasonAdjustImbalance;

  /// No description provided for @adviceAdjust.
  ///
  /// In ko, this message translates to:
  /// **'다음 식사는 채소·두부 위주의 가볍고 담백한 식사를 권장합니다. 수분도 충분히 섭취하세요.'**
  String get adviceAdjust;

  /// No description provided for @adviceLowProtein.
  ///
  /// In ko, this message translates to:
  /// **'단백질이 부족합니다. 다음 식사에 달걀·닭가슴살·두부 등을 추가해보세요.'**
  String get adviceLowProtein;

  /// No description provided for @adviceHighFat.
  ///
  /// In ko, this message translates to:
  /// **'채소 반찬과 나물 위주로 가볍게 드시고, 기름진 음식은 피해주세요.'**
  String get adviceHighFat;

  /// No description provided for @adviceHighCarbs.
  ///
  /// In ko, this message translates to:
  /// **'탄수화물 섭취가 많았습니다. 다음 식사는 단백질과 채소 위주로 구성해보세요.'**
  String get adviceHighCarbs;

  /// No description provided for @adviceLowAll.
  ///
  /// In ko, this message translates to:
  /// **'전체적으로 섭취량이 적습니다. 다음 식사에서 균형 잡힌 식단을 충분히 드세요.'**
  String get adviceLowAll;

  /// No description provided for @adviceGood.
  ///
  /// In ko, this message translates to:
  /// **'현재 식사 패턴을 유지하세요. 간식은 과일·견과류·요구르트 등으로 가볍게 드세요.'**
  String get adviceGood;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'ja', 'ko', 'zh'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'ja':
      return AppLocalizationsJa();
    case 'ko':
      return AppLocalizationsKo();
    case 'zh':
      return AppLocalizationsZh();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
