import 'package:flutter/material.dart';

class AppTheme {
  // ── Meta Design System Color Tokens ────────────────────────────────────────
  static const Color primary     = Color(0xFF0064E0); // cobalt – action CTA
  static const Color primaryDeep = Color(0xFF0457CB); // pressed state
  static const Color primarySoft = Color(0xFF0091FF); // tint / info
  static const Color inkButton   = Color(0xFF000000); // marketing primary
  static const Color canvas      = Color(0xFFFFFFFF); // page background
  static const Color surfaceSoft = Color(0xFFF1F4F7); // subtle surface
  static const Color inkDeep     = Color(0xFF0A1317); // primary headline/text
  static const Color ink         = Color(0xFF1C1E21); // standard body text
  static const Color charcoal    = Color(0xFF444950); // tertiary text
  static const Color steel       = Color(0xFF5D6C7B); // quiet caption
  static const Color stone       = Color(0xFF8595A4); // disabled / de-em
  static const Color hairline    = Color(0xFFCED0D4); // 1px input border
  static const Color hairlineSoft= Color(0xFFDEE3E9); // card divider
  static const Color success     = Color(0xFF31A24C); // good / in-stock
  static const Color attention   = Color(0xFFF2A918); // caution
  static const Color warning     = Color(0xFFF7B928); // promo / warning
  static const Color critical    = Color(0xFFE41E3F); // error / adjust
  static const Color criticalStrong = Color(0xFFF0284A); // form error

  // ── Legacy aliases (used in constants / judge logic) ───────────────────────
  static const Color primary_   = primary;     // keep compat
  static const Color primaryLight = Color(0xFFE8F2FF); // cobalt 8% tint
  static const Color danger     = critical;
  static const Color textMain   = inkDeep;
  static const Color textSub    = steel;
  static const Color bg         = surfaceSoft;
  static const Color card       = canvas;
  static const Color border     = hairlineSoft;

  // ── Border Radius Tokens ────────────────────────────────────────────────────
  static const double rFull    = 100; // pill buttons / badges / chips
  static const double rXxxl    = 32;  // photographic cards
  static const double rXxl     = 24;  // warranty / accessory tiles
  static const double rXl      = 16;  // standard feature cards
  static const double rLg      = 8;   // form inputs / radio options
  static const double rMd      = 6;
  static const double rSm      = 4;

  // ── Spacing Tokens ──────────────────────────────────────────────────────────
  static const double spXs   = 8;
  static const double spSm   = 10;
  static const double spMd   = 12;
  static const double spBase = 16;
  static const double spLg   = 20;
  static const double spXl   = 24;
  static const double spXxl  = 32;

  // ── ThemeData ───────────────────────────────────────────────────────────────
  static ThemeData get light => ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: primary,
          primary: primary,
          surface: canvas,
        ),
        scaffoldBackgroundColor: surfaceSoft,

        // AppBar — stark white, hairline-soft bottom border, no elevation
        appBarTheme: AppBarTheme(
          backgroundColor: canvas,
          foregroundColor: inkDeep,
          elevation: 0,
          shadowColor: Colors.transparent,
          centerTitle: true,
          surfaceTintColor: Colors.transparent,
          titleTextStyle: const TextStyle(
            color: inkDeep,
            fontSize: 17,
            fontWeight: FontWeight.w700,
            letterSpacing: -0.14,
          ),
          shape: Border(
            bottom: BorderSide(color: hairlineSoft, width: 1),
          ),
        ),

        // Card — canvas, xxxl rounding, hairline-soft border, flat
        cardTheme: CardThemeData(
          color: canvas,
          elevation: 0,
          margin: EdgeInsets.zero,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(rXxl),
            side: const BorderSide(color: hairlineSoft),
          ),
        ),

        // FilledButton — black pill (marketing CTA)
        filledButtonTheme: FilledButtonThemeData(
          style: FilledButton.styleFrom(
            backgroundColor: inkButton,
            foregroundColor: canvas,
            minimumSize: const Size.fromHeight(52),
            shape: const StadiumBorder(),
            textStyle: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              letterSpacing: -0.14,
            ),
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 14),
          ),
        ),

        // OutlinedButton — ghost secondary
        outlinedButtonTheme: OutlinedButtonThemeData(
          style: OutlinedButton.styleFrom(
            foregroundColor: inkDeep,
            side: const BorderSide(color: inkDeep, width: 2),
            minimumSize: const Size.fromHeight(52),
            shape: const StadiumBorder(),
            textStyle: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              letterSpacing: -0.14,
            ),
            padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 12),
          ),
        ),

        // Input — 44px, lg rounding, hairline border → fb-blue focus
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: canvas,
          contentPadding: const EdgeInsets.symmetric(
              horizontal: spBase, vertical: spMd),
          constraints: const BoxConstraints(minHeight: 44),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(rLg),
            borderSide: const BorderSide(color: hairline),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(rLg),
            borderSide: const BorderSide(color: hairline),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(rLg),
            borderSide: const BorderSide(color: Color(0xFF1876F2), width: 2),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(rLg),
            borderSide: const BorderSide(color: criticalStrong),
          ),
          hintStyle: const TextStyle(
              color: steel, fontSize: 14, fontWeight: FontWeight.w400),
        ),

        // Chip — pill, canvas bg, hairline border
        chipTheme: ChipThemeData(
          backgroundColor: canvas,
          selectedColor: inkDeep,
          shape: const StadiumBorder(side: BorderSide(color: hairline)),
          labelStyle: const TextStyle(
              fontSize: 14, fontWeight: FontWeight.w700,
              letterSpacing: -0.14, color: ink),
          secondaryLabelStyle: const TextStyle(
              fontSize: 14, fontWeight: FontWeight.w700,
              letterSpacing: -0.14, color: canvas),
          padding: const EdgeInsets.symmetric(horizontal: spBase, vertical: spXs),
        ),

        // NavigationBar
        navigationBarTheme: NavigationBarThemeData(
          backgroundColor: canvas,
          indicatorColor: surfaceSoft,
          surfaceTintColor: Colors.transparent,
          elevation: 0,
          labelTextStyle: WidgetStateProperty.resolveWith((s) {
            final active = s.contains(WidgetState.selected);
            return TextStyle(
              fontSize: 11,
              fontWeight: active ? FontWeight.w700 : FontWeight.w400,
              color: active ? inkDeep : steel,
            );
          }),
          iconTheme: WidgetStateProperty.resolveWith((s) {
            final active = s.contains(WidgetState.selected);
            return IconThemeData(
                color: active ? inkDeep : steel, size: 22);
          }),
        ),

        dividerColor: hairlineSoft,
        dividerTheme: const DividerThemeData(
            color: hairlineSoft, thickness: 1, space: 1),
      );
}
