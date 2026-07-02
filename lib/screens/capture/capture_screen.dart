import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import '../../core/extensions/context_ext.dart';
import '../../core/theme/app_theme.dart';
import '../../models/food_models.dart';
import '../../providers/providers.dart';

// 바텀시트 가이드 칩 (수평 스크롤)
const _calGuide = [
  ('🍚 밥·면류',   '300~400'),
  ('🍲 국·찌개',   '100~200'),
  ('🥩 고기류',    '300~500'),
  ('🐟 생선류',    '150~300'),
  ('🥦 채소반찬',  '30~100'),
  ('🍎 과일',      '60~150'),
  ('🍞 빵·과자',   '200~400'),
  ('🥤 음료',      '50~200'),
  ('🍔 패스트푸드','400~700'),
  ('🍜 분식류',    '400~600'),
];

// 빠른 직접 입력 카테고리 (랜딩 빈 화면)
class _QuickCat {
  final String emoji;
  final String name;
  final int kcal;
  final int servingG;
  const _QuickCat(this.emoji, this.name, this.kcal, this.servingG);
}

const _quickCats = [
  _QuickCat('🍚', '공기밥',    300, 210),
  _QuickCat('🍜', '면·파스타', 450, 350),
  _QuickCat('🍲', '국·찌개',   150, 300),
  _QuickCat('🥩', '고기구이',  400, 150),
  _QuickCat('🍗', '닭요리',    320, 200),
  _QuickCat('🐟', '생선구이',  220, 150),
  _QuickCat('🍳', '달걀요리',  180, 120),
  _QuickCat('🥦', '채소반찬',  60,  100),
  _QuickCat('🍞', '빵·샌드위치', 380, 150),
  _QuickCat('🍔', '버거·피자', 650, 300),
  _QuickCat('🍎', '과일',      120, 200),
  _QuickCat('🥤', '음료',      150, 250),
];

class CaptureScreen extends ConsumerStatefulWidget {
  final String? initialMealType;
  const CaptureScreen({super.key, this.initialMealType});

  @override
  ConsumerState<CaptureScreen> createState() => _CaptureScreenState();
}

class _CaptureScreenState extends ConsumerState<CaptureScreen> {
  File? _photo;
  final _picker = ImagePicker();

  final _searchCtrl = TextEditingController();
  final _searchFocus = FocusNode();
  List<_Entry> _localResults = [];
  List<_Entry> _apiResults = [];
  bool _apiLoading = false;
  Timer? _debounce;

  final _selected = <SelectedFood>[];

