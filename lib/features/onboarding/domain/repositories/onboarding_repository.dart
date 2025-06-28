import '../entities/onboarding_page.dart';
import '../entities/user_role.dart';

abstract class OnboardingRepository {
  /// Get all onboarding pages
  Future<List<OnboardingPage>> getOnboardingPages();
  
  /// Get available user roles
  Future<List<UserRole>> getAvailableRoles();
  
  /// Check if onboarding is completed
  Future<bool> isOnboardingCompleted();
  
  /// Mark onboarding as completed
  Future<void> completeOnboarding();
  
  /// Save selected user role
  Future<void> saveUserRole(UserRoleType roleType);
  
  /// Get saved user role
  Future<UserRoleType?> getUserRole();
  
  /// Reset onboarding state
  Future<void> resetOnboarding();
  
  /// Save onboarding progress
  Future<void> saveOnboardingProgress(int currentPage);
  
  /// Get onboarding progress
  Future<int> getOnboardingProgress();
  
  /// Check if this is first app launch
  Future<bool> isFirstLaunch();
  
  /// Mark first launch as completed
  Future<void> setFirstLaunchCompleted();
}