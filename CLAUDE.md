# Project Context
한끼판단 - GPT 기반 식단 판단·기록 앱
음식 사진 촬영 또는 텍스트 입력 → GPT-4o 분석 → 칼로리/탄단지/식단 균형 판단 → Firestore 기록

# Goals
- 사진 한 장으로 식단 분석
- GPT가 음식 종류·칼로리·영양 균형 추정
- 식단 판단 결과 저장 및 기록 조회

# Tech Stack
- Framework: Flutter (Dart)
- Backend: Firebase (Firestore)
- AI: OpenAI GPT-4o (Vision + Text)
- State Management: Riverpod (StateNotifierProvider, StreamProvider)
- Router: go_router

# Firebase Setup (잔여 작업)
1. `flutterfire configure --project=<PROJECT_ID> --platforms=android,ios`
2. Firestore 규칙 배포 (MVP: `allow read, write: if true`)

# OpenAI 설정
- `.env` 파일에 `OPENAI_API_KEY=sk-...` 입력 필요
- flutter_dotenv로 로드

# Folder Structure
- lib/core/theme/       : AppTheme
- lib/core/constants/   : AppConstants (mealTypes, judgeLabel 등)
- lib/models/           : MealRecord, FoodItem, AnalysisResult
- lib/repositories/     : MealRepository (Firestore CRUD)
- lib/providers/        : providers.dart (Riverpod 전체)
- lib/router/           : app_router.dart (go_router 4개 라우트)
- lib/screens/          : home, capture, analysis, history
- lib/services/         : OpenAIService (GPT-4o Vision/Text)

# Routes
- `/`           : HomeScreen (오늘 식단 요약 + FAB)
- `/history`    : HistoryScreen (날짜별 기록)
- `/capture`    : CaptureScreen (사진/텍스트 입력)
- `/analysis`   : AnalysisScreen (GPT 결과 + 저장)

# Key Providers
- `todayMealsProvider`        : 오늘 식단 스트림
- `analysisProvider`          : GPT 분석 상태 (AnalysisNotifier)
- `saveMealProvider`          : 식단 저장 (SaveMealNotifier)
- `selectedDateProvider`      : 기록 화면 날짜 선택
- `selectedDateMealsProvider` : 선택 날짜 식단 스트림

# Judge Values
- `good` (좋음) / `caution` (주의) / `adjust` (조정 필요)

# Coding Rules
- Dart only, null-safety 준수
- 위젯은 작고 단일 책임 유지
- 불필요한 추상화 금지

# What NOT to do
- Firebase Storage 이미지 업로드 (MVP 범위 외)
- 운동 기록, 커뮤니티, 복잡한 다이어트 플랜
- 불필요한 패키지 추가
