import '../repositories/onboarding_repository.dart';
import '../entities/user_role.dart';

class CheckOnboardingStatus {
  final OnboardingRepository repository;

  CheckOnboardingStatus(this.repository);

  Future<OnboardingStatus> call() async {
    final isFirstLaunch = await repository.isFirstLaunch();
    final isCompleted = await repository.isOnboardingCompleted();
    final currentProgress = await repository.getOnboardingProgress();
    final userRole = await repository.getUserRole();

    return OnboardingStatus(
      isFirstLaunch: isFirstLaunch,
      isCompleted: isCompleted,
      currentProgress: currentProgress,
      userRole: userRole,
    );
  }
}

class OnboardingStatus {
  final bool isFirstLaunch;
  final bool isCompleted;
  final int currentProgress;
  final UserRoleType? userRole;

  OnboardingStatus({
    required this.isFirstLaunch,
    required this.isCompleted,
    required this.currentProgress,
    this.userRole,
  });

  bool get shouldShowOnboarding => isFirstLaunch || !isCompleted;
  bool get canResume => currentProgress > 0 && !isCompleted;
}