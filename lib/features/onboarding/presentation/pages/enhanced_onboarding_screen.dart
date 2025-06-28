import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../providers/onboarding_provider.dart';
import '../widgets/enhanced_onboarding_page.dart';
import '../../../../core/localization/app_localizations.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/constants/app_routes.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/responsive_builder.dart';

class EnhancedOnboardingScreen extends StatefulWidget {
  const EnhancedOnboardingScreen({super.key});

  @override
  State<EnhancedOnboardingScreen> createState() => _EnhancedOnboardingScreenState();
}

class _EnhancedOnboardingScreenState extends State<EnhancedOnboardingScreen>
    with TickerProviderStateMixin {
  late PageController _pageController;
  late AnimationController _appBarController;
  late AnimationController _buttonsController;
  late Animation<double> _appBarAnimation;
  late Animation<double> _buttonsAnimation;

  @override
  void initState() {
    super.initState();
    _setupControllers();
    _initializeOnboarding();
  }

  void _setupControllers() {
    _pageController = PageController();
    
    _appBarController = AnimationController(
      duration: AppConstants.mediumAnimation,
      vsync: this,
    );
    
    _buttonsController = AnimationController(
      duration: AppConstants.mediumAnimation,
      vsync: this,
    );

    _appBarAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _appBarController,
      curve: Curves.easeInOut,
    ));

    _buttonsAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _buttonsController,
      curve: Curves.easeOutBack,
    ));
  }

  void _initializeOnboarding() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = OnboardingProvider.read(context);
      provider.initialize().then((_) {
        if (provider.state == OnboardingState.loaded) {
          _startAnimations();
        }
      });
    });
  }

  void _startAnimations() {
    _appBarController.forward();
    Future.delayed(const Duration(milliseconds: 300), () {
      if (mounted) {
        _buttonsController.forward();
      }
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    _appBarController.dispose();
    _buttonsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: _buildAnimatedAppBar(),
      body: Consumer<OnboardingProvider>(
        builder: (context, provider, child) {
          switch (provider.state) {
            case OnboardingState.initial:
            case OnboardingState.loading:
              return _buildLoadingView();
            case OnboardingState.error:
              return _buildErrorView(provider);
            case OnboardingState.completed:
              WidgetsBinding.instance.addPostFrameCallback((_) {
                _buildOnboardingView(provider);
              });
              return _buildCompletedView();
            case OnboardingState.loaded:
              return _buildOnboardingView(provider);
          }
        },
      ),
    );
  }

  PreferredSizeWidget _buildAnimatedAppBar() {
    return PreferredSize(
      preferredSize: const Size.fromHeight(kToolbarHeight),
      child: AnimatedBuilder(
        animation: _appBarAnimation,
        builder: (context, child) {
          return Transform.translate(
            offset: Offset(0, -50 * (1 - _appBarAnimation.value)),
            child: Opacity(
              opacity: _appBarAnimation.value,
              child: Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).scaffoldBackgroundColor.withValues(alpha: 0.9),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.1),
                      blurRadius: 10,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppConstants.defaultPadding,
                      vertical: AppConstants.smallPadding,
                    ),
                    child: _buildAppBarContent(),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildAppBarContent() {
    final localizations = AppLocalizations.of(context)!;
    
    return Consumer<OnboardingProvider>(
      builder: (context, provider, child) {
        if (provider.state != OnboardingState.loaded) {
          return const SizedBox.shrink();
        }

        return Row(
          children: [
            // App Logo and Title
            Expanded(
              child: Row(
                children: [
                  Hero(
                    tag: 'app_logo',
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        borderRadius: BorderRadius.circular(AppConstants.defaultRadius),
                      ),
                      child: const Icon(
                        Icons.medical_services,
                        color: AppColors.onPrimary,
                        size: 24,
                      ),
                    ),
                  ),
                  const SizedBox(width: AppConstants.smallPadding),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        localizations.appName,
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: AppColors.primary,
                        ),
                      ),
                      Text(
                        'Healthcare',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Theme.of(context).textTheme.bodySmall?.color?.withValues(alpha: 0.7),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Empty space to center the logo
            const Expanded(child: SizedBox()),

            // Skip Button
            if (provider.canSkip)
              SizedBox(
                width: 80,
                child: TextButton(
                  onPressed: () => _showSkipDialog(provider),
                  style: TextButton.styleFrom(
                    foregroundColor: AppColors.textSecondary,
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  ),
                  child: Text(
                    localizations.skipButton,
                    style: const TextStyle(fontWeight: FontWeight.w500),
                  ),
                ),
              )
            else
              const SizedBox(width: 80),
          ],
        );
      },
    );
  }

  Widget _buildLoadingView() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Hero(
            tag: 'loading_indicator',
            child: Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(AppConstants.extraLargeRadius),
              ),
              child: const Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
                ),
              ),
            ),
          ),
          const SizedBox(height: AppConstants.largePadding),
          Text(
            'Preparing your experience...',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorView(OnboardingProvider provider) {
    final localizations = AppLocalizations.of(context)!;
    
    return Center(
      child: ResponsivePadding(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                color: AppColors.error.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(AppConstants.extraLargeRadius),
              ),
              child: const Icon(
                Icons.error_outline,
                size: 50,
                color: AppColors.error,
              ),
            ),
            const SizedBox(height: AppConstants.largePadding),
            Text(
              'Oops! Something went wrong',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppConstants.smallPadding),
            Text(
              provider.errorMessage ?? 'Please try again',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: AppColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppConstants.extraLargePadding),
            SizedBox(
              width: double.infinity,
              child: AppButton.primary(
                text: localizations.retry,
                onPressed: provider.retry,
                size: AppButtonSize.large,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCompletedView() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          TweenAnimationBuilder<double>(
            duration: AppConstants.longAnimation,
            tween: Tween(begin: 0.0, end: 1.0),
            builder: (context, value, child) {
              return Transform.scale(
                scale: value,
                child: Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    color: AppColors.success,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.success.withValues(alpha: 0.3),
                        blurRadius: 20,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.check,
                    size: 60,
                    color: Colors.white,
                  ),
                ),
              );
            },
          ),
          const SizedBox(height: AppConstants.largePadding),
          Text(
            'Welcome to VitalLink!',
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: AppColors.success,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOnboardingView(OnboardingProvider provider) {
    return Column(
      children: [
        // Page View
        Expanded(
          child: PageView.builder(
            controller: _pageController,
            onPageChanged: (index) {
              provider.goToPage(index);
            },
            itemCount: provider.pages.length,
            itemBuilder: (context, index) {
              return EnhancedOnboardingPage(
                page: provider.pages[index],
                isActive: index == provider.currentIndex,
                pageIndex: index,
                totalPages: provider.pages.length,
              );
            },
          ),
        ),
        
        // Navigation Buttons
        _buildNavigationButtons(provider),
      ],
    );
  }

  Widget _buildNavigationButtons(OnboardingProvider provider) {
    final localizations = AppLocalizations.of(context)!;
    
    return AnimatedBuilder(
      animation: _buttonsAnimation,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(0, 50 * (1 - _buttonsAnimation.value)),
          child: Opacity(
            opacity: _buttonsAnimation.value,
            child: Container(
              padding: ResponsiveBuilder.isMobile(context)
                  ? const EdgeInsets.all(AppConstants.largePadding)
                  : const EdgeInsets.all(AppConstants.extraLargePadding),
              decoration: BoxDecoration(
                color: Theme.of(context).scaffoldBackgroundColor,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 10,
                    offset: const Offset(0, -2),
                  ),
                ],
              ),
              child: SafeArea(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Simple dot indicator
                    _buildDotIndicator(provider),
                    const SizedBox(height: AppConstants.largePadding),
                    // Navigation buttons
                    _buildNavigationButtonsContent(provider, localizations),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildDotIndicator(OnboardingProvider provider) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        provider.pages.length,
        (index) => AnimatedContainer(
          duration: AppConstants.shortAnimation,
          margin: const EdgeInsets.symmetric(horizontal: 4),
          width: index == provider.currentIndex ? 24 : 8,
          height: 8,
          decoration: BoxDecoration(
            color: index == provider.currentIndex 
                ? AppColors.primary 
                : AppColors.textTertiary.withValues(alpha: 0.3),
            borderRadius: BorderRadius.circular(4),
          ),
        ),
      ),
    );
  }

  Widget _buildNavigationButtonsContent(OnboardingProvider provider, AppLocalizations localizations) {
    return ResponsiveBuilder(
      builder: (context, deviceType) {
        return Row(
          children: [
            // Back Button
            if (!provider.isFirstPage)
              Expanded(
                child: AppButton.outline(
                  text: localizations.backButton,
                  onPressed: () {
                    _pageController.previousPage(
                      duration: AppConstants.shortAnimation,
                      curve: Curves.easeInOut,
                    );
                  },
                  size: AppButtonSize.large,
                  icon: Icons.arrow_back,
                ),
              ),
            
            if (!provider.isFirstPage)
              const SizedBox(width: AppConstants.defaultPadding),
            
            // Next/Get Started Button
            Expanded(
              flex: provider.isFirstPage ? 1 : 1,
              child: AppButton.primary(
                text: provider.isLastPage
                    ? localizations.getStartedButton
                    : localizations.nextButton,
                onPressed: () {
                  if (provider.isLastPage) {
                    _completeOnboarding(provider);
                  } else {
                    _pageController.nextPage(
                      duration: AppConstants.shortAnimation,
                      curve: Curves.easeInOut,
                    );
                  }
                },
                size: AppButtonSize.large,
                icon: provider.isLastPage ? Icons.rocket_launch : Icons.arrow_forward,
                iconAfterText: true,
              ),
            ),
          ],
        );
      },
    );
  }

  void _showSkipDialog(OnboardingProvider provider) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text('Skip Onboarding?'),
        content: const Text(
          'Are you sure you want to skip the introduction? You will be taken back to the first page.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Stay'),
          ),
          AppButton.primary(
            text: 'Skip',
            onPressed: () {
              Navigator.of(context).pop();
              _completeOnboarding(provider);
            },
          ),
        ],
      ),
    );
  }

  void _completeOnboarding(OnboardingProvider provider) {
    // Navigate to login screen
    context.go(AppRoutes.login);
  }
}