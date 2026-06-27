import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../models/food_models.dart';
import '../screens/home/home_screen.dart';
import '../screens/capture/capture_screen.dart';
import '../screens/analysis/analysis_screen.dart';
import '../screens/history/history_screen.dart';

final appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    ShellRoute(
      builder: (context, state, child) => _Shell(child: child),
      routes: [
        GoRoute(
          path: '/',
          builder: (context, state) => const HomeScreen(),
        ),
        GoRoute(
          path: '/history',
          builder: (context, state) => const HistoryScreen(),
        ),
      ],
    ),
    GoRoute(
      path: '/capture',
      builder: (context, state) {
        final mealType = state.extra as String?;
        return CaptureScreen(initialMealType: mealType);
      },
    ),
    GoRoute(
      path: '/analysis',
      builder: (context, state) {
        final args = state.extra as Map<String, dynamic>;
        final foods = args['foods'] as List<SelectedFood>;
        final mealType = args['mealType'] as String?;
        return AnalysisScreen(initialFoods: foods, initialMealType: mealType);
      },
    ),
  ],
);

class _Shell extends StatelessWidget {
  final Widget child;
  const _Shell({required this.child});

  @override
  Widget build(BuildContext context) {
    final location = GoRouterState.of(context).uri.path;
    final index = location == '/history' ? 1 : 0;

    return Scaffold(
      body: child,
      bottomNavigationBar: NavigationBar(
        selectedIndex: index,
        onDestinationSelected: (i) {
          if (i == 0) context.go('/');
          if (i == 1) context.go('/history');
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home),
            label: '오늘',
          ),
          NavigationDestination(
            icon: Icon(Icons.calendar_month_outlined),
            selectedIcon: Icon(Icons.calendar_month),
            label: '기록',
          ),
        ],
      ),
    );
  }
}
