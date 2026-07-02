import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/ads/banner_ad_widget.dart';
import '../../core/constants/app_constants.dart';
import '../../core/extensions/context_ext.dart';
import '../../core/theme/app_theme.dart';
import '../../core/utils/nutrition_judge.dart';
import '../../models/meal_record.dart';
import '../../providers/providers.dart';
import '../history/history_screen.dart' show EditRecordSheet;

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final mealsAsync = ref.watch(todayMealsProvider);

    return Scaffold(
      backgroundColor: AppTheme.surfaceSoft,
      appBar: AppBar(
        title: Text(l10n.homeTitle),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: AppTheme.spBase),
            child: IconButton(
              icon: const Icon(Icons.calendar_month_outlined),
              style: IconButton.styleFrom(
                backgroundColor: AppTheme.canvas,
                foregroundColor: AppTheme.inkDeep,
                shape: const CircleBorder(),
              ),
              onPressed: () => context.go('/history'),
            ),
          ),
        ],
      ),
      body: mealsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('오류: $e')),
        data: (meals) => _Body(meals: meals),
      ),
      bottomNavigationBar: const _BannerBar(),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.push('/capture'),
        backgroundColor: AppTheme.inkButton,
        foregroundColor: AppTheme.canvas,
        extendedPadding: const EdgeInsets.symmetric(horizontal: 28),
        shape: const StadiumBorder(),
        icon: const Icon(Icons.camera_alt_outlined, size: 20),
        label: Text(
          l10n.homeFabLabel,
          style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              letterSpacing: -0.14),
        ),
      ),
    );
  }
}

// 배너 광고 바 — FAB·내비게이션과 겹치지 않도록 Scaffold bottomNavigationBar 사용
class _BannerBar extends StatelessWidget {
  const _BannerBar();

  @override
  Widget build(BuildContext context) {
    // 시스템 하단 패딩(홈 제스처 영역) 포함
    final bottomPadding = MediaQuery.of(context).padding.bottom;
    return Container(
      color: AppTheme.canvas,
      padding: EdgeInsets.only(bottom: bottomPadding),
      child: const Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Divider(height: 1),
          SizedBox(height: 4),
          BannerAdWidget(),
          SizedBox(height: 4),
        ],
      ),
    );
  }
}

class _Body extends StatelessWidget {
  final List<MealRecord> meals;
  const _Body({required this.meals});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final totalMin = meals.fold(0, (s, m) => s + m.totalCalMin);
    final totalMax = meals.fold(0, (s, m) => s + m.totalCalMax);

    return ListView(
      padding: const EdgeInsets.fromLTRB(
          AppTheme.spBase, AppTheme.spXl, AppTheme.spBase, 100),
      children: [
        _TodaySummaryCard(
            meals: meals, totalMin: totalMin, totalMax: totalMax),
        const SizedBox(height: AppTheme.spXl),
        ...AppConstants.mealTypes.map((type) {
          final typeMeals =
              meals.where((m) => m.mealType == type).toList();
          return _MealTypeSection(
            mealType: type,
            displayType: NutritionJudge.localizeMealType(type, l10n),
            meals: typeMeals,
          );
        }),
      ],
    );
  }
}

// ── Today Summary ────────────────────────────────────────────────────────────
class _TodaySummaryCard extends StatelessWidget {
  final List<MealRecord> meals;
  final int totalMin;
  final int totalMax;

  const _TodaySummaryCard(
      {required this.meals,
      required this.totalMin,
      required this.totalMax});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    if (meals.isEmpty) {
      return _EmptyCard();
    }

    final judgeCount = <String, int>{'good': 0, 'caution': 0, 'adjust': 0};
    for (final m in meals) {
      judgeCount[m.judge] = (judgeCount[m.judge] ?? 0) + 1;
    }
    String overallJudge = 'good';
    if ((judgeCount['adjust'] ?? 0) > 0) {
      overallJudge = 'adjust';
    } else if ((judgeCount['caution'] ?? 0) > 0) {
      overallJudge = 'caution';
    }

    final judgeText =
        NutritionJudge.localizeJudge(overallJudge, l10n);

