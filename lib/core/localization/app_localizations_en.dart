import 'app_localizations.dart';

class AppLocalizationsEn extends AppLocalizations {
  @override
  String get appName => 'VitalLink';

  // Welcome Screen
  @override
  String get welcomeTitle => 'Welcome to VitalLink';
  
  @override
  String get welcomeSubtitle => 
      'Your comprehensive healthcare companion that connects patients and specialists seamlessly.';

  @override
  String get getStartedButton => 'Get Started';

  @override
  String get skipButton => 'Skip';

  @override
  String get nextButton => 'Next';

  @override
  String get backButton => 'Back';

  // Onboarding Screens
  @override
  String get medicalCardTitle => 'Digital Medical Card';
  
  @override
  String get medicalCardDescription => 
      'Access your complete medical history, prescriptions, and health records anytime, anywhere. Keep your vital health information secure and easily accessible.';

  @override
  String get remindersTitle => 'Smart Reminders';
  
  @override
  String get remindersDescription => 
      'Never miss a medication dose or medical appointment again. Get personalized notifications and reminders tailored to your healthcare needs.';

  @override
  String get multiLanguageTitle => 'Multi-Language Support';
  
  @override
  String get multiLanguageDescription => 
      'Communicate with healthcare providers in your preferred language. Breaking down language barriers for better healthcare communication.';

  @override
  String get offlineTitle => 'Offline Access';
  
  @override
  String get offlineDescription => 
      'Access your essential health information even without internet connection. Your health data is always available when you need it most.';

  @override
  String get getStartedTitle => 'Ready to Get Started?';
  
  @override
  String get getStartedDescription => 
      'You\'re all set! Explore your personalized dashboard, manage appointments, track medications, and connect with healthcare providers seamlessly.';

  // Role Selection
  @override
  String get roleSelectionTitle => 'Choose Your Role';
  
  @override
  String get roleSelectionSubtitle => 
      'Select how you\'ll be using VitalLink to personalize your experience.';

  @override
  String get patientRole => 'Patient';
  
  @override
  String get patientRoleDescription => 
      'Manage your health records, medications, and appointments. Connect with healthcare providers.';

  @override
  String get specialistRole => 'Healthcare Specialist';
  
  @override
  String get specialistRoleDescription => 
      'Manage patient records, prescriptions, and provide professional healthcare services.';

  @override
  String get continueButton => 'Continue';

  // Common
  @override
  String get loading => 'Loading...';

  @override
  String get error => 'An error occurred';

  @override
  String get retry => 'Retry';

  @override
  String get done => 'Done';
}