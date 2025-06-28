import 'package:flutter/material.dart';

import 'app_localizations_en.dart';
import 'app_localizations_fr.dart';

abstract class AppLocalizations {
  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates = [
    delegate,
  ];

  static const List<Locale> supportedLocales = [
    Locale('en'),
    Locale('fr'),
  ];

  // Welcome Screen
  String get welcomeTitle;
  String get welcomeSubtitle;
  String get getStartedButton;
  String get skipButton;
  String get nextButton;
  String get backButton;

  // Onboarding Screens
  String get medicalCardTitle;
  String get medicalCardDescription;
  
  String get remindersTitle;
  String get remindersDescription;
  
  String get multiLanguageTitle;
  String get multiLanguageDescription;
  
  String get offlineTitle;
  String get offlineDescription;
  
  String get getStartedTitle;
  String get getStartedDescription;

  // Role Selection
  String get roleSelectionTitle;
  String get roleSelectionSubtitle;
  String get patientRole;
  String get patientRoleDescription;
  String get specialistRole;
  String get specialistRoleDescription;
  String get continueButton;

  // Common
  String get appName;
  String get loading;
  String get error;
  String get retry;
  String get done;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) {
    return ['en', 'fr'].contains(locale.languageCode);
  }

  @override
  Future<AppLocalizations> load(Locale locale) async {
    switch (locale.languageCode) {
      case 'fr':
        return AppLocalizationsFr();
      case 'en':
      default:
        return AppLocalizationsEn();
    }
  }

  @override
  bool shouldReload(LocalizationsDelegate<AppLocalizations> old) => false;
}