  @override
  void dispose() {
    _searchCtrl.dispose();
    _searchFocus.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  // ── Camera / Gallery ───────────────────────────────────────────────────────
  Future<void> _pickImage(ImageSource source) async {
    final xfile = await _picker.pickImage(
        source: source, imageQuality: 85, maxWidth: 1280);
    if (!mounted) return;
    if (xfile != null) {
      setState(() => _photo = File(xfile.path));
      Future.delayed(const Duration(milliseconds: 300),
          () => _searchFocus.requestFocus());
    }
  }

  // ── Search ─────────────────────────────────────────────────────────────────
  void _onSearchChanged(String query) {
    _debounce?.cancel();
    final svc = ref.read(foodSearchServiceProvider);
    setState(() {
      _localResults = svc
          .searchLocal(query)
          .map((f) => _Entry(food: f, fromApi: false))
          .toList();
      _apiResults = [];
      _apiLoading = query.trim().isNotEmpty;
    });
    if (query.trim().isEmpty) return;
    _debounce = Timer(const Duration(milliseconds: 500), () async {
      final api = await svc.searchApi(query);
      if (!mounted) return;
      final localNames = _localResults.map((e) => e.food.name).toSet();
      setState(() {
        _apiResults = api
            .where((f) => !localNames.contains(f.name))
            .map((f) => _Entry(food: f, fromApi: true))
            .toList();
        _apiLoading = false;
      });
    });
  }

  void _clearSearch() {
    _searchCtrl.clear();
    _onSearchChanged('');
    _searchFocus.requestFocus();
  }

  // ── Manual entry ────────────────────────────────────────────────────────────
  void _showManualEntry({
    String prefillName = '',
    int prefillKcal = 0,
    int prefillServing = 200,
  }) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _ManualEntrySheet(
        prefillName: prefillName,
        prefillKcal: prefillKcal,
        prefillServing: prefillServing,
        onAdd: (food) => setState(() => _selected.add(
            SelectedFood(source: food, servingG: food.defaultServingG.toDouble()))),
      ),
    );
  }

  // ── Selection ──────────────────────────────────────────────────────────────
  void _add(FoodResult food) {
    HapticFeedback.lightImpact();
    setState(() => _selected.add(
        SelectedFood(source: food, servingG: food.defaultServingG.toDouble())));
  }
  void _remove(int i) => setState(() => _selected.removeAt(i));
  bool _isAdded(String name) => _selected.any((s) => s.source.name == name);

  void _analyze() {
    final l10n = context.l10n;
    if (_selected.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.captureSelectAtLeastOne)));
      return;
    }
    context.push('/analysis', extra: {
      'foods': List<SelectedFood>.from(_selected),
      'mealType': widget.initialMealType,
    });
  }

  // ── Build ──────────────────────────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final allResults = [..._localResults, ..._apiResults];
    final query = _searchCtrl.text;
    final noResult = query.isNotEmpty && allResults.isEmpty && !_apiLoading;

    return Scaffold(
      backgroundColor: AppTheme.surfaceSoft,
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: Text(l10n.captureTitle),
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => context.pop(),
        ),
      ),
      body: Column(
        children: [
          // 1. Photo zone
          _PhotoZone(
            photo: _photo,
            onCamera: () => _pickImage(ImageSource.camera),
            onGallery: () => _pickImage(ImageSource.gallery),
            onRetake: () => _pickImage(ImageSource.camera),
          ),

          // 2. Selected chips
          AnimatedSize(
            duration: const Duration(milliseconds: 220),
            curve: Curves.easeInOut,
            child: _selected.isEmpty
                ? const SizedBox.shrink()
                : _ChipsBar(foods: _selected, onRemove: _remove),
          ),

          // 3. Search pill
          Container(
            color: AppTheme.canvas,
            padding: const EdgeInsets.fromLTRB(
                AppTheme.spBase, AppTheme.spMd,
                AppTheme.spBase, AppTheme.spBase),
            child: Container(
              height: 44,
              decoration: BoxDecoration(
                color: AppTheme.surfaceSoft,
                borderRadius: BorderRadius.circular(AppTheme.rFull),
              ),
              child: TextField(
                controller: _searchCtrl,
                focusNode: _searchFocus,
                onChanged: _onSearchChanged,
                style: const TextStyle(fontSize: 14, color: AppTheme.ink),
                decoration: InputDecoration(
                  hintText: l10n.captureSearchHint,
                  hintStyle: const TextStyle(color: AppTheme.steel, fontSize: 14),
                  prefixIcon: const Icon(Icons.search, color: AppTheme.stone, size: 20),
                  suffixIcon: query.isNotEmpty
                      ? IconButton(
                          icon: const Icon(Icons.close, color: AppTheme.stone, size: 18),
                          onPressed: _clearSearch,
                        )
                      : null,
                  border: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  contentPadding: EdgeInsets.zero,
                  filled: false,
                ),
              ),
            ),
          ),

          // 4. Results / states
          Expanded(
            child: query.isEmpty
                ? _EmptyWithQuickAdd(
                    hasPhoto: _photo != null,
                    onManualAdd: () => _showManualEntry(),
                    onCategoryTap: (cat) => _showManualEntry(
                      prefillName: cat.name,
                      prefillKcal: cat.kcal,
                      prefillServing: cat.servingG,
                    ),
                  )
                : noResult
                    ? _NoResult(
                        query: query,
                        onManualAdd: () => _showManualEntry(prefillName: query),
                      )
                    : ListView.builder(
                        keyboardDismissBehavior:
                            ScrollViewKeyboardDismissBehavior.onDrag,
                        padding: const EdgeInsets.only(
                            top: AppTheme.spXs, bottom: 100),
                        itemCount: allResults.length + (_apiLoading ? 1 : 0),
                        itemBuilder: (_, i) {
                          if (i == allResults.length) {
                            return Padding(
                              padding: const EdgeInsets.all(AppTheme.spXl),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const SizedBox(
                                      width: 14, height: 14,
                                      child: CircularProgressIndicator(
                                          strokeWidth: 2,
                                          color: AppTheme.stone)),
                                  const SizedBox(width: AppTheme.spXs),
                                  Text(l10n.captureApiLoading,
                                      style: const TextStyle(
                                          fontSize: 13, color: AppTheme.steel)),
                                ],
                              ),
                            );
                          }
                          final e = allResults[i];
                          return _ResultTile(
                            entry: e,
                            added: _isAdded(e.food.name),
                            onAdd: () => _add(e.food),
                          );
                        },
                      ),
          ),
        ],
      ),

      floatingActionButton: _selected.isEmpty
          ? null
          : FloatingActionButton.extended(
              onPressed: _analyze,
              backgroundColor: AppTheme.primary,
              foregroundColor: AppTheme.canvas,
              extendedPadding: const EdgeInsets.symmetric(horizontal: 28),
              shape: const StadiumBorder(),
              icon: const Icon(Icons.analytics_outlined, size: 18),
              label: Text(
                l10n.captureAnalyzeButton(_selected.length),
                style: const TextStyle(
                    fontSize: 14, fontWeight: FontWeight.w700, letterSpacing: -0.14),
              ),
            ),
    );
  }
}

