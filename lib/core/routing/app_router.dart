import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../constants/app_routes.dart';
import '../../features/onboarding/presentation/pages/enhanced_onboarding_screen.dart';
import 'first_splash_screen.dart';
import 'second_splash_screen.dart';
// import 'home_screen.dart';
import 'error_screen.dart';

class AppRouter {
  static final GoRouter _router = GoRouter(
    initialLocation: AppRoutes.splash,
    errorBuilder: (context, state) => ErrorScreen(error: state.error.toString()),
    routes: [
      // First Splash Route
      GoRoute(
        path: AppRoutes.splash,
        name: 'first_splash',
        builder: (context, state) => const FirstSplashScreen(),
      ),
      
      // Second Splash Route
      GoRoute(
        path: AppRoutes.secondSplash,
        name: 'second_splash',
        builder: (context, state) {
          final nextRoute = state.uri.queryParameters['nextRoute'];
          return SecondSplashScreen(nextRoute: nextRoute);
        },
      ),
      
      // Onboarding Route
      GoRoute(
        path: AppRoutes.onboarding,
        name: 'onboarding',
        builder: (context, state) => const EnhancedOnboardingScreen(),
      ),
      
      // Login Route
      // GoRoute(
      //   path: AppRoutes.login,
      //   name: 'login',
      //   builder: (context, state) => const LoginScreen(),
      // ),
      //
      // // Register Route
      // GoRoute(
      //   path: AppRoutes.register,
      //   name: 'register',
      //   builder: (context, state) => const RegisterScreen(),
      // ),
      //
      // // Account Creation Route
      // GoRoute(
      //   path: AppRoutes.accountCreation,
      //   name: 'account_creation',
      //   builder: (context, state) => const AccountCreationScreen(),
      // ),
      //
      // // Confirm Login Route
      // GoRoute(
      //   path: AppRoutes.confirmLogin,
      //   name: 'confirm_login',
      //   builder: (context, state) => const ConfirmLoginScreen(),
      // ),
      //
      // // File Onboard Route
      // GoRoute(
      //   path: AppRoutes.fileOnboard,
      //   name: 'file_onboard',
      //   builder: (context, state) => const FileOnboardScreen(),
      // ),
      //
      // // Create Medical File Route
      // GoRoute(
      //   path: AppRoutes.createMedicalFile,
      //   name: 'create_medical_file',
      //   builder: (context, state) => const CreateMedicalFileScreen(),
      // ),
      //
      // // Role Selection Route
      // GoRoute(
      //   path: AppRoutes.roleSelection,
      //   name: 'role_selection',
      //   builder: (context, state) => const EnhancedRoleSelectionScreen(),
      // ),
      //
      // // Home Route
      // GoRoute(
      //   path: AppRoutes.home,
      //   name: 'home',
      //   builder: (context, state) => const HomeScreen(),
      // ),
      //
      // // Error Route
      // GoRoute(
      //   path: AppRoutes.error,
      //   name: 'error',
      //   builder: (context, state) => ErrorScreen(
      //     error: state.extra as String? ?? 'Unknown error',
      //   ),
      // ),
    ],
    redirect: (context, state) {
      // Add any global redirection logic here
      return null;
    },
  );

  static GoRouter get router => _router;
}