import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:uuid/uuid.dart';
import '../../core/constants/app_constants.dart';
import '../../core/extensions/context_ext.dart';
import '../../core/theme/app_theme.dart';
import '../../core/utils/nutrition_judge.dart';
import '../../models/food_models.dart';
import '../../models/meal_record.dart';
import '../../providers/providers.dart';

class AnalysisScreen extends ConsumerStatefulWidget {
  final List<SelectedFood> initialFoods;
  final String? initialMealType;
  const AnalysisScreen({super.key, required this.initialFoods, this.initialMealType});

  @override
  ConsumerState<AnalysisScreen> createState() => _AnalysisScreenState();
}

class _AnalysisScreenState extends ConsumerState<AnalysisScreen> {
  late List<_Entry> _entries;
  String _selectedMealType = '점심';

  @override
  void initState() {
    super.initState();
    _entries = widget.initialFoods
        .map((f) => _Entry(
              name: f.source.name,
              kcalPer100g: f.source.kcalPer100g,
              proteinPer100g: f.source.proteinPer100g,
              carbsPer100g: f.source.carbsPer100g,
              fatPer100g: f.source.fatPer100g,
              servingG: f.servingG,
            ))
        .toList();
    _selectedMealType = widget.initialMealType ?? _mealTypeByHour();
  }

  @override
  void dispose() {
    for (final e in _entries) {
      e.controller.dispose();
    }
    super.dispose();
  }

  String _mealTypeByHour() {
    final h = DateTime.now().hour;
    if (h < 10) return '아침';
    if (h < 15) return '점심';
    if (h < 20) return '저녁';
    return '간식';
  }

  int get _totalKcal => _entries.fold(0, (s, e) => s + e.kcal);
  double get _totalProtein => _entries.fold(0.0, (s, e) => s + e.protein);
  double get _totalCarbs => _entries.fold(0.0, (s, e) => s + e.carbs);
  double get _totalFat => _entries.fold(0.0, (s, e) => s + e.fat);

  String get _proteinLevel => NutritionJudge.proteinLevel(_totalProtein);
  String get _carbsLevel => NutritionJudge.carbsLevel(_totalCarbs);
  String get _fatLevel => NutritionJudge.fatLevel(_totalFat);
  String get _judge => NutritionJudge.judge(
        totalKcal: _totalKcal,
        protein: _proteinLevel,
        carbs: _carbsLevel,
        fat: _fatLevel,
      );

