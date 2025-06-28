import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../features/onboarding/data/datasources/onboarding_local_data_source.dart';
import '../../features/onboarding/data/repositories/onboarding_repository_impl.dart';
import '../../features/onboarding/domain/repositories/onboarding_repository.dart';
import '../../features/onboarding/domain/usecases/get_onboarding_pages.dart';
import '../../features/onboarding/domain/usecases/complete_onboarding.dart';
import '../../features/onboarding/domain/usecases/check_onboarding_status.dart';
import '../../features/onboarding/presentation/providers/onboarding_provider.dart';

class DependencyInjection {
  static late SharedPreferences _sharedPreferences;
  
  static Future<void> init() async {
    _sharedPreferences = await SharedPreferences.getInstance();
  }

  static List<SingleChildWidget> getProviders() {
    return [
      // Data Sources
      Provider<OnboardingLocalDataSource>(
        create: (_) => OnboardingLocalDataSourceImpl(
          sharedPreferences: _sharedPreferences,
        ),
      ),

      // Repositories
      Provider<OnboardingRepository>(
        create: (context) => OnboardingRepositoryImpl(
          localDataSource: context.read<OnboardingLocalDataSource>(),
        ),
      ),

      // Use Cases
      Provider<GetOnboardingPages>(
        create: (context) => GetOnboardingPages(
          context.read<OnboardingRepository>(),
        ),
      ),
      Provider<CompleteOnboarding>(
        create: (context) => CompleteOnboarding(
          context.read<OnboardingRepository>(),
        ),
      ),
      Provider<CheckOnboardingStatus>(
        create: (context) => CheckOnboardingStatus(
          context.read<OnboardingRepository>(),
        ),
      ),

      // Providers
      ChangeNotifierProvider<OnboardingProvider>(
        create: (context) => OnboardingProvider(
          getOnboardingPages: context.read<GetOnboardingPages>(),
          completeOnboarding: context.read<CompleteOnboarding>(),
          checkOnboardingStatus: context.read<CheckOnboardingStatus>(),
        ),
      ),

    ];
  }

  static Widget wrapWithProviders(Widget child) {
    return MultiProvider(
      providers: getProviders(),
      child: child,
    );
  }
}