// ── Manual entry bottom sheet ─────────────────────────────────────────────────
class _ManualEntrySheet extends StatefulWidget {
  final String prefillName;
  final int prefillKcal;
  final int prefillServing;
  final ValueChanged<FoodResult> onAdd;
  const _ManualEntrySheet({
    required this.prefillName,
    required this.prefillKcal,
    required this.prefillServing,
    required this.onAdd,
  });

  @override
  State<_ManualEntrySheet> createState() => _ManualEntrySheetState();
}

class _ManualEntrySheetState extends State<_ManualEntrySheet> {
  late final TextEditingController _nameCtrl;
  late final TextEditingController _kcalCtrl;
  late final TextEditingController _servingCtrl;
  String? _kcalError;

  @override
  void initState() {
    super.initState();
    _nameCtrl    = TextEditingController(text: widget.prefillName);
    _kcalCtrl    = TextEditingController(
        text: widget.prefillKcal > 0 ? widget.prefillKcal.toString() : '');
    _servingCtrl = TextEditingController(text: widget.prefillServing.toString());
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _kcalCtrl.dispose();
    _servingCtrl.dispose();
    super.dispose();
  }

  void _applyGuide(String range) {
    final parts = range.split('~');
    if (parts.length == 2) {
      final mid = ((int.tryParse(parts[0]) ?? 0) +
              (int.tryParse(parts[1]) ?? 0)) ~/
          2;
      setState(() {
        _kcalCtrl.text = mid.toString();
        _kcalError = null;
      });
    }
  }