  Future<void> _save() async {
    final l10n = context.l10n;
    final judgeReason = NutritionJudge.judgeReason(
      l10n: l10n, judge: _judge, totalKcal: _totalKcal,
      protein: _proteinLevel, carbs: _carbsLevel, fat: _fatLevel,
    );
    final nextAdvice = NutritionJudge.nextMealAdvice(
      l10n: l10n, judge: _judge,
      protein: _proteinLevel, carbs: _carbsLevel, fat: _fatLevel,
    );

    final record = MealRecord(
      id: const Uuid().v4(),
      mealType: _selectedMealType,
      foods: _entries
          .map((e) =>
              FoodItem(name: e.name, calorieMin: e.kcal, calorieMax: e.kcal))
          .toList(),
      totalCalMin: _totalKcal,
      totalCalMax: _totalKcal,
      protein: _proteinLevel,
      carbs: _carbsLevel,
      fat: _fatLevel,
      judge: _judge,
      judgeReason: judgeReason,
      nextMealAdvice: nextAdvice,
      recordedAt: DateTime.now(),
    );

    final saved = await ref.read(saveMealProvider.notifier).save(record);
    if (!mounted) return;

    if (saved) {
      context.go('/');
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.analysisSaveSuccess)));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.analysisSaveFail)));
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final isSaving = ref.watch(saveMealProvider) is AsyncLoading;
    final judgeColor =
        Color(AppConstants.judgeColor[_judge] ?? AppConstants.judgeColor['good']!);
    final judgeText = NutritionJudge.localizeJudge(_judge, l10n);
    final judgeReason = NutritionJudge.judgeReason(
      l10n: l10n, judge: _judge, totalKcal: _totalKcal,
      protein: _proteinLevel, carbs: _carbsLevel, fat: _fatLevel,
    );
    final nextAdvice = NutritionJudge.nextMealAdvice(
      l10n: l10n, judge: _judge,
      protein: _proteinLevel, carbs: _carbsLevel, fat: _fatLevel,
    );

    return Scaffold(
      backgroundColor: AppTheme.surfaceSoft,
      appBar: AppBar(title: Text(l10n.analysisTitle)),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(
            AppTheme.spBase, AppTheme.spXl,
            AppTheme.spBase, 100),
        children: [

          // ── Judge banner — promo-strip style ─────────────────────────────
          Container(
            padding: const EdgeInsets.all(AppTheme.spXxl),
            decoration: BoxDecoration(
              color: judgeColor.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(AppTheme.rXxxl),
              border: Border.all(
                  color: judgeColor.withValues(alpha: 0.2)),
            ),
            child: Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: judgeColor.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(AppTheme.rXl),
                  ),
                  child: Icon(_judgeIcon(_judge),
                      color: judgeColor, size: 24),
                ),
                const SizedBox(width: AppTheme.spXl),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(judgeText,
                          style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w700,
                              color: judgeColor,
                              letterSpacing: -0.5)),
                      const SizedBox(height: 4),
                      Text(judgeReason,
                          style: const TextStyle(
                              fontSize: 13,
                              color: AppTheme.charcoal,
                              height: 1.4)),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppTheme.spXl),

          // ── Food list card ────────────────────────────────────────────────
          _SectionCard(
            label: l10n.analysisFoodList,
            child: Column(
              children: [
                ..._entries.asMap().entries.map((e) => _FoodRow(
                      entry: e.value,
                      onServingChanged: (g) =>
                          setState(() => e.value.servingG = g),
                      onRemove: _entries.length > 1
                          ? () =>
                              setState(() => _entries.removeAt(e.key))
                          : null,
                    )),
                const Divider(height: AppTheme.spXxl),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(l10n.analysisTotal,
                        style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                            color: AppTheme.inkDeep)),
                    Text(l10n.analysisTotalKcal(_totalKcal),
                        style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: AppTheme.primary)),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: AppTheme.spXl),

          // ── Macro balance ─────────────────────────────────────────────────
          _SectionCard(
            label: l10n.analysisNutrition,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _MacroItem(
                    label: l10n.macroProtein,
                    grams: _totalProtein,
                    level: _proteinLevel,
                    displayLevel: NutritionJudge.localizeLevel(
                        _proteinLevel, l10n)),
                _MacroItem(
                    label: l10n.macroCarbs,
                    grams: _totalCarbs,
                    level: _carbsLevel,
                    displayLevel: NutritionJudge.localizeLevel(
                        _carbsLevel, l10n)),
                _MacroItem(
                    label: l10n.macroFat,
                    grams: _totalFat,
                    level: _fatLevel,
                    displayLevel: NutritionJudge.localizeLevel(
                        _fatLevel, l10n)),
              ],
            ),
          ),
          const SizedBox(height: AppTheme.spXl),

          // ── Next meal advice ──────────────────────────────────────────────
          Container(
            padding: const EdgeInsets.all(AppTheme.spXxl),
            decoration: BoxDecoration(
              color: AppTheme.inkDeep,
              borderRadius: BorderRadius.circular(AppTheme.rXxl),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(Icons.lightbulb_outline,
                    color: AppTheme.warning, size: 20),
                const SizedBox(width: AppTheme.spMd),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(l10n.analysisNextAdviceTitle,
                          style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                              color: AppTheme.stone,
                              letterSpacing: 0.5)),
                      const SizedBox(height: 6),
                      Text(nextAdvice,
                          style: const TextStyle(
                              fontSize: 14,
                              color: AppTheme.canvas,
                              height: 1.5)),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppTheme.spXl),

          // ── Meal type — pill tabs ─────────────────────────────────────────
          Text(l10n.analysisMealTypeLabel,
              style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: AppTheme.steel,
                  letterSpacing: 0.5)),
          const SizedBox(height: AppTheme.spMd),
          Wrap(
            spacing: AppTheme.spXs,
            children: AppConstants.mealTypes.map((type) {
              final selected = type == _selectedMealType;
              return GestureDetector(
                onTap: () =>
                    setState(() => _selectedMealType = type),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 150),
                  padding: const EdgeInsets.symmetric(
                      horizontal: AppTheme.spBase,
                      vertical: AppTheme.spXs),
                  decoration: BoxDecoration(
                    color: selected
                        ? AppTheme.inkDeep
                        : AppTheme.canvas,
                    borderRadius:
                        BorderRadius.circular(AppTheme.rFull),
                    border: Border.all(
                        color: selected
                            ? AppTheme.inkDeep
                            : AppTheme.hairline),
                  ),
                  child: Text(
                    NutritionJudge.localizeMealType(type, l10n),
                    style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        letterSpacing: -0.14,
                        color: selected
                            ? AppTheme.canvas
                            : AppTheme.ink),
                  ),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: AppTheme.spXxl),

          // ── Save button — cobalt CTA ──────────────────────────────────────
          SizedBox(
            height: 52,
            child: FilledButton(
              onPressed: isSaving ? null : _save,
              style: FilledButton.styleFrom(
                backgroundColor: AppTheme.primary,
                foregroundColor: AppTheme.canvas,
                shape: const StadiumBorder(),
                textStyle: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    letterSpacing: -0.14),
              ),
              child: isSaving
                  ? const SizedBox(
                      width: 22,
                      height: 22,
                      child: CircularProgressIndicator(
                          strokeWidth: 2, color: AppTheme.canvas),
                    )
                  : Text(l10n.analysisSaveButton),
            ),
          ),
        ],
      ),
    );
  }

  IconData _judgeIcon(String j) {
    switch (j) {
      case 'good':    return Icons.check_circle_outline;
      case 'caution': return Icons.warning_amber_outlined;
      default:        return Icons.error_outline;
    }
  }
}

