import 'package:flutter/foundation.dart';

class AdHelper {
  static const String appId = 'ca-app-pub-8527804772343765~5773999601';

  // 실제 광고는 Play Store 등록 후 활성화됨. 그 전까지는 구글 테스트 ID 사용
  static String get bannerId => kReleaseMode
      ? 'ca-app-pub-8527804772343765/1573267232'
      : 'ca-app-pub-3940256099942544/6300978111';
}
