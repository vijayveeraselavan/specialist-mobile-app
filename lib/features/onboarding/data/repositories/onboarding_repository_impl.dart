import '../../domain/entities/onboarding_page.dart';
import '../../domain/entities/user_role.dart';
import '../../domain/repositories/onboarding_repository.dart';
import '../datasources/onboarding_local_data_source.dart';

class OnboardingRepositoryImpl implements OnboardingRepository {
  final OnboardingLocalDataSource localDataSource;

  OnboardingRepositoryImpl({required this.localDataSource});

  @override
  Future<List<OnboardingPage>> getOnboardingPages() async {
    final pages = await localDataSource.getOnboardingPages();
    return pages.map((model) => model as OnboardingPage).toList();
  }

  @override
  Future<List<UserRole>> getAvailableRoles() async {
    return UserRole.availableRoles;
  }

  @override
  Future<bool> isOnboardingCompleted() async {
    return await localDataSource.isOnboardingCompleted();
  }

  @override
  Future<void> completeOnboarding() async {
    await localDataSource.setOnboardingCompleted(true);
    await localDataSource.setFirstLaunchCompleted();
  }

  @override
  Future<void> saveUserRole(UserRoleType roleType) async {
    await localDataSource.saveUserRole(roleType);
  }

  @override
  Future<UserRoleType?> getUserRole() async {
    return await localDataSource.getUserRole();
  }

  @override
  Future<void> resetOnboarding() async {
    await localDataSource.clearOnboardingData();
  }

  @override
  Future<void> saveOnboardingProgress(int currentPage) async {
    await localDataSource.saveOnboardingProgress(currentPage);
  }

  @override
  Future<int> getOnboardingProgress() async {
    return await localDataSource.getOnboardingProgress();
  }

  @override
  Future<bool> isFirstLaunch() async {
    return await localDataSource.isFirstLaunch();
  }

  @override
  Future<void> setFirstLaunchCompleted() async {
    await localDataSource.setFirstLaunchCompleted();
  }
}