// ── Section card ──────────────────────────────────────────────────────────────
class _SectionCard extends StatelessWidget {
  final String label;
  final Widget child;
  const _SectionCard({required this.label, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppTheme.spXxl),
      decoration: BoxDecoration(
        color: AppTheme.canvas,
        borderRadius: BorderRadius.circular(AppTheme.rXxl),
        border: Border.all(color: AppTheme.hairlineSoft),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label,
              style: const TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  color: AppTheme.stone,
                  letterSpacing: 0.5)),
          const SizedBox(height: AppTheme.spXl),
          child,
        ],
      ),
    );
  }
}

// ── Food row ──────────────────────────────────────────────────────────────────
class _FoodRow extends StatefulWidget {
  final _Entry entry;
  final ValueChanged<double> onServingChanged;
  final VoidCallback? onRemove;
  const _FoodRow(
      {required this.entry,
      required this.onServingChanged,
      required this.onRemove});

  @override
  State<_FoodRow> createState() => _FoodRowState();
}

class _FoodRowState extends State<_FoodRow> {
  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Padding(
      padding: const EdgeInsets.only(bottom: AppTheme.spMd),
      child: Row(
        children: [
          Expanded(
            child: Text(widget.entry.name,
                style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: AppTheme.inkDeep,
                    letterSpacing: -0.14)),
          ),
          SizedBox(
            width: 72,
            height: 44,
            child: TextField(
              controller: widget.entry.controller,
              keyboardType: TextInputType.number,
              textAlign: TextAlign.center,
              style: const TextStyle(
                  fontSize: 13, color: AppTheme.ink),
              decoration: InputDecoration(
                suffixText: 'g',
                suffixStyle: const TextStyle(
                    fontSize: 11, color: AppTheme.steel),
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 6),
                border: OutlineInputBorder(
                  borderRadius:
                      BorderRadius.circular(AppTheme.rLg),
                  borderSide:
                      const BorderSide(color: AppTheme.hairline),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius:
                      BorderRadius.circular(AppTheme.rLg),
                  borderSide:
                      const BorderSide(color: AppTheme.hairline),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius:
                      BorderRadius.circular(AppTheme.rLg),
                  borderSide: const BorderSide(
                      color: Color(0xFF1876F2), width: 2),
                ),
              ),
              onChanged: (v) {
                final g = double.tryParse(v);
                if (g != null && g > 0) {
                  widget.onServingChanged(g);
                }
              },
            ),
          ),
          const SizedBox(width: AppTheme.spXs),
          SizedBox(
            width: 56,
            child: Text(l10n.analysisKcal(widget.entry.kcal),
                textAlign: TextAlign.right,
                style: const TextStyle(
                    fontSize: 12, color: AppTheme.steel)),
          ),
          if (widget.onRemove != null)
            IconButton(
              icon: const Icon(Icons.delete_outline,
                  color: AppTheme.stone, size: 18),
              onPressed: widget.onRemove,
              padding: const EdgeInsets.all(4),
              constraints: const BoxConstraints(),
            )
          else
            const SizedBox(width: 28),
        ],
      ),
    );
  }
}

// ── Macro item ────────────────────────────────────────────────────────────────
class _MacroItem extends StatelessWidget {
  final String label;
  final double grams;
  final String level;
  final String displayLevel;
  const _MacroItem(
      {required this.label,
      required this.grams,
      required this.level,
      required this.displayLevel});

  Color get _color {
    switch (level) {
      case '높음': return AppTheme.critical;
      case '보통': return AppTheme.attention;
      default:    return AppTheme.success;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(
              horizontal: 14, vertical: 6),
          decoration: BoxDecoration(
            color: _color.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(AppTheme.rFull),
            border: Border.all(
                color: _color.withValues(alpha: 0.25)),
          ),
          child: Text(displayLevel,
              style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: _color)),
        ),
        const SizedBox(height: 6),
        Text(label,
            style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: AppTheme.inkDeep)),
        Text('${grams.toStringAsFixed(1)}g',
            style: const TextStyle(
                fontSize: 11, color: AppTheme.steel)),
      ],
    );
  }
}

// ── Data model ────────────────────────────────────────────────────────────────
class _Entry {
  final String name;
  final double kcalPer100g;
  final double proteinPer100g;
  final double carbsPer100g;
  final double fatPer100g;
  double servingG;
  late TextEditingController controller;

  _Entry({
    required this.name,
    required this.kcalPer100g,
    required this.proteinPer100g,
    required this.carbsPer100g,
    required this.fatPer100g,
    required this.servingG,
  }) {
    controller =
        TextEditingController(text: servingG.round().toString());
  }

  int get kcal => (kcalPer100g * servingG / 100).round();
  double get protein => proteinPer100g * servingG / 100;
  double get carbs => carbsPer100g * servingG / 100;
  double get fat => fatPer100g * servingG / 100;
}
