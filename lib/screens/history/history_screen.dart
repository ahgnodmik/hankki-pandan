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
                ref.read(selectedDateProvider.notifier).state = day,
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

class _MealCard extends StatelessWidget {
  final MealRecord record;
  const _MealCard({required this.record});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final judgeColor = Color(
        AppConstants.judgeColor[record.judge] ??
            AppConstants.judgeColor['good']!);
    final judgeText = NutritionJudge.localizeJudge(record.judge, l10n);
    final timeStr = DateFormat('HH:mm').format(record.recordedAt);

    return Container(
      margin: const EdgeInsets.only(bottom: AppTheme.spMd),
      padding: const EdgeInsets.all(AppTheme.spXxl),
      decoration: BoxDecoration(
        color: AppTheme.canvas,
        borderRadius: BorderRadius.circular(AppTheme.rXxl),
        border: Border.all(color: AppTheme.hairlineSoft),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  // Meal type pill tab
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppTheme.surfaceSoft,
                      borderRadius:
                          BorderRadius.circular(AppTheme.rFull),
                      border: Border.all(
                          color: AppTheme.hairline),
                    ),
                    child: Text(
                        NutritionJudge.localizeMealType(
                            record.mealType, l10n),
                        style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            color: AppTheme.inkDeep,
                            letterSpacing: -0.14)),
                  ),
                  const SizedBox(width: AppTheme.spXs),
                  Text(timeStr,
                      style: const TextStyle(
                          fontSize: 12, color: AppTheme.stone)),
                ],
              ),
              // Judge badge — pill
              Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: judgeColor.withValues(alpha: 0.1),
                  borderRadius:
                      BorderRadius.circular(AppTheme.rFull),
                  border: Border.all(
                      color: judgeColor.withValues(alpha: 0.25)),
                ),
                child: Text(judgeText,
                    style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: judgeColor)),
              ),
            ],
          ),
          const SizedBox(height: AppTheme.spMd),
          Text(
            record.foods.map((f) => f.name).join(', '),
            style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w700,
                color: AppTheme.inkDeep,
                letterSpacing: -0.14),
          ),
          const SizedBox(height: 3),
          Text(l10n.calRange(record.totalCalMin, record.totalCalMax),
              style: const TextStyle(
                  fontSize: 13, color: AppTheme.steel)),
          const SizedBox(height: AppTheme.spMd),
          Text(record.judgeReason,
              style: const TextStyle(
                  fontSize: 13,
                  color: AppTheme.charcoal,
                  height: 1.45)),
        ],
      ),
    );
  }
}