  void _confirm() {
    final name    = _nameCtrl.text.trim();
    final kcal    = int.tryParse(_kcalCtrl.text.trim());
    final serving = int.tryParse(_servingCtrl.text.trim()) ?? 200;

    if (name.isEmpty) return;
    if (kcal == null || kcal <= 0) {
      setState(() => _kcalError = '칼로리를 입력해주세요');
      return;
    }

    widget.onAdd(FoodResult(
      name: name,
      kcalPer100g: kcal * 100.0 / serving,
      proteinPer100g: 0,
      carbsPer100g: 0,
      fatPer100g: 0,
      defaultServingG: serving,
    ));
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;

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
          const Text('직접 추가',
              style: TextStyle(
                  fontSize: 20, fontWeight: FontWeight.w700,
                  color: AppTheme.inkDeep, letterSpacing: -0.5)),
          const SizedBox(height: AppTheme.spXl),

          // 음식 이름
          _label('음식 이름'),
          const SizedBox(height: AppTheme.spXs),
          TextField(
            controller: _nameCtrl,
            textInputAction: TextInputAction.next,
            style: const TextStyle(fontSize: 14, color: AppTheme.inkDeep),
            decoration: _fieldDecor(hint: '예) 닭갈비, 된장찌개'),
          ),
          const SizedBox(height: AppTheme.spXl),

          // 칼로리 + 1인분
          Row(
            children: [
              Expanded(
                flex: 3,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _label('칼로리 (kcal)'),
                    const SizedBox(height: AppTheme.spXs),
                    TextField(
                      controller: _kcalCtrl,
                      keyboardType: TextInputType.number,
                      textInputAction: TextInputAction.next,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      onChanged: (_) => setState(() => _kcalError = null),
                      style: const TextStyle(
                          fontSize: 14, color: AppTheme.inkDeep),
                      decoration: _fieldDecor(
                        hint: '예) 350',
                        errorText: _kcalError,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: AppTheme.spMd),
              Expanded(
                flex: 2,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _label('1인분 (g)'),
                    const SizedBox(height: AppTheme.spXs),
                    TextField(
                      controller: _servingCtrl,
                      keyboardType: TextInputType.number,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      style: const TextStyle(
                          fontSize: 14, color: AppTheme.inkDeep),
                      decoration: _fieldDecor(suffixText: 'g'),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: AppTheme.spXl),

          // 칼로리 가이드 칩 (수평 스크롤)
          _label('카테고리 참고 칼로리 탭해서 입력'),
          const SizedBox(height: AppTheme.spXs),
          SizedBox(
            height: 34,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: _calGuide.length,
              separatorBuilder: (context2, idx) => const SizedBox(width: 6),
              itemBuilder: (_, i) {
                final (catLabel, range) = _calGuide[i];
                return GestureDetector(
                  onTap: () => _applyGuide(range),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: AppTheme.surfaceSoft,
                      borderRadius: BorderRadius.circular(AppTheme.rFull),
                      border: Border.all(color: AppTheme.hairline),
                    ),
                    child: Text('$catLabel  $range',
                        style: const TextStyle(
                            fontSize: 12, fontWeight: FontWeight.w600,
                            color: AppTheme.ink)),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: AppTheme.spXxl),

          SizedBox(
            width: double.infinity,
            height: 52,
            child: FilledButton(
              onPressed: _confirm,
              style: FilledButton.styleFrom(
                backgroundColor: AppTheme.primary,
                shape: const StadiumBorder(),
                textStyle: const TextStyle(
                    fontSize: 15, fontWeight: FontWeight.w700),
              ),
              child: const Text('추가하기'),
            ),
          ),
        ],
      ),
    );
  }

  static Widget _label(String text) => Text(text,
      style: const TextStyle(
          fontSize: 12, fontWeight: FontWeight.w700,
          color: AppTheme.stone, letterSpacing: 0.3));

  static InputDecoration _fieldDecor({
    String? hint,
    String? suffixText,
    String? errorText,
  }) =>
      InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(color: AppTheme.stone),
        suffixText: suffixText,
        errorText: errorText,
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
      );
}

// ── Photo zone ────────────────────────────────────────────────────────────────
class _PhotoZone extends StatelessWidget {
  final File? photo;
  final VoidCallback onCamera;
  final VoidCallback onGallery;
  final VoidCallback onRetake;
  const _PhotoZone({
    required this.photo, required this.onCamera,
    required this.onGallery, required this.onRetake,
  });

  @override
  Widget build(BuildContext context) {
    if (photo != null) {
      return Container(
        color: AppTheme.canvas,
        padding: const EdgeInsets.fromLTRB(
            AppTheme.spBase, AppTheme.spMd, AppTheme.spBase, 0),
        child: Stack(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(AppTheme.rXxl),
              child: Image.file(photo!,
                  height: 160, width: double.infinity, fit: BoxFit.cover),
            ),
            Positioned(
              top: AppTheme.spMd, right: AppTheme.spMd,
              child: GestureDetector(
                onTap: onRetake,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: AppTheme.inkDeep.withValues(alpha: 0.75),
                    borderRadius: BorderRadius.circular(AppTheme.rFull),
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.camera_alt_outlined,
                          size: 13, color: AppTheme.canvas),
                      SizedBox(width: 4),
                      Text('다시 찍기',
                          style: TextStyle(
                              fontSize: 12, fontWeight: FontWeight.w700,
                              color: AppTheme.canvas)),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    }

    return Container(
      color: AppTheme.canvas,
      padding: const EdgeInsets.fromLTRB(
          AppTheme.spBase, AppTheme.spMd, AppTheme.spBase, 0),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: GestureDetector(
              onTap: onCamera,
              child: Container(
                height: 120,
                decoration: BoxDecoration(
                  color: AppTheme.inkDeep,
                  borderRadius: BorderRadius.circular(AppTheme.rXxl),
                ),
                child: const Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.camera_alt_outlined,
                        size: 32, color: AppTheme.canvas),
                    SizedBox(height: 8),
                    Text('촬영하기',
                        style: TextStyle(
                            fontSize: 15, fontWeight: FontWeight.w700,
                            color: AppTheme.canvas)),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(width: AppTheme.spMd),
          Expanded(
            flex: 2,
            child: GestureDetector(
              onTap: onGallery,
              child: Container(
                height: 120,
                decoration: BoxDecoration(
                  color: AppTheme.surfaceSoft,
                  borderRadius: BorderRadius.circular(AppTheme.rXxl),
                  border: Border.all(color: AppTheme.hairline),
                ),
                child: const Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.photo_library_outlined,
                        size: 28, color: AppTheme.inkDeep),
                    SizedBox(height: 8),
                    Text('갤러리',
                        style: TextStyle(
                            fontSize: 14, fontWeight: FontWeight.w700,
                            color: AppTheme.inkDeep)),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Selected chips ────────────────────────────────────────────────────────────
class _ChipsBar extends StatelessWidget {
  final List<SelectedFood> foods;
  final ValueChanged<int> onRemove;
  const _ChipsBar({required this.foods, required this.onRemove});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Container(
      color: AppTheme.canvas,
      padding: const EdgeInsets.fromLTRB(
          AppTheme.spBase, AppTheme.spXs, AppTheme.spBase, AppTheme.spXs),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(l10n.captureSelectedLabel,
              style: const TextStyle(
                  fontSize: 11, fontWeight: FontWeight.w700,
                  color: AppTheme.stone, letterSpacing: 0.5)),
          const SizedBox(height: 6),
          Wrap(
            spacing: 6,
            runSpacing: 4,
            children: foods.asMap().entries.map((e) {
              final f = e.value;
              final kcal = (f.source.kcalPer100g * f.servingG / 100).round();
              return Chip(
                label: Text(
                    '${f.source.name}  ${kcal}kcal',
                    style: const TextStyle(
                        fontSize: 12, fontWeight: FontWeight.w700,
                        color: AppTheme.inkDeep)),
                deleteIcon: const Icon(Icons.close, size: 13),
                onDeleted: () => onRemove(e.key),
                backgroundColor: AppTheme.success.withValues(alpha: 0.1),
                deleteIconColor: AppTheme.steel,
                side: BorderSide(
                    color: AppTheme.success.withValues(alpha: 0.3), width: 1),
                shape: const StadiumBorder(),
                padding: const EdgeInsets.symmetric(
                    horizontal: AppTheme.spXs, vertical: 0),
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}

// ── Empty state with quick-add categories ─────────────────────────────────────
class _EmptyWithQuickAdd extends StatelessWidget {
  final bool hasPhoto;
  final VoidCallback onManualAdd;
  final ValueChanged<_QuickCat> onCategoryTap;

  const _EmptyWithQuickAdd({
    required this.hasPhoto,
    required this.onManualAdd,
    required this.onCategoryTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(
          AppTheme.spBase, AppTheme.spXl, AppTheme.spBase, 100),
      children: [
        // 검색 유도 텍스트
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppTheme.spXs),
          child: Text(
            hasPhoto ? '사진 속 음식을 검색하세요' : '음식명으로 검색하거나\n아래에서 바로 추가하세요',
            textAlign: TextAlign.center,
            style: const TextStyle(
                fontSize: 14, color: AppTheme.steel, height: 1.5),
          ),
        ),
        const SizedBox(height: AppTheme.spXl),

        // 구분선
        Row(
          children: [
            const Expanded(child: Divider()),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppTheme.spBase),
              child: Text('빠른 직접 추가',
                  style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: AppTheme.stone.withValues(alpha: 0.8),
                      letterSpacing: 0.5)),
            ),
            const Expanded(child: Divider()),
          ],
        ),
        const SizedBox(height: AppTheme.spBase),

        // 카테고리 2열 그리드
        GridView.builder(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            mainAxisSpacing: AppTheme.spXs,
            crossAxisSpacing: AppTheme.spXs,
            childAspectRatio: 1.05,
          ),
          itemCount: _quickCats.length,
          itemBuilder: (_, i) {
            final cat = _quickCats[i];
            return GestureDetector(
              onTap: () => onCategoryTap(cat),
              child: Container(
                decoration: BoxDecoration(
                  color: AppTheme.canvas,
                  borderRadius: BorderRadius.circular(AppTheme.rXl),
                  border: Border.all(color: AppTheme.hairlineSoft),
                ),
                padding: const EdgeInsets.symmetric(
                    vertical: AppTheme.spMd, horizontal: AppTheme.spXs),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(cat.emoji,
                        style: const TextStyle(fontSize: 26)),
                    const SizedBox(height: 6),
                    Text(cat.name,
                        textAlign: TextAlign.center,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            color: AppTheme.inkDeep)),
                    const SizedBox(height: 3),
                    Text('약 ${cat.kcal}kcal',
                        style: const TextStyle(
                            fontSize: 11, color: AppTheme.steel)),
                  ],
                ),
              ),
            );
          },
        ),
        const SizedBox(height: AppTheme.spXl),

        // 직접 입력 버튼 (이름 직접 치고 싶을 때)
        OutlinedButton.icon(
          onPressed: onManualAdd,
          style: OutlinedButton.styleFrom(
            foregroundColor: AppTheme.inkDeep,
            side: const BorderSide(color: AppTheme.hairline, width: 1.5),
            shape: const StadiumBorder(),
            minimumSize: const Size.fromHeight(48),
            textStyle: const TextStyle(
                fontSize: 13, fontWeight: FontWeight.w700, letterSpacing: -0.1),
          ),
          icon: const Icon(Icons.edit_outlined, size: 16),
          label: const Text('음식 이름 직접 입력'),
        ),
      ],
    );
  }
}

// ── Result tile ───────────────────────────────────────────────────────────────
class _Entry {
  final FoodResult food;
  final bool fromApi;
  const _Entry({required this.food, required this.fromApi});
}

class _ResultTile extends StatelessWidget {
  final _Entry entry;
  final bool added;
  final VoidCallback onAdd;
  const _ResultTile({required this.entry, required this.added, required this.onAdd});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final f = entry.food;
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      margin: const EdgeInsets.fromLTRB(
          AppTheme.spBase, 0, AppTheme.spBase, AppTheme.spXs),
      decoration: BoxDecoration(
        color: added
            ? AppTheme.success.withValues(alpha: 0.07)
            : AppTheme.canvas,
        borderRadius: BorderRadius.circular(AppTheme.rXl),
        border: Border.all(
          color: added
              ? AppTheme.success.withValues(alpha: 0.35)
              : AppTheme.hairlineSoft,
        ),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.fromLTRB(
            AppTheme.spXl, AppTheme.spXs, AppTheme.spMd, AppTheme.spXs),
        title: Row(
          children: [
            Expanded(
              child: Text(f.name,
                  style: const TextStyle(
                      fontSize: 14, fontWeight: FontWeight.w700,
                      color: AppTheme.inkDeep, letterSpacing: -0.14)),
            ),
            if (entry.fromApi) ...[
              const SizedBox(width: 6),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: AppTheme.warning.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(AppTheme.rFull),
                ),
                child: Text(l10n.captureApiLabel,
                    style: const TextStyle(
                        fontSize: 10, color: AppTheme.attention,
                        fontWeight: FontWeight.w700)),
              ),
            ],
          ],
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 2),
          child: Text(
            '${l10n.captureKcalPer100g(f.kcalPer100g.round())}  ·  '
            '${l10n.captureDefaultServing(f.defaultServingG)}',
            style: const TextStyle(fontSize: 12, color: AppTheme.steel),
          ),
        ),
        trailing: AnimatedSwitcher(
          duration: const Duration(milliseconds: 200),
          transitionBuilder: (child, anim) =>
              ScaleTransition(scale: anim, child: child),
          child: added
              ? const Icon(Icons.check_circle,
                  key: ValueKey('check'),
                  color: AppTheme.success, size: 26)
              : IconButton(
                  key: const ValueKey('add'),
                  icon: const Icon(Icons.add_circle_outline,
                      color: AppTheme.primary, size: 26),
                  onPressed: onAdd,
                ),
        ),
      ),
    );
  }
}

// ── No result ─────────────────────────────────────────────────────────────────
class _NoResult extends StatelessWidget {
  final String query;
  final VoidCallback onManualAdd;
  const _NoResult({required this.query, required this.onManualAdd});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: AppTheme.spXxl),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 64, height: 64,
              decoration: BoxDecoration(
                color: AppTheme.surfaceSoft,
                borderRadius: BorderRadius.circular(AppTheme.rXxl),
              ),
              child: const Icon(Icons.no_meals_outlined,
                  size: 30, color: AppTheme.stone),
            ),
            const SizedBox(height: AppTheme.spXl),
            Text(l10n.captureNoResult(query),
                textAlign: TextAlign.center,
                style: const TextStyle(
                    fontSize: 15, fontWeight: FontWeight.w700,
                    color: AppTheme.inkDeep)),
            const SizedBox(height: AppTheme.spXs),
            Text(l10n.captureNoResultHint,
                style: const TextStyle(fontSize: 13, color: AppTheme.steel)),
            const SizedBox(height: AppTheme.spXxl),
            SizedBox(
              width: double.infinity,
              height: 52,
              child: FilledButton.icon(
                onPressed: onManualAdd,
                style: FilledButton.styleFrom(
                  backgroundColor: AppTheme.inkButton,
                  foregroundColor: AppTheme.canvas,
                  shape: const StadiumBorder(),
                  textStyle: const TextStyle(
                      fontSize: 14, fontWeight: FontWeight.w700,
                      letterSpacing: -0.14),
                ),
                icon: const Icon(Icons.add, size: 18),
                label: Text('"$query" 직접 추가하기'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
