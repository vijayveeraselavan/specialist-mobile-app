import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../../domain/entities/onboarding_page.dart';
import '../../../../core/localization/app_localizations.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/widgets/responsive_builder.dart';

class EnhancedOnboardingPage extends StatefulWidget {
  final OnboardingPage page;
  final bool isActive;
  final int pageIndex;
  final int totalPages;

  const EnhancedOnboardingPage({
    super.key,
    required this.page,
    required this.isActive,
    required this.pageIndex,
    required this.totalPages,
  });

  @override
  State<EnhancedOnboardingPage> createState() => _EnhancedOnboardingPageState();
}

class _EnhancedOnboardingPageState extends State<EnhancedOnboardingPage>
    with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late AnimationController _slideController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _setupAnimations();
    if (widget.isActive) {
      _startAnimations();
    }
  }

  @override
  void didUpdateWidget(EnhancedOnboardingPage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isActive && !oldWidget.isActive) {
      _startAnimations();
    } else if (!widget.isActive && oldWidget.isActive) {
      _reverseAnimations();
    }
  }

  void _setupAnimations() {
    _fadeController = AnimationController(
      duration: AppConstants.mediumAnimation,
      vsync: this,
    );

    _slideController = AnimationController(
      duration: AppConstants.mediumAnimation,
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeInOut,
    ));

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _slideController,
      curve: Curves.easeOutCubic,
    ));
  }

  void _startAnimations() {
    _fadeController.forward();
    Future.delayed(const Duration(milliseconds: 200), () {
      if (mounted) {
        _slideController.forward();
      }
    });
  }

  void _reverseAnimations() {
    _slideController.reverse();
    _fadeController.reverse();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _slideController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ResponsiveBuilder(
      builder: (context, deviceType) {
        return ResponsivePadding(
          mobile: const EdgeInsets.symmetric(horizontal: AppConstants.largePadding),
          tablet: const EdgeInsets.symmetric(horizontal: AppConstants.extraLargePadding * 2),
          child: ResponsiveConstraints(
            maxWidth: deviceType == DeviceType.tablet ? 700 : double.infinity,
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: SlideTransition(
                position: _slideAnimation,
                child: Column(
                  children: [
                    // Visual Content
                    Expanded(
                      flex: deviceType == DeviceType.tablet ? 2 : 3,
                      child: _buildVisualContent(context),
                    ),

                    // Text Content
                    Expanded(
                      flex: deviceType == DeviceType.tablet ? 3 : 2,
                      child: _buildTextContent(context),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildVisualContent(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(vertical: AppConstants.largePadding),
      child: Center(
        child: _buildPageSpecificVisual(context),
      ),
    );
  }

  Widget _buildPageSpecificVisual(BuildContext context) {
    switch (widget.pageIndex) {
      case 0: // Welcome
        return _buildWelcomeVisual();
      case 1: // Medical Card
        return _buildMedicalCardVisual();
      case 2: // Reminders
        return _buildRemindersVisual();
      case 3: // Multi-language
        return _buildMultiLanguageVisual();
      case 4: // Offline Support
        return _buildOfflineVisual();
      default:
        return _buildDefaultVisual();
    }
  }

  Widget _buildWelcomeVisual() {
    return Container(
      width: 280,
      height: 280,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.primary.withValues(alpha: 0.1),
            AppColors.accent.withValues(alpha: 0.1),
          ],
        ),
        borderRadius: BorderRadius.circular(AppConstants.extraLargeRadius),
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Background Pattern
          Positioned.fill(
            child: CustomPaint(
              painter: _WelcomePatternPainter(),
            ),
          ),
          // Central Icon
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              color: AppColors.primary,
              borderRadius: BorderRadius.circular(AppConstants.extraLargeRadius),
              boxShadow: [
                BoxShadow(
                  color: AppColors.primary.withValues(alpha: 0.3),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: const Icon(
              Icons.medical_services,
              size: 60,
              color: AppColors.onPrimary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMedicalCardVisual() {
    return Container(
      width: 320,
      height: 200,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppConstants.largeRadius),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.primary,
            AppColors.primary.withValues(alpha: 0.8),
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.3),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Stack(
        children: [
          // Card Background Pattern
          Positioned.fill(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(AppConstants.largeRadius),
              child: CustomPaint(
                painter: _CardPatternPainter(),
              ),
            ),
          ),
          // Card Content
          Padding(
            padding: const EdgeInsets.all(AppConstants.largePadding),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(
                      Icons.medical_information,
                      color: AppColors.onPrimary,
                      size: 24,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'VitalLink Card',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: AppColors.onPrimary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const Spacer(),
                Text(
                  'Digital Health ID',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: AppColors.onPrimary.withValues(alpha: 0.9),
                  ),
                ),
                Text(
                  '•••• •••• •••• 1234',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    color: AppColors.onPrimary,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 2,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRemindersVisual() {
    return SizedBox(
      width: 280,
      height: 280,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Clock Circle
          Container(
            width: 200,
            height: 200,
            decoration: BoxDecoration(
              color: AppColors.accent.withValues(alpha: 0.1),
              shape: BoxShape.circle,
              border: Border.all(
                color: AppColors.accent.withValues(alpha: 0.3),
                width: 2,
              ),
            ),
            child: CustomPaint(
              painter: _ClockPainter(),
            ),
          ),
          // Notification Badges
          ...List.generate(3, (index) => _buildNotificationBadge(index)),
          // Center Icon
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: AppColors.accent,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: AppColors.accent.withValues(alpha: 0.3),
                  blurRadius: 15,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: const Icon(
              Icons.notifications_active,
              color: AppColors.onPrimary,
              size: 40,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMultiLanguageVisual() {
    return Container(
      width: 300,
      height: 250,
      child: Stack(
        children: [
          // Language Bubbles
          Positioned(
            top: 20,
            left: 20,
            child: _buildLanguageBubble('Hello!', AppColors.primary),
          ),
          Positioned(
            top: 80,
            right: 20,
            child: _buildLanguageBubble('Bonjour!', AppColors.accent),
          ),
          Positioned(
            bottom: 60,
            left: 40,
            child: _buildLanguageBubble('¡Hola!', AppColors.success),
          ),
          Positioned(
            bottom: 20,
            right: 40,
            child: _buildLanguageBubble('Namaste!', AppColors.warning),
          ),
          // Center Globe
          Center(
            child: Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.1),
                shape: BoxShape.circle,
                border: Border.all(
                  color: AppColors.primary.withValues(alpha: 0.3),
                  width: 2,
                ),
              ),
              child: Icon(
                Icons.language,
                size: 50,
                color: AppColors.primary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOfflineVisual() {
    return Container(
      width: 280,
      height: 280,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Background Circles
          ...List.generate(3, (index) => _buildOfflineCircle(index)),
          // Device Icon
          Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              color: AppColors.success,
              borderRadius: BorderRadius.circular(AppConstants.largeRadius),
              boxShadow: [
                BoxShadow(
                  color: AppColors.success.withValues(alpha: 0.3),
                  blurRadius: 20,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: const Icon(
              Icons.cloud_off,
              color: AppColors.onPrimary,
              size: 50,
            ),
          ),
          // Success Checkmark
          Positioned(
            bottom: 80,
            right: 80,
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: AppColors.success,
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 3),
              ),
              child: const Icon(
                Icons.check,
                color: Colors.white,
                size: 20,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDefaultVisual() {
    return Container(
      width: 200,
      height: 200,
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.1),
        shape: BoxShape.circle,
      ),
      child: Icon(
        widget.page.animationPath != null
            ? Icons.play_circle_outline
            : Icons.medical_services_outlined,
        size: 80,
        color: AppColors.primary,
      ),
    );
  }

  Widget _buildNotificationBadge(int index) {
    final positions = [
      const Offset(-80, -120),
      const Offset(100, -80),
      const Offset(-100, 100),
    ];
    final colors = [AppColors.error, AppColors.warning, AppColors.info];

    return Positioned(
      left: 140 + positions[index].dx,
      top: 140 + positions[index].dy,
      child: TweenAnimationBuilder<double>(
        duration: Duration(milliseconds: 1000 + (index * 200)),
        tween: Tween(begin: 0.0, end: 1.0),
        builder: (context, value, child) {
          return Transform.scale(
            scale: value,
            child: Container(
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                color: colors[index],
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: colors[index].withValues(alpha: 0.4),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Center(
                child: Text(
                  '${index + 1}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildLanguageBubble(String text, Color color) {
    return TweenAnimationBuilder<double>(
      duration: Duration(milliseconds: 800 + (text.length * 100)),
      tween: Tween(begin: 0.0, end: 1.0),
      builder: (context, value, child) {
        return Transform.scale(
          scale: value,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: color.withValues(alpha: 0.3),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Text(
              text,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildOfflineCircle(int index) {
    final sizes = [220.0, 160.0, 100.0];
    final opacities = [0.1, 0.15, 0.2];

    return TweenAnimationBuilder<double>(
      duration: Duration(milliseconds: 1200 + (index * 200)),
      tween: Tween(begin: 0.0, end: 1.0),
      builder: (context, value, child) {
        return Transform.scale(
          scale: value,
          child: Container(
            width: sizes[index],
            height: sizes[index],
            decoration: BoxDecoration(
              color: AppColors.success.withValues(alpha: opacities[index]),
              shape: BoxShape.circle,
              border: Border.all(
                color: AppColors.success.withValues(alpha: 0.3),
                width: 1,
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildTextContent(BuildContext context) {
    final theme = Theme.of(context);
    final localizations = AppLocalizations.of(context)!;

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Title
        _buildTitle(context, theme, localizations),
        
        const SizedBox(height: AppConstants.defaultPadding),
        
        // Description
        _buildDescription(context, theme, localizations),
        
        if (_getPageFeatures().isNotEmpty) ...[
          const SizedBox(height: AppConstants.largePadding),
          _buildFeaturesList(context, theme),
        ],
      ],
    );
  }

  Widget _buildTitle(BuildContext context, ThemeData theme, AppLocalizations localizations) {
    String title ="Vitalink";

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

  Widget _buildDescription(BuildContext context, ThemeData theme, AppLocalizations localizations) {
    String description = _getLocalizedDescription(localizations);

    return Text(
      description,
      style: ResponsiveBuilder.isMobile(context)
          ? theme.textTheme.bodyLarge?.copyWith(
              height: 1.6,
              color: theme.textTheme.bodyLarge?.color?.withValues(alpha: 0.8),
            )
          : theme.textTheme.headlineSmall?.copyWith(
              height: 1.6,
              fontWeight: FontWeight.w400,
              color: theme.textTheme.bodyLarge?.color?.withValues(alpha: 0.8),
            ),
      textAlign: TextAlign.center,
      semanticsLabel: description,
    );
  }

  Widget _buildFeaturesList(BuildContext context, ThemeData theme) {
    final features = _getPageFeatures();
    
    return Column(
      children: features.asMap().entries.map((entry) {
        final index = entry.key;
        final feature = entry.value;
        
        return TweenAnimationBuilder<double>(
          duration: Duration(milliseconds: 300 + (index * 100)),
          tween: Tween(begin: 0.0, end: 1.0),
          builder: (context, value, child) {
            return Transform.translate(
              offset: Offset(0, 20 * (1 - value)),
              child: Opacity(
                opacity: value,
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Row(
                    children: [
                      Icon(
                        Icons.check_circle,
                        size: 20,
                        color: AppColors.success,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          feature,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            height: 1.4,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      }).toList(),
    );
  }

  String _getLocalizedTitle(AppLocalizations localizations) {
    switch (widget.page.titleKey) {
      case 'welcomeTitle':
        return localizations.welcomeTitle;
      case 'medicalCardTitle':
        return localizations.medicalCardTitle;
      case 'remindersTitle':
        return localizations.remindersTitle;
      case 'multiLanguageTitle':
        return localizations.multiLanguageTitle;
      case 'offlineTitle':
        return localizations.offlineTitle;
      default:
        return widget.page.titleKey;
    }
  }

  String _getLocalizedDescription(AppLocalizations localizations) {
    switch (widget.page.descriptionKey) {
      case 'welcomeSubtitle':
        return localizations.welcomeSubtitle;
      case 'medicalCardDescription':
        return localizations.medicalCardDescription;
      case 'remindersDescription':
        return localizations.remindersDescription;
      case 'multiLanguageDescription':
        return localizations.multiLanguageDescription;
      case 'offlineDescription':
        return localizations.offlineDescription;
      default:
        return widget.page.descriptionKey;
    }
  }

  List<String> _getPageFeatures() {
    switch (widget.pageIndex) {
      case 1: // Medical Card
        return [
          'Secure digital health ID',
          'Emergency medical information',
          'Insurance and contact details'
        ];
      case 2: // Reminders
        return [
          'Medication schedules',
          'Appointment notifications',
          'Health check reminders'
        ];
      case 3: // Multi-language
        return [
          'Real-time translation',
          'Medical terminology support',
          'Cultural sensitivity features'
        ];
      case 4: // Offline Support
        return [
          'Local data storage',
          'Sync when online',
          'Emergency access mode'
        ];
      default:
        return [];
    }
  }
}

// Custom Painters for Visual Effects
class _WelcomePatternPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.primary.withValues(alpha: 0.1)
      ..style = PaintingStyle.fill;

    // Draw some decorative circles
    canvas.drawCircle(Offset(size.width * 0.2, size.height * 0.3), 20, paint);
    canvas.drawCircle(Offset(size.width * 0.8, size.height * 0.7), 15, paint);
    canvas.drawCircle(Offset(size.width * 0.7, size.height * 0.2), 25, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _CardPatternPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withValues(alpha: 0.1)
      ..style = PaintingStyle.fill;

    // Draw chip pattern
    final chipRect = RRect.fromLTRBR(
      size.width * 0.05,
      size.height * 0.3,
      size.width * 0.25,
      size.height * 0.5,
      const Radius.circular(4),
    );
    canvas.drawRRect(chipRect, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _ClockPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.accent.withValues(alpha: 0.3)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;

    // Draw hour markers
    for (int i = 0; i < 12; i++) {
      final angle = (i * 30) * (3.14159 / 180);
      final start = Offset(
        center.dx + (radius - 15) * math.cos(angle - 3.14159 / 2),
        center.dy + (radius - 15) * math.sin(angle - 3.14159 / 2),
      );
      final end = Offset(
        center.dx + (radius - 5) * math.cos(angle - 3.14159 / 2),
        center.dy + (radius - 5) * math.sin(angle - 3.14159 / 2),
      );
      canvas.drawLine(start, end, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}