    return Container(
      padding: const EdgeInsets.all(AppTheme.spXxl),
      decoration: BoxDecoration(
        color: AppTheme.canvas,
        borderRadius: BorderRadius.circular(AppTheme.rXxxl),
        border: Border.all(color: AppTheme.hairlineSoft),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(l10n.homeTodayTotal,
                  style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: AppTheme.steel,
                      letterSpacing: 0.5)),
              // Badge — pill
              _JudgeBadge(judge: overallJudge, label: judgeText),
            ],
          ),
          const SizedBox(height: AppTheme.spMd),
          Text(
            l10n.calRange(totalMin, totalMax),
            style: const TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.w700,
                color: AppTheme.inkDeep,
                letterSpacing: -0.5),
          ),
          const SizedBox(height: AppTheme.spXl),
          const Divider(height: 1),
          const SizedBox(height: AppTheme.spXl),
          _MacroRow(meals: meals),
        ],
      ),
    );
  }
}

class _EmptyCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Container(
      padding: const EdgeInsets.symmetric(
          horizontal: AppTheme.spXxl, vertical: AppTheme.spXxl + 8),
      decoration: BoxDecoration(
        color: AppTheme.canvas,
        borderRadius: BorderRadius.circular(AppTheme.rXxxl),
        border: Border.all(color: AppTheme.hairlineSoft),
      ),
      child: Column(
        children: [
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              color: AppTheme.surfaceSoft,
              borderRadius: BorderRadius.circular(AppTheme.rXxl),
            ),
            child: const Icon(Icons.restaurant_menu_outlined,
                size: 32, color: AppTheme.stone),
          ),
          const SizedBox(height: AppTheme.spXl),
          Text(l10n.homeEmptyMessage,
              style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: AppTheme.inkDeep)),
          const SizedBox(height: AppTheme.spXs),
          Text(l10n.homeEmptyHint,
              textAlign: TextAlign.center,
              style: const TextStyle(
                  fontSize: 14, color: AppTheme.steel)),
          const SizedBox(height: AppTheme.spXl),
          FilledButton.icon(
            onPressed: () => context.push('/capture'),
            icon: const Icon(Icons.search, size: 18),
            label: Text(l10n.homeSearchButton),
          ),
        ],
      ),
    );
  }
}

// ── Macro Row ────────────────────────────────────────────────────────────────
class _MacroRow extends StatelessWidget {
  final List<MealRecord> meals;
  const _MacroRow({required this.meals});

  String _majority(List<String> values) {
    final counts = <String, int>{};
    for (final v in values) {
      counts[v] = (counts[v] ?? 0) + 1;
    }
    return counts.entries
        .reduce((a, b) => a.value >= b.value ? a : b)
        .key;
  }

  @override
  Widget build(BuildContext context) {
    if (meals.isEmpty) return const SizedBox.shrink();
    final l10n = context.l10n;
    final protein = _majority(meals.map((m) => m.protein).toList());
    final carbs   = _majority(meals.map((m) => m.carbs).toList());
    final fat     = _majority(meals.map((m) => m.fat).toList());

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        _MacroChip(
            label: l10n.macroProtein,
            rawLevel: protein,
            displayLevel: NutritionJudge.localizeLevel(protein, l10n)),
        _MacroChip(
            label: l10n.macroCarbs,
            rawLevel: carbs,
            displayLevel: NutritionJudge.localizeLevel(carbs, l10n)),
        _MacroChip(
            label: l10n.macroFat,
            rawLevel: fat,
            displayLevel: NutritionJudge.localizeLevel(fat, l10n)),
      ],
    );
  }
}

class _MacroChip extends StatelessWidget {
  final String label;
  final String rawLevel;
  final String displayLevel;
  const _MacroChip(
      {required this.label,
      required this.rawLevel,
      required this.displayLevel});

