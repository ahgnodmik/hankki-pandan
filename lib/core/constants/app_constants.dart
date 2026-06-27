class AppConstants {
  static const String mealsCollection = 'meals';

  static const List<String> mealTypes = ['아침', '점심', '저녁', '간식'];

  // Meta semantic colors: success / attention / critical
  static const Map<String, int> judgeColor = {
    'good':    0xFF31A24C, // success green
    'caution': 0xFFF2A918, // attention amber
    'adjust':  0xFFE41E3F, // critical red
  };
}
