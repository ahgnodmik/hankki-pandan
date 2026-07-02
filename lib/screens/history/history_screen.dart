import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../core/constants/app_constants.dart';
import '../../core/extensions/context_ext.dart';
import '../../core/theme/app_theme.dart';
import '../../core/utils/nutrition_judge.dart';
import '../../models/meal_record.dart';
import '../../providers/providers.dart';

class HistoryScreen extends ConsumerWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final selectedDate = ref.watch(selectedDateProvider);
    final mealsAsync = ref.watch(selectedDateMealsProvider);

    return Scaffold(
      backgroundColor: AppTheme.surfaceSoft,
      appBar: AppBar(
        title: Text(l10n.historyTitle),
        automaticallyImplyLeading: false,
      ),
      body: Column(
        children: [
          _DateStrip(selectedDate: selectedDate, ref: ref),
          Expanded(
            child: mealsAsync.when(
              loading: () =>
                  const Center(child: CircularProgressIndicator()),
              error: (e, _) => Center(child: Text('오류: $e')),
              data: (meals) => meals.isEmpty
                  ? const _EmptyState()
                  : _MealList(meals: meals),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Date strip — pill tabs ────────────────────────────────────────────────────
class _DateStrip extends StatelessWidget {
  final DateTime selectedDate;
  final WidgetRef ref;
  const _DateStrip({required this.selectedDate, required this.ref});

  @override
  Widget build(BuildContext context) {
    final today = DateTime.now();
    final days = List.generate(14, (i) {
      return DateTime(today.year, today.month, today.day - (13 - i));
    });

    return Container(
      height: 76,
      decoration: BoxDecoration(
        color: AppTheme.canvas,
        border: Border(
            bottom: BorderSide(color: AppTheme.hairlineSoft)),
      ),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(
            horizontal: AppTheme.spBase, vertical: AppTheme.spMd),
        itemCount: days.length,
        itemBuilder: (_, i) {
          final day = days[i];
          final isSelected = day.year == selectedDate.year &&
              day.month == selectedDate.month &&
              day.day == selectedDate.day;
          final isToday = day.year == today.year &&
              day.month == today.month &&
              day.day == today.day;

          return GestureDetector(
            onTap: () =>
                ref.read(selectedDateProvider.notifier).select(day),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 150),
              width: 44,
              margin: const EdgeInsets.symmetric(horizontal: 3),
              decoration: BoxDecoration(
                color: isSelected
                    ? AppTheme.inkDeep
                    : Colors.transparent,
                borderRadius:
                    BorderRadius.circular(AppTheme.rFull),
                border: isSelected
                    ? null
                    : Border.all(color: AppTheme.hairlineSoft),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    DateFormat('E', 'ko').format(day),
                    style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                        color: isSelected
                            ? AppTheme.stone
                            : AppTheme.stone),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '${day.day}',
                    style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: isSelected
                            ? AppTheme.canvas
                            : isToday
                                ? AppTheme.primary
                                : AppTheme.inkDeep),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

// ── Empty ─────────────────────────────────────────────────────────────────────
class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 72,
            height: 72,
            decoration: BoxDecoration(
              color: AppTheme.canvas,
              borderRadius: BorderRadius.circular(AppTheme.rXxl),
              border: Border.all(color: AppTheme.hairlineSoft),
            ),
            child: const Icon(Icons.no_meals_outlined,
                size: 32, color: AppTheme.stone),
          ),
          const SizedBox(height: AppTheme.spXl),
          Text(context.l10n.historyEmpty,
              style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: AppTheme.inkDeep)),
        ],
      ),
    );
  }
}

// ── Meal list ─────────────────────────────────────────────────────────────────
class _MealList extends StatelessWidget {
  final List<MealRecord> meals;
  const _MealList({required this.meals});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final totalMin = meals.fold(0, (s, m) => s + m.totalCalMin);
    final totalMax = meals.fold(0, (s, m) => s + m.totalCalMax);

    return ListView(
      padding: const EdgeInsets.fromLTRB(
          AppTheme.spBase, AppTheme.spXl,
          AppTheme.spBase, AppTheme.spXxl),
      children: [
        // Daily total — promo-strip
        Container(
          padding: const EdgeInsets.symmetric(
              horizontal: AppTheme.spXxl, vertical: AppTheme.spXl),
          decoration: BoxDecoration(
            color: AppTheme.inkDeep,
            borderRadius: BorderRadius.circular(AppTheme.rXxl),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(l10n.historyDailyTotal,
                  style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: AppTheme.stone,
                      letterSpacing: 0.3)),
              Text(l10n.calRange(totalMin, totalMax),
                  style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: AppTheme.canvas,
                      letterSpacing: -0.5)),
            ],
          ),
        ),
        const SizedBox(height: AppTheme.spXl),
        ...meals.map((m) => _MealCard(record: m)),
      ],
    );
  }
}

