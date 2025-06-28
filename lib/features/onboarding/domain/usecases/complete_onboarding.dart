import '../entities/user_role.dart';
import '../repositories/onboarding_repository.dart';

class CompleteOnboarding {
  final OnboardingRepository repository;

  CompleteOnboarding(this.repository);

  Future<void> call(UserRoleType? selectedRole) async {
    if (selectedRole != null) {
      await repository.saveUserRole(selectedRole);
    }
    await repository.completeOnboarding();
  }
}