  Color get _color {
    switch (rawLevel) {
      case '높음': return AppTheme.critical;
      case '보통': return AppTheme.attention;
      default:    return AppTheme.success;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // pill badge
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 5),
          decoration: BoxDecoration(
            color: _color.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(AppTheme.rFull),
            border: Border.all(color: _color.withValues(alpha: 0.25)),
          ),
          child: Text(displayLevel,
              style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: _color)),
        ),
        const SizedBox(height: 4),
        Text(label,
            style: const TextStyle(
                fontSize: 11,
                color: AppTheme.stone,
                fontWeight: FontWeight.w400)),
      ],
    );
  }
}

// ── Meal Type Section ─────────────────────────────────────────────────────────
class _MealTypeSection extends StatelessWidget {
  final String mealType;
  final String displayType;
  final List<MealRecord> meals;
  const _MealTypeSection(
      {required this.mealType, required this.displayType, required this.meals});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppTheme.spXl),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(
                bottom: AppTheme.spMd, left: 4),
            child: Text(displayType,
                style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: AppTheme.inkDeep,
                    letterSpacing: -0.14)),
          ),
          if (meals.isEmpty)
            _EmptyMealCard(mealType: mealType, displayType: displayType)
          else
            ...meals.map((m) => _MealCard(record: m)),
        ],
      ),
    );
  }
}

class _MealCard extends ConsumerWidget {
  final MealRecord record;
  const _MealCard({required this.record});

  void _showEditSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => EditRecordSheet(record: record),
    );
  }

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

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final judgeText = NutritionJudge.localizeJudge(record.judge, l10n);

    return Container(
      margin: const EdgeInsets.only(bottom: AppTheme.spXs),
      padding: const EdgeInsets.fromLTRB(
          AppTheme.spXl, AppTheme.spXs, AppTheme.spXs, AppTheme.spXs),
      decoration: BoxDecoration(
        color: AppTheme.canvas,
        borderRadius: BorderRadius.circular(AppTheme.rXl),
        border: Border.all(color: AppTheme.hairlineSoft),
      ),
      child: Row(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: AppTheme.spMd),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(record.foods.map((f) => f.name).join(', '),
                      style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: AppTheme.inkDeep,
                          letterSpacing: -0.14)),
                  const SizedBox(height: 3),
                  Text(
                      l10n.calRange(record.totalCalMin, record.totalCalMax),
                      style: const TextStyle(
                          fontSize: 13, color: AppTheme.steel)),
                ],
              ),
            ),
          ),
          _JudgeBadge(judge: record.judge, label: judgeText),
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
    );
  }
}

// ── Empty meal card ───────────────────────────────────────────────────────────
class _EmptyMealCard extends StatelessWidget {
  final String mealType;
  final String displayType;
  const _EmptyMealCard({required this.mealType, required this.displayType});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => context.push('/capture', extra: mealType),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(
            horizontal: AppTheme.spXl, vertical: AppTheme.spBase),
        decoration: BoxDecoration(
          color: AppTheme.canvas,
          borderRadius: BorderRadius.circular(AppTheme.rXl),
          border: Border.all(
              color: AppTheme.hairlineSoft, style: BorderStyle.solid),
        ),
        child: Row(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: AppTheme.surfaceSoft,
                borderRadius: BorderRadius.circular(AppTheme.rLg),
              ),
              child: const Icon(Icons.add,
                  size: 18, color: AppTheme.stone),
            ),
            const SizedBox(width: AppTheme.spBase),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('$displayType 기록하기',
                      style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: AppTheme.inkDeep,
                          letterSpacing: -0.14)),
                  const SizedBox(height: 2),
                  const Text('탭해서 식단을 추가하세요',
                      style: TextStyle(
                          fontSize: 12, color: AppTheme.stone)),
                ],
              ),
            ),
            const Icon(Icons.chevron_right,
                color: AppTheme.stone, size: 20),
          ],
        ),
      ),
    );
  }
}

// ── Shared badge ─────────────────────────────────────────────────────────────
class _JudgeBadge extends StatelessWidget {
  final String judge;
  final String label;
  const _JudgeBadge({required this.judge, required this.label});

  @override
  Widget build(BuildContext context) {
    final color = Color(
        AppConstants.judgeColor[judge] ?? AppConstants.judgeColor['good']!);
    return Container(
      padding:
          const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(AppTheme.rFull),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Text(label,
          style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: color)),
    );
  }
}