class _MealCard extends ConsumerWidget {
  final MealRecord record;
  const _MealCard({required this.record});

  void _showDeleteConfirm(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('기록 삭제'),
        content: const Text('이 식단 기록을 삭제하시겠어요?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('취소'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              await ref.read(deleteMealProvider.notifier).delete(record.id);
            },
            child: const Text('삭제',
                style: TextStyle(color: AppTheme.critical)),
          ),
        ],
      ),
    );
  }

  void _showEditSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _EditRecordSheet(record: record),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final judgeColor = Color(
        AppConstants.judgeColor[record.judge] ??
            AppConstants.judgeColor['good']!);
    final judgeText = NutritionJudge.localizeJudge(record.judge, l10n);
    final timeStr = DateFormat('HH:mm').format(record.recordedAt);

    return Container(
      margin: const EdgeInsets.only(bottom: AppTheme.spMd),
      padding: const EdgeInsets.fromLTRB(
          AppTheme.spXxl, AppTheme.spXl, AppTheme.spMd, AppTheme.spXxl),
      decoration: BoxDecoration(
        color: AppTheme.canvas,
        borderRadius: BorderRadius.circular(AppTheme.rXxl),
        border: Border.all(color: AppTheme.hairlineSoft),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: AppTheme.surfaceSoft,
                  borderRadius: BorderRadius.circular(AppTheme.rFull),
                  border: Border.all(color: AppTheme.hairline),
                ),
                child: Text(
                    NutritionJudge.localizeMealType(record.mealType, l10n),
                    style: const TextStyle(
                        fontSize: 12, fontWeight: FontWeight.w700,
                        color: AppTheme.inkDeep, letterSpacing: -0.14)),
              ),
              const SizedBox(width: AppTheme.spXs),
              Text(timeStr,
                  style: const TextStyle(fontSize: 12, color: AppTheme.stone)),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: judgeColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(AppTheme.rFull),
                  border: Border.all(color: judgeColor.withValues(alpha: 0.25)),
                ),
                child: Text(judgeText,
                    style: TextStyle(
                        fontSize: 12, fontWeight: FontWeight.w700,
                        color: judgeColor)),
              ),
              PopupMenuButton<String>(
                icon: const Icon(Icons.more_vert,
                    color: AppTheme.stone, size: 18),
                padding: EdgeInsets.zero,
                onSelected: (value) {
                  if (value == 'edit') _showEditSheet(context);
                  if (value == 'delete') _showDeleteConfirm(context, ref);
                },
                itemBuilder: (_) => const [
                  PopupMenuItem(value: 'edit', child: Text('수정')),
                  PopupMenuItem(value: 'delete', child: Text('삭제')),
                ],
              ),
            ],
          ),
          const SizedBox(height: AppTheme.spMd),
          Padding(
            padding: const EdgeInsets.only(right: AppTheme.spBase),
            child: Text(
              record.foods.map((f) => f.name).join(', '),
              style: const TextStyle(
                  fontSize: 15, fontWeight: FontWeight.w700,
                  color: AppTheme.inkDeep, letterSpacing: -0.14),
            ),
          ),
          const SizedBox(height: 3),
          Padding(
            padding: const EdgeInsets.only(right: AppTheme.spBase),
            child: Text(l10n.calRange(record.totalCalMin, record.totalCalMax),
                style: const TextStyle(fontSize: 13, color: AppTheme.steel)),
          ),
          const SizedBox(height: AppTheme.spMd),
          Padding(
            padding: const EdgeInsets.only(right: AppTheme.spBase),
            child: Text(record.judgeReason,
                style: const TextStyle(
                    fontSize: 13, color: AppTheme.charcoal, height: 1.45)),
          ),
        ],
      ),
    );
  }
}

