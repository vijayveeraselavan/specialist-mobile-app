import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import '../../domain/entities/onboarding_page.dart';
import '../../../../core/localization/app_localizations.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/widgets/responsive_builder.dart';

class OnboardingPageWidget extends StatelessWidget {
  final OnboardingPage page;
  final bool isActive;

  const OnboardingPageWidget({
    super.key,
    required this.page,
    this.isActive = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final localizations = AppLocalizations.of(context)!;
    final screenSize = MediaQuery.of(context).size;
    final isTablet = ResponsiveBuilder.isTablet(context);

    return ResponsivePadding(
      mobile: const EdgeInsets.symmetric(horizontal: AppConstants.largePadding),
      tablet: const EdgeInsets.symmetric(horizontal: AppConstants.extraLargePadding),
      child: ResponsiveConstraints(
        maxWidth: isTablet ? 600 : double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Animation or Image
            Expanded(
              flex: 3,
              child: _buildVisual(context),
            ),
            
            const SizedBox(height: AppConstants.extraLargePadding),
            
            // Content
            Expanded(
              flex: 2,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  // Title
                  _buildTitle(context, theme, localizations),
                  
                  const SizedBox(height: AppConstants.defaultPadding),
                  
                  // Description
                  _buildDescription(context, theme, localizations),
                  
                  const SizedBox(height: AppConstants.largePadding),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildVisual(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppConstants.largePadding),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppConstants.extraLargeRadius),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.primary.withOpacity(0.1),
            AppColors.accent.withOpacity(0.1),
          ],
        ),
      ),
      child: Center(
        child: _buildMediaContent(),
      ),
    );
  }

  Widget _buildMediaContent() {
    if (page.animationPath != null) {
      return Lottie.asset(
        page.animationPath!,
        fit: BoxFit.contain,
        animate: isActive,
        repeat: isActive,
        errorBuilder: (context, error, stackTrace) {
          return _buildFallbackImage();
        },
      );
    } else {
      return _buildImage();
    }
  }

  Widget _buildImage() {
    return Image.asset(
      page.imagePath,
      fit: BoxFit.contain,
      errorBuilder: (context, error, stackTrace) {
        return _buildFallbackImage();
      },
    );
  }

  Widget _buildFallbackImage() {
    return Container(
      width: 200,
      height: 200,
      decoration: BoxDecoration(
        color: AppColors.primary.withOpacity(0.1),
        shape: BoxShape.circle,
      ),
      child: const Icon(
        Icons.medical_services_outlined,
        size: 80,
        color: AppColors.primary,
      ),
    );
  }

  Widget _buildTitle(
    BuildContext context,
    ThemeData theme,
    AppLocalizations localizations,
  ) {
    String title;
    switch (page.titleKey) {
      case 'welcomeTitle':
        title = localizations.welcomeTitle;
        break;
      case 'medicalCardTitle':
        title = localizations.medicalCardTitle;
        break;
      case 'remindersTitle':
        title = localizations.remindersTitle;
        break;
      case 'multiLanguageTitle':
        title = localizations.multiLanguageTitle;
        break;
      case 'offlineTitle':
        title = localizations.offlineTitle;
        break;
      default:
        title = page.titleKey;
    }

    return Text(
      title,
      style: ResponsiveBuilder.isMobile(context)
          ? theme.textTheme.displaySmall?.copyWith(
              fontWeight: FontWeight.bold,
              color: AppColors.primary,
            )
          : theme.textTheme.displayMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: AppColors.primary,
            ),
      textAlign: TextAlign.center,
      semanticsLabel: title,
    );
  }

  Widget _buildDescription(
    BuildContext context,
    ThemeData theme,
    AppLocalizations localizations,
  ) {
    String description;
    switch (page.descriptionKey) {
      case 'welcomeSubtitle':
        description = localizations.welcomeSubtitle;
        break;
      case 'medicalCardDescription':
        description = localizations.medicalCardDescription;
        break;
      case 'remindersDescription':
        description = localizations.remindersDescription;
        break;
      case 'multiLanguageDescription':
        description = localizations.multiLanguageDescription;
        break;
      case 'offlineDescription':
        description = localizations.offlineDescription;
        break;
      default:
        description = page.descriptionKey;
    }

    return Text(
      description,
      style: ResponsiveBuilder.isMobile(context)
          ? theme.textTheme.bodyLarge?.copyWith(
              height: 1.6,
              color: theme.textTheme.bodyLarge?.color?.withOpacity(0.8),
            )
          : theme.textTheme.headlineSmall?.copyWith(
              height: 1.6,
              fontWeight: FontWeight.w400,
              color: theme.textTheme.bodyLarge?.color?.withOpacity(0.8),
            ),
      textAlign: TextAlign.center,
      semanticsLabel: description,
    );
  }
}