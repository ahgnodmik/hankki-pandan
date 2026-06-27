import 'package:flutter/material.dart';
import 'package:hankki_pandan/l10n/app_localizations.dart';

extension ContextExt on BuildContext {
  AppLocalizations get l10n => AppLocalizations.of(this)!;
}