// ── Edit record sheet ─────────────────────────────────────────────────────────

class _EditEntry {
  final TextEditingController nameCtrl;
  final TextEditingController kcalCtrl;
  _EditEntry({required this.nameCtrl, required this.kcalCtrl});
  void dispose() {
    nameCtrl.dispose();
    kcalCtrl.dispose();
  }
}

class _EditRecordSheet extends ConsumerStatefulWidget {
  final MealRecord record;
  const _EditRecordSheet({required this.record});

  @override
  ConsumerState<_EditRecordSheet> createState() => _EditRecordSheetState();
}

class _EditRecordSheetState extends ConsumerState<_EditRecordSheet> {
  late String _mealType;
  late List<_EditEntry> _entries;

  @override
  void initState() {
    super.initState();
    _mealType = widget.record.mealType;
    _entries = widget.record.foods
        .map((f) => _EditEntry(
              nameCtrl: TextEditingController(text: f.name),
              kcalCtrl: TextEditingController(text: f.calorieMin.toString()),
            ))
        .toList();
  }

  @override
  void dispose() {
    for (final e in _entries) { e.dispose(); }
    super.dispose();
  }

  int get _totalKcal => _entries.fold(
      0, (s, e) => s + (int.tryParse(e.kcalCtrl.text) ?? 0));

  Future<void> _save() async {
    final foods = _entries
        .where((e) => e.nameCtrl.text.trim().isNotEmpty)
        .map((e) => FoodItem(
              name: e.nameCtrl.text.trim(),
              calorieMin: int.tryParse(e.kcalCtrl.text) ?? 0,
              calorieMax: int.tryParse(e.kcalCtrl.text) ?? 0,
            ))
        .toList();
    if (foods.isEmpty) return;

    final total = _totalKcal;
    final l10n = context.l10n;
    final newJudge = NutritionJudge.judge(
      totalKcal: total,
      protein: widget.record.protein,
      carbs: widget.record.carbs,
      fat: widget.record.fat,
    );

    final updated = MealRecord(
      id: widget.record.id,
      mealType: _mealType,
      foods: foods,
      totalCalMin: total,
      totalCalMax: total,
      protein: widget.record.protein,
      carbs: widget.record.carbs,
      fat: widget.record.fat,
      judge: newJudge,
      judgeReason: NutritionJudge.judgeReason(
        l10n: l10n, judge: newJudge, totalKcal: total,
        protein: widget.record.protein,
        carbs: widget.record.carbs,
        fat: widget.record.fat,
      ),
      nextMealAdvice: NutritionJudge.nextMealAdvice(
        l10n: l10n, judge: newJudge,
        protein: widget.record.protein,
        carbs: widget.record.carbs,
        fat: widget.record.fat,
      ),
      imageUrl: widget.record.imageUrl,
      rawInput: widget.record.rawInput,
      recordedAt: widget.record.recordedAt,
    );

    await ref.read(saveMealProvider.notifier).save(updated);
    if (mounted) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;
    final isSaving = ref.watch(saveMealProvider) is AsyncLoading;

    return Container(
      margin: const EdgeInsets.fromLTRB(
          AppTheme.spBase, 0, AppTheme.spBase, AppTheme.spBase),
      decoration: BoxDecoration(
        color: AppTheme.canvas,
        borderRadius: BorderRadius.circular(AppTheme.rXxxl),
      ),
      padding: EdgeInsets.fromLTRB(
          AppTheme.spXxl, AppTheme.spXxl,
          AppTheme.spXxl, AppTheme.spXxl + bottomInset),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 36, height: 4,
                decoration: BoxDecoration(
                  color: AppTheme.hairline,
                  borderRadius: BorderRadius.circular(AppTheme.rFull),
                ),
              ),
            ),
            const SizedBox(height: AppTheme.spXl),
            const Text('기록 수정',
                style: TextStyle(
                    fontSize: 20, fontWeight: FontWeight.w700,
                    color: AppTheme.inkDeep, letterSpacing: -0.5)),
            const SizedBox(height: AppTheme.spXl),

