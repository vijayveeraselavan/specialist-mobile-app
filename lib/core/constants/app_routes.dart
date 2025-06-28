class AppRoutes {
  // Private constructor
  AppRoutes._();

  // Root Routes
  static const String splash = '/';
  static const String secondSplash = '/second-splash';
  static const String onboarding = '/onboarding';
  static const String roleSelection = '/role-selection';
  static const String home = '/home';

  // Auth Routes
  static const String login = '/login';
  static const String register = '/register';
  static const String accountCreation = '/account-creation';
  static const String confirmLogin = '/confirm-login';
  static const String fileOnboard = '/file-onboard';
  static const String forgotPassword = '/forgot-password';
  static const String resetPassword = '/reset-password';

  // Medical File Routes
  static const String createMedicalFile = '/create-medical-file';

  // Patient Routes
  static const String patientDashboard = '/patient/dashboard';
  static const String patientProfile = '/patient/profile';
  static const String medicalRecords = '/patient/medical-records';
  static const String appointments = '/patient/appointments';
  static const String medications = '/patient/medications';
  static const String reminders = '/patient/reminders';

  // Specialist Routes
  static const String specialistDashboard = '/specialist/dashboard';
  static const String specialistProfile = '/specialist/profile';
  static const String patientList = '/specialist/patients';
  static const String patientDetails = '/specialist/patient-details';
  static const String prescriptions = '/specialist/prescriptions';
  static const String schedules = '/specialist/schedules';

  // Settings Routes
  static const String settings = '/settings';
  static const String languageSettings = '/settings/language';
  static const String themeSettings = '/settings/theme';
  static const String privacySettings = '/settings/privacy';
  static const String notificationSettings = '/settings/notifications';

  // Support Routes
  static const String help = '/help';
  static const String about = '/about';
  static const String privacyPolicy = '/privacy-policy';
  static const String termsOfService = '/terms-of-service';
  static const String contact = '/contact';

  // Error Routes
  static const String error = '/error';
  static const String notFound = '/not-found';

  // Deep Link Routes
  static const String shareRecord = '/share-record';
  static const String appointmentDetails = '/appointment-details';
  static const String medicationReminder = '/medication-reminder';

  // Route Parameters
  static const String patientIdParam = 'patientId';
  static const String appointmentIdParam = 'appointmentId';
  static const String recordIdParam = 'recordId';
  static const String medicationIdParam = 'medicationId';
  static const String reminderIdParam = 'reminderId';

  // Route Names (for analytics and navigation)
  static const Map<String, String> routeNames = {
    splash: 'First Splash',
    secondSplash: 'Second Splash',
    onboarding: 'Onboarding',
    roleSelection: 'Role Selection',
    home: 'Home',
    login: 'Login',
    register: 'Register',
    patientDashboard: 'Patient Dashboard',
    specialistDashboard: 'Specialist Dashboard',
    settings: 'Settings',
    help: 'Help',
    about: 'About',
  };

  // Protected Routes (require authentication)
  static const List<String> protectedRoutes = [
    patientDashboard,
    patientProfile,
    medicalRecords,
    appointments,
    medications,
    reminders,
    specialistDashboard,
    specialistProfile,
    patientList,
    patientDetails,
    prescriptions,
    schedules,
    settings,
  ];

  // Guest Routes (accessible without authentication)
  static const List<String> guestRoutes = [
    splash,
    secondSplash,
    onboarding,
    roleSelection,
    login,
    register,
    forgotPassword,
    resetPassword,
    help,
    about,
    privacyPolicy,
    termsOfService,
  ];
}