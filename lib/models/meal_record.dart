class FoodItem {
  final String name;
  final int calorieMin;
  final int calorieMax;

  const FoodItem({
    required this.name,
    required this.calorieMin,
    required this.calorieMax,
  });

  factory FoodItem.fromJson(Map<String, dynamic> map) => FoodItem(
        name: map['name'] as String,
        calorieMin: map['calorie_min'] as int,
        calorieMax: map['calorie_max'] as int,
      );

  Map<String, dynamic> toJson() => {
        'name': name,
        'calorie_min': calorieMin,
        'calorie_max': calorieMax,
      };
}

class MealRecord {
  final String id;
  final String mealType;
  final List<FoodItem> foods;
  final int totalCalMin;
  final int totalCalMax;
  final String protein;
  final String carbs;
  final String fat;
  final String judge;
  final String judgeReason;
  final String nextMealAdvice;
  final String? imageUrl;
  final String? rawInput;
  final DateTime recordedAt;

  const MealRecord({
    required this.id,
    required this.mealType,
    required this.foods,
    required this.totalCalMin,
    required this.totalCalMax,
    required this.protein,
    required this.carbs,
    required this.fat,
    required this.judge,
    required this.judgeReason,
    required this.nextMealAdvice,
    this.imageUrl,
    this.rawInput,
    required this.recordedAt,
  });

  factory MealRecord.fromJson(Map<String, dynamic> d) => MealRecord(
        id: d['id'] as String,
        mealType: d['meal_type'] as String,
        foods: (d['foods'] as List)
            .map((e) => FoodItem.fromJson(e as Map<String, dynamic>))
            .toList(),
        totalCalMin: d['total_cal_min'] as int,
        totalCalMax: d['total_cal_max'] as int,
        protein: d['protein'] as String,
        carbs: d['carbs'] as String,
        fat: d['fat'] as String,
        judge: d['judge'] as String,
        judgeReason: d['judge_reason'] as String,
        nextMealAdvice: d['next_meal_advice'] as String,
        imageUrl: d['image_url'] as String?,
        rawInput: d['raw_input'] as String?,
        recordedAt: DateTime.parse(d['recorded_at'] as String),
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'meal_type': mealType,
        'foods': foods.map((f) => f.toJson()).toList(),
        'total_cal_min': totalCalMin,
        'total_cal_max': totalCalMax,
        'protein': protein,
        'carbs': carbs,
        'fat': fat,
        'judge': judge,
        'judge_reason': judgeReason,
        'next_meal_advice': nextMealAdvice,
        'image_url': imageUrl,
        'raw_input': rawInput,
        'recorded_at': recordedAt.toIso8601String(),
      };
}
