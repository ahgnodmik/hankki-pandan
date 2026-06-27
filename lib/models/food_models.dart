class FoodResult {
  final String name;
  final double kcalPer100g;
  final double proteinPer100g;
  final double carbsPer100g;
  final double fatPer100g;
  final int defaultServingG;

  const FoodResult({
    required this.name,
    required this.kcalPer100g,
    required this.proteinPer100g,
    required this.carbsPer100g,
    required this.fatPer100g,
    required this.defaultServingG,
  });
}

class SelectedFood {
  final FoodResult source;
  final double servingG;

  const SelectedFood({required this.source, required this.servingG});

  int get totalKcal => (source.kcalPer100g * servingG / 100).round();
  double get totalProtein => source.proteinPer100g * servingG / 100;
  double get totalCarbs => source.carbsPer100g * servingG / 100;
  double get totalFat => source.fatPer100g * servingG / 100;

  SelectedFood withServing(double g) => SelectedFood(source: source, servingG: g);
}
