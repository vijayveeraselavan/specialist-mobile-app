import 'app_localizations.dart';

class AppLocalizationsFr extends AppLocalizations {
  @override
  String get appName => 'VitalLink';

  // Welcome Screen
  @override
  String get welcomeTitle => 'Bienvenue sur VitalLink';
  
  @override
  String get welcomeSubtitle => 
      'Votre compagnon de santé complet qui connecte les patients et les spécialistes de manière transparente.';

  @override
  String get getStartedButton => 'Commencer';

  @override
  String get skipButton => 'Passer';

  @override
  String get nextButton => 'Suivant';

  @override
  String get backButton => 'Retour';

  // Onboarding Screens
  @override
  String get medicalCardTitle => 'Carte Médicale Numérique';
  
  @override
  String get medicalCardDescription => 
      'Accédez à votre dossier médical complet, prescriptions et données de santé à tout moment, n\'importe où. Gardez vos informations de santé vitales sécurisées et facilement accessibles.';

  @override
  String get remindersTitle => 'Rappels Intelligents';
  
  @override
  String get remindersDescription => 
      'Ne manquez plus jamais une dose de médicament ou un rendez-vous médical. Recevez des notifications et rappels personnalisés adaptés à vos besoins de santé.';

  @override
  String get multiLanguageTitle => 'Support Multilingue';
  
  @override
  String get multiLanguageDescription => 
      'Communiquez avec les professionnels de santé dans votre langue préférée. Supprimez les barrières linguistiques pour une meilleure communication de santé.';

  @override
  String get offlineTitle => 'Accès Hors Ligne';
  
  @override
  String get offlineDescription => 
      'Accédez à vos informations de santé essentielles même sans connexion internet. Vos données de santé sont toujours disponibles quand vous en avez le plus besoin.';

  @override
  String get getStartedTitle => 'Prêt à Commencer?';
  
  @override
  String get getStartedDescription => 
      'Vous êtes prêt! Explorez votre tableau de bord personnalisé, gérez vos rendez-vous, suivez vos médicaments et connectez-vous avec les professionnels de santé en toute simplicité.';

  // Role Selection
  @override
  String get roleSelectionTitle => 'Choisissez Votre Rôle';
  
  @override
  String get roleSelectionSubtitle => 
      'Sélectionnez comment vous utiliserez VitalLink pour personnaliser votre expérience.';

  @override
  String get patientRole => 'Patient';
  
  @override
  String get patientRoleDescription => 
      'Gérez vos dossiers médicaux, médicaments et rendez-vous. Connectez-vous avec les professionnels de santé.';

  @override
  String get specialistRole => 'Spécialiste de Santé';
  
  @override
  String get specialistRoleDescription => 
      'Gérez les dossiers patients, prescriptions et fournissez des services de santé professionnels.';

  @override
  String get continueButton => 'Continuer';

  // Common
  @override
  String get loading => 'Chargement...';

  @override
  String get error => 'Une erreur s\'est produite';

  @override
  String get retry => 'Réessayer';

  @override
  String get done => 'Terminé';
}