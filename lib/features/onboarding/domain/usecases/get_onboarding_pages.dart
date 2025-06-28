import '../entities/onboarding_page.dart';
import '../repositories/onboarding_repository.dart';

class GetOnboardingPages {
  final OnboardingRepository repository;

  GetOnboardingPages(this.repository);

  Future<List<OnboardingPage>> call() async {
    return await repository.getOnboardingPages();
  }
}