            // Meal type
            const Text('식사 종류',
                style: TextStyle(
                    fontSize: 12, fontWeight: FontWeight.w700,
                    color: AppTheme.stone, letterSpacing: 0.3)),
            const SizedBox(height: AppTheme.spXs),
            Wrap(
              spacing: AppTheme.spXs,
              children: AppConstants.mealTypes.map((type) {
                final selected = type == _mealType;
                return GestureDetector(
                  onTap: () => setState(() => _mealType = type),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 150),
                    padding: const EdgeInsets.symmetric(
                        horizontal: AppTheme.spBase, vertical: AppTheme.spXs),
                    decoration: BoxDecoration(
                      color: selected ? AppTheme.inkDeep : AppTheme.surfaceSoft,
                      borderRadius: BorderRadius.circular(AppTheme.rFull),
                      border: Border.all(
                          color: selected ? AppTheme.inkDeep : AppTheme.hairline),
                    ),
                    child: Text(type,
                        style: TextStyle(
                            fontSize: 13, fontWeight: FontWeight.w700,
                            color: selected ? AppTheme.canvas : AppTheme.ink)),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: AppTheme.spXl),

            // Food list
            const Text('음식 목록',
                style: TextStyle(
                    fontSize: 12, fontWeight: FontWeight.w700,
                    color: AppTheme.stone, letterSpacing: 0.3)),
            const SizedBox(height: AppTheme.spXs),
            ..._entries.asMap().entries.map((e) => _buildFoodRow(e.key, e.value)),

            TextButton.icon(
              onPressed: () => setState(() => _entries.add(_EditEntry(
                nameCtrl: TextEditingController(),
                kcalCtrl: TextEditingController(),
              ))),
              icon: const Icon(Icons.add, size: 16),
              label: const Text('음식 추가'),
              style: TextButton.styleFrom(
                foregroundColor: AppTheme.primary,
                padding: EdgeInsets.zero,
                textStyle: const TextStyle(
                    fontSize: 13, fontWeight: FontWeight.w700),
              ),
            ),
            const SizedBox(height: AppTheme.spXl),

            SizedBox(
              width: double.infinity,
              height: 52,
              child: FilledButton(
                onPressed: isSaving ? null : _save,
                style: FilledButton.styleFrom(
                  backgroundColor: AppTheme.primary,
                  shape: const StadiumBorder(),
                  textStyle: const TextStyle(
                      fontSize: 15, fontWeight: FontWeight.w700),
                ),
                child: isSaving
                    ? const SizedBox(
                        width: 22, height: 22,
                        child: CircularProgressIndicator(
                            strokeWidth: 2, color: AppTheme.canvas))
                    : const Text('저장'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFoodRow(int index, _EditEntry entry) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppTheme.spXs),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: TextField(
              controller: entry.nameCtrl,
              style: const TextStyle(fontSize: 13, color: AppTheme.inkDeep),
              decoration: _fieldDecor(hint: '음식 이름'),
            ),
          ),
          const SizedBox(width: AppTheme.spXs),
          SizedBox(
            width: 90,
            child: TextField(
              controller: entry.kcalCtrl,
              keyboardType: TextInputType.number,
              onChanged: (_) => setState(() {}),
              style: const TextStyle(fontSize: 13, color: AppTheme.inkDeep),
              decoration: _fieldDecor(suffixText: 'kcal'),
            ),
          ),
          if (_entries.length > 1)
            IconButton(
              icon: const Icon(Icons.delete_outline,
                  color: AppTheme.stone, size: 18),
              onPressed: () => setState(() {
                _entries[index].dispose();
                _entries.removeAt(index);
              }),
              constraints: const BoxConstraints(),
              padding: const EdgeInsets.symmetric(horizontal: 6),
            )
          else
            const SizedBox(width: 30),
        ],
      ),
    );
  }

  static InputDecoration _fieldDecor({String? hint, String? suffixText}) =>
      InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(color: AppTheme.stone),
        suffixText: suffixText,
        suffixStyle: const TextStyle(fontSize: 11, color: AppTheme.steel),
        filled: true,
        fillColor: AppTheme.surfaceSoft,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppTheme.rLg),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppTheme.rLg),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppTheme.rLg),
          borderSide: const BorderSide(color: AppTheme.primary, width: 1.5),
        ),
        contentPadding: const EdgeInsets.symmetric(
            horizontal: AppTheme.spBase, vertical: AppTheme.spMd),
        isDense: true,
      );
}
