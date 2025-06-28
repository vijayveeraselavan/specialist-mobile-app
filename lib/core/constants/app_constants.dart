class AppConstants {
  // Private constructor
  AppConstants._();

  // App Information
  static const String appName = 'VitalLink';
  static const String appVersion = '1.0.0';
  
  // Storage Keys
  static const String onboardingCompletedKey = 'onboarding_completed';
  static const String userRoleKey = 'user_role';
  static const String themePreferenceKey = 'theme_preference';
  static const String languagePreferenceKey = 'language_preference';
  static const String firstLaunchKey = 'first_launch';

  // Animation Durations
  static const Duration shortAnimation = Duration(milliseconds: 300);
  static const Duration mediumAnimation = Duration(milliseconds: 500);
  static const Duration longAnimation = Duration(milliseconds: 800);

  // Layout Constants
  static const double defaultPadding = 16.0;
  static const double smallPadding = 8.0;
  static const double largePadding = 24.0;
  static const double extraLargePadding = 32.0;

  static const double defaultRadius = 12.0;
  static const double smallRadius = 8.0;
  static const double largeRadius = 16.0;
  static const double extraLargeRadius = 24.0;

  // Responsive Breakpoints
  static const double mobileBreakpoint = 600;
  static const double tabletBreakpoint = 900;
  static const double desktopBreakpoint = 1200;

  // User Roles
  static const String patientRole = 'patient';
  static const String specialistRole = 'specialist';

  // API Constants
  static const String baseUrl = 'https://api.vitallink.com';
  static const Duration apiTimeout = Duration(seconds: 30);

  // Onboarding
  static const int onboardingScreensCount = 5;
  static const Duration onboardingAutoAdvance = Duration(seconds: 5);

  // Hive Box Names
  static const String userBoxName = 'user_box';
  static const String settingsBoxName = 'settings_box';
  static const String cacheBoxName = 'cache_box';

  // Default Values
  static const String defaultLanguage = 'en';
  static const String defaultTheme = 'system';

  // Validation
  static const int minPasswordLength = 8;
  static const int maxPasswordLength = 50;
  static const int minNameLength = 2;
  static const int maxNameLength = 50;

  // Error Messages
  static const String networkErrorMessage = 'Network connection error';
  static const String timeoutErrorMessage = 'Request timeout';
  static const String unknownErrorMessage = 'An unknown error occurred';

  // Success Messages
  static const String onboardingCompletedMessage = 'Onboarding completed successfully';
  static const String roleSelectedMessage = 'Role selected successfully';

  // Feature Flags
  static const bool enableBiometricAuth = true;
  static const bool enablePushNotifications = true;
  static const bool enableAnalytics = false;
  static const bool enableOfflineMode = true;

  // Limits
  static const int maxRetryAttempts = 3;
  static const int maxFileSize = 10 * 1024 * 1024; // 10MB
  static const int maxImageQuality = 85;

  // URLs
  static const String privacyPolicyUrl = 'https://vitallink.com/privacy';
  static const String termsOfServiceUrl = 'https://vitallink.com/terms';
  static const String supportUrl = 'https://vitallink.com/support';
  static const String aboutUrl = 'https://vitallink.com/about';
}