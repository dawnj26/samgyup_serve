import 'package:flutter/widgets.dart';
import 'package:samgyup_serve/l10n/gen/app_localizations.dart';

export 'package:samgyup_serve/l10n/gen/app_localizations.dart';

extension AppLocalizationsX on BuildContext {
  AppLocalizations get l10n => AppLocalizations.of(this);
}
