import 'package:shared_preferences/shared_preferences.dart';
import '../../domain/entities/user_role.dart';
import '../models/onboarding_page_model.dart';
import '../../../../core/constants/app_constants.dart';

abstract class OnboardingLocalDataSource {
  Future<List<OnboardingPageModel>> getOnboardingPages();
  Future<bool> isOnboardingCompleted();
  Future<void> setOnboardingCompleted(bool completed);
  Future<void> saveUserRole(UserRoleType roleType);
  Future<UserRoleType?> getUserRole();
  Future<void> saveOnboardingProgress(int currentPage);
  Future<int> getOnboardingProgress();
  Future<bool> isFirstLaunch();
  Future<void> setFirstLaunchCompleted();
  Future<void> clearOnboardingData();
}

class OnboardingLocalDataSourceImpl implements OnboardingLocalDataSource {
  final SharedPreferences sharedPreferences;

  OnboardingLocalDataSourceImpl({required this.sharedPreferences});

  @override
  Future<List<OnboardingPageModel>> getOnboardingPages() async {
    // Return predefined onboarding pages
    return [
      const OnboardingPageModel(
        id: 'welcome',
        titleKey: 'welcomeTitle',
        descriptionKey: 'welcomeSubtitle',
        imagePath: 'assets/images/welcome.png',
        animationPath: 'assets/animations/welcome.json',
        metadata: {'isWelcome': true},
      ),
      const OnboardingPageModel(
        id: 'medical_card',
        titleKey: 'medicalCardTitle',
        descriptionKey: 'medicalCardDescription',
        imagePath: 'assets/images/medical_card.png',
        animationPath: 'assets/animations/medical_card.json',
      ),
      const OnboardingPageModel(
        id: 'reminders',
        titleKey: 'remindersTitle',
        descriptionKey: 'remindersDescription',
        imagePath: 'assets/images/reminders.png',
        animationPath: 'assets/animations/reminders.json',
      ),
      const OnboardingPageModel(
        id: 'multi_language',
        titleKey: 'multiLanguageTitle',
        descriptionKey: 'multiLanguageDescription',
        imagePath: 'assets/images/multi_language.png',
        animationPath: 'assets/animations/multi_language.json',
      ),
      const OnboardingPageModel(
        id: 'offline',
        titleKey: 'offlineTitle',
        descriptionKey: 'offlineDescription',
        imagePath: 'assets/images/offline.png',
        animationPath: 'assets/animations/offline.json',
      ),
      const OnboardingPageModel(
        id: 'get_started',
        titleKey: 'getStartedTitle',
        descriptionKey: 'getStartedDescription',
        imagePath: 'assets/images/last_onboard.png',
        metadata: {'isLastPage': true, 'navigateTo': '/login'},
      ),
    ];
  }

  @override
  Future<bool> isOnboardingCompleted() async {
    return sharedPreferences.getBool(AppConstants.onboardingCompletedKey) ?? false;
  }

  @override
  Future<void> setOnboardingCompleted(bool completed) async {
    await sharedPreferences.setBool(AppConstants.onboardingCompletedKey, completed);
  }

  @override
  Future<void> saveUserRole(UserRoleType roleType) async {
    await sharedPreferences.setString(AppConstants.userRoleKey, roleType.name);
  }

  @override
  Future<UserRoleType?> getUserRole() async {
    final roleString = sharedPreferences.getString(AppConstants.userRoleKey);
    if (roleString == null) return null;
    
    return UserRoleType.values.firstWhere(
      (role) => role.name == roleString,
      orElse: () => UserRoleType.patient,
    );
  }

  @override
  Future<void> saveOnboardingProgress(int currentPage) async {
    await sharedPreferences.setInt('onboarding_progress', currentPage);
  }

  @override
  Future<int> getOnboardingProgress() async {
    return sharedPreferences.getInt('onboarding_progress') ?? 0;
  }

  @override
  Future<bool> isFirstLaunch() async {
    return !(sharedPreferences.getBool(AppConstants.firstLaunchKey) ?? false);
  }

  @override
  Future<void> setFirstLaunchCompleted() async {
    await sharedPreferences.setBool(AppConstants.firstLaunchKey, true);
  }

  @override
  Future<void> clearOnboardingData() async {
    await sharedPreferences.remove(AppConstants.onboardingCompletedKey);
    await sharedPreferences.remove(AppConstants.userRoleKey);
    await sharedPreferences.remove('onboarding_progress');
    await sharedPreferences.remove(AppConstants.firstLaunchKey);
  }
}