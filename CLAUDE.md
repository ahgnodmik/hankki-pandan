# 한끼판단 프로젝트 컨텍스트

## 앱 개요
음식 이름 텍스트 입력 → 영양 분석 → 칼로리/탄단지/식단 균형 판단 → 로컬 저장·기록 조회

## Tech Stack
- Framework: Flutter (Dart), null-safety
- State Management: Riverpod 3.x (AsyncNotifier, NotifierProvider)
- Router: go_router 17.x
- Storage: SharedPreferences (로컬)
- AI/분석: 없음 (규칙 기반 NutritionJudge)
- 광고: google_mobile_ads

## 음식 데이터 소스
1. 로컬 DB: `lib/core/data/food_db.dart` — 한국 음식 60종 하드코딩
2. 공공 API: 식품안전나라 I2790 (`.env`의 `FOOD_API_KEY`로 활성화)
- `.env`가 없거나 키가 비어 있으면 로컬 DB만 동작

## 핵심 파일
- `lib/core/data/food_db.dart` — 로컬 음식 DB 60종
- `lib/core/utils/nutrition_judge.dart` — 규칙 기반 영양 판단 (good/caution/adjust)
- `lib/services/food_search_service.dart` — 로컬 DB + 공공 API 통합 검색
- `lib/models/food_models.dart` — FoodResult, SelectedFood
- `lib/models/meal_record.dart` — DateTime + JSON 직렬화 (Firestore 없음)
- `lib/repositories/meal_repository.dart` — SharedPreferences CRUD
- `lib/providers/providers.dart` — sharedPrefsProvider 포함 전체 Riverpod 프로바이더

## Routes
- `/` : HomeScreen — 오늘 식단 요약 + FAB
- `/history` : HistoryScreen — 날짜별 기록
- `/capture` : CaptureScreen — 텍스트 입력 (사진 분석 없음)
- `/analysis` : AnalysisScreen — 영양 결과 + 섭취량(g) 직접 수정 → 실시간 갱신 + 저장

## Judge Values
- `good` (좋음) / `caution` (주의) / `adjust` (조정 필요)

## Coding Rules
- Dart only, null-safety 준수
- 위젯은 작고 단일 책임 유지
- 불필요한 추상화 금지

## What NOT to do
- Firebase / Firestore / OpenAI 코드 추가 금지 (완전 제거됨)
- 이미지 촬영·업로드 기능 (MVP 범위 외)
- 운동 기록, 커뮤니티, 복잡한 다이어트 플랜
- 불필요한 패키지 추가

