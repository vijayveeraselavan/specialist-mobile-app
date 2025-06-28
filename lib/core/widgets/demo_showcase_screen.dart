import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../constants/app_constants.dart';
import '../localization/app_localizations.dart';
import 'responsive_builder.dart';
import 'app_button.dart';
import 'feature_showcase_card.dart';
import 'animated_progress_indicator.dart';
import 'onboarding_step_indicator.dart';

class DemoShowcaseScreen extends StatefulWidget {
  const DemoShowcaseScreen({super.key});

  @override
  State<DemoShowcaseScreen> createState() => _DemoShowcaseScreenState();
}

class _DemoShowcaseScreenState extends State<DemoShowcaseScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;
  int _currentStep = 0;
  double _progress = 0.3;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('VitalLink Component Demo'),
        centerTitle: true,
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.onPrimary,
        bottom: TabBar(
          controller: _tabController,
          labelColor: AppColors.onPrimary,
          unselectedLabelColor: AppColors.onPrimary.withValues(alpha: 0.7),
          indicatorColor: AppColors.onPrimary,
          tabs: const [
            Tab(text: 'Components', icon: Icon(Icons.widgets)),
            Tab(text: 'Features', icon: Icon(Icons.star)),
            Tab(text: 'Animations', icon: Icon(Icons.animation)),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildComponentsTab(),
          _buildFeaturesTab(),
          _buildAnimationsTab(),
        ],
      ),
    );
  }

  Widget _buildComponentsTab() {
    return ResponsivePadding(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: AppConstants.largePadding),
            
            // Buttons Section
            _buildSectionTitle('Buttons'),
            _buildButtonsDemo(),
            
            const SizedBox(height: AppConstants.extraLargePadding),
            
            // Progress Indicators Section
            _buildSectionTitle('Progress Indicators'),
            _buildProgressDemo(),
            
            const SizedBox(height: AppConstants.extraLargePadding),
            
            // Step Indicators Section
            _buildSectionTitle('Step Indicators'),
            _buildStepDemo(),
            
            const SizedBox(height: AppConstants.extraLargePadding),
          ],
        ),
      ),
    );
  }

  Widget _buildFeaturesTab() {
    return ResponsivePadding(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: AppConstants.largePadding),
            
            _buildSectionTitle('Healthcare Features'),
            
            FeatureShowcaseCard(
              icon: Icons.medical_information,
              title: 'Digital Medical Records',
              description: 'Secure, accessible health information at your fingertips',
              features: [
                'Encrypted data storage',
                'Real-time synchronization',
                'Emergency access codes',
                'Multi-device support',
              ],
              accentColor: AppColors.primary,
              isExpanded: true,
            ),
            
            FeatureShowcaseCard(
              icon: Icons.notifications_active,
              title: 'Smart Reminders',
              description: 'Never miss your medication or appointments',
              features: [
                'Customizable schedules',
                'Voice notifications',
                'Family sharing',
                'Integration with calendar',
              ],
              accentColor: AppColors.accent,
              isExpanded: false,
            ),
            
            FeatureShowcaseCard(
              icon: Icons.language,
              title: 'Multi-Language Support',
              description: 'Healthcare communication in your preferred language',
              features: [
                'Real-time translation',
                'Medical terminology',
                'Cultural sensitivity',
                'Voice assistance',
              ],
              accentColor: AppColors.success,
              isExpanded: false,
            ),
            
            const SizedBox(height: AppConstants.largePadding),
          ],
        ),
      ),
    );
  }

  Widget _buildAnimationsTab() {
    return ResponsivePadding(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: AppConstants.largePadding),
            
            _buildSectionTitle('Interactive Animations'),
            
            // Hero Animation Demo
            _buildAnimationDemo(
              'Hero Animations',
              'Smooth transitions between screens',
              Icons.flight_takeoff,
              AppColors.primary,
            ),
            
            // Stagger Animation Demo
            _buildAnimationDemo(
              'Staggered Animations',
              'Sequential element appearances',
              Icons.view_list,
              AppColors.accent,
            ),
            
            // Physics Animation Demo
            _buildAnimationDemo(
              'Physics-based Animations',
              'Natural spring and bounce effects',
              Icons.sports_basketball,
              AppColors.success,
            ),
            
            // Morphing Animation Demo
            _buildAnimationDemo(
              'Morphing Animations',
              'Smooth shape and color transitions',
              Icons.transform,
              AppColors.warning,
            ),
            
            const SizedBox(height: AppConstants.largePadding),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppConstants.defaultPadding),
      child: Text(
        title,
        style: Theme.of(context).textTheme.headlineSmall?.copyWith(
          fontWeight: FontWeight.bold,
          color: AppColors.primary,
        ),
      ),
    );
  }

  Widget _buildButtonsDemo() {
    return Column(
      children: [
        // Primary Buttons
        Row(
          children: [
            Expanded(
              child: AppButton.primary(
                text: 'Primary Button',
                onPressed: () => _showSnackBar('Primary button pressed'),
                size: AppButtonSize.large,
              ),
            ),
            const SizedBox(width: AppConstants.defaultPadding),
            Expanded(
              child: AppButton.primary(
                text: 'With Icon',
                onPressed: () => _showSnackBar('Icon button pressed'),
                icon: Icons.star,
                size: AppButtonSize.large,
              ),
            ),
          ],
        ),
        
        const SizedBox(height: AppConstants.defaultPadding),
        
        // Secondary Buttons
        Row(
          children: [
            Expanded(
              child: AppButton.outline(
                text: 'Outline Button',
                onPressed: () => _showSnackBar('Outline button pressed'),
                size: AppButtonSize.large,
              ),
            ),
            const SizedBox(width: AppConstants.defaultPadding),
            Expanded(
              child: AppButton.text(
                text: 'Text Button',
                onPressed: () => _showSnackBar('Text button pressed'),
                size: AppButtonSize.large,
              ),
            ),
          ],
        ),
        
        const SizedBox(height: AppConstants.defaultPadding),
        
        // Loading and Disabled States
        Row(
          children: [
            Expanded(
              child: AppButton.primary(
                text: 'Loading',
                onPressed: () {},
                isLoading: true,
                size: AppButtonSize.large,
              ),
            ),
            const SizedBox(width: AppConstants.defaultPadding),
            Expanded(
              child: AppButton.primary(
                text: 'Disabled',
                onPressed: null,
                size: AppButtonSize.large,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildProgressDemo() {
    return Column(
      children: [
        AnimatedProgressIndicator(
          progress: _progress,
          label: 'Download Progress',
          showPercentage: true,
          height: 8,
        ),
        
        const SizedBox(height: AppConstants.defaultPadding),
        
        Row(
          children: [
            Expanded(
              child: AppButton.outline(
                text: 'Decrease',
                onPressed: () {
                  setState(() {
                    _progress = (_progress - 0.1).clamp(0.0, 1.0);
                  });
                },
              ),
            ),
            const SizedBox(width: AppConstants.defaultPadding),
            Expanded(
              child: AppButton.primary(
                text: 'Increase',
                onPressed: () {
                  setState(() {
                    _progress = (_progress + 0.1).clamp(0.0, 1.0);
                  });
                },
              ),
            ),
          ],
        ),
        
        const SizedBox(height: AppConstants.largePadding),
        
        // Circular Progress
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Column(
              children: [
                SizedBox(
                  width: 60,
                  height: 60,
                  child: CircularProgressIndicator(
                    value: _progress,
                    valueColor: const AlwaysStoppedAnimation<Color>(AppColors.primary),
                    strokeWidth: 6,
                  ),
                ),
                const SizedBox(height: AppConstants.smallPadding),
                Text('${(_progress * 100).round()}%'),
              ],
            ),
            Column(
              children: [
                const SizedBox(
                  width: 60,
                  height: 60,
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(AppColors.accent),
                    strokeWidth: 6,
                  ),
                ),
                const SizedBox(height: AppConstants.smallPadding),
                const Text('Indeterminate'),
              ],
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildStepDemo() {
    return Column(
      children: [
        OnboardingStepIndicator(
          currentStep: _currentStep,
          totalSteps: 5,
          stepLabels: const [
            'Welcome',
            'Profile',
            'Preferences',
            'Verification',
            'Complete',
          ],
          showLabels: true,
          vertical: false,
        ),
        
        const SizedBox(height: AppConstants.largePadding),
        
        Row(
          children: [
            Expanded(
              child: AppButton.outline(
                text: 'Previous',
                onPressed: _currentStep > 0 ? () {
                  setState(() {
                    _currentStep--;
                  });
                } : null,
                icon: Icons.arrow_back,
              ),
            ),
            const SizedBox(width: AppConstants.defaultPadding),
            Expanded(
              child: AppButton.primary(
                text: 'Next',
                onPressed: _currentStep < 4 ? () {
                  setState(() {
                    _currentStep++;
                  });
                } : null,
                icon: Icons.arrow_forward,
                iconAfterText: true,
              ),
            ),
          ],
        ),
        
        const SizedBox(height: AppConstants.largePadding),
        
        // Vertical Step Indicator
        OnboardingStepIndicator(
          currentStep: _currentStep,
          totalSteps: 3,
          stepLabels: const [
            'Basic Information',
            'Medical History',
            'Emergency Contacts',
          ],
          showLabels: true,
          vertical: true,
        ),
      ],
    );
  }

  Widget _buildAnimationDemo(String title, String description, IconData icon, Color color) {
    return TweenAnimationBuilder<double>(
      duration: const Duration(seconds: 2),
      tween: Tween(begin: 0.0, end: 1.0),
      builder: (context, value, child) {
        return Container(
          margin: const EdgeInsets.only(bottom: AppConstants.defaultPadding),
          padding: const EdgeInsets.all(AppConstants.largePadding),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(AppConstants.largeRadius),
            border: Border.all(
              color: color.withValues(alpha: 0.3),
            ),
          ),
          child: Row(
            children: [
              Transform.rotate(
                angle: value * 2 * 3.14159,
                child: Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color: color,
                    borderRadius: BorderRadius.circular(AppConstants.defaultRadius),
                  ),
                  child: Icon(
                    icon,
                    color: Colors.white,
                    size: 30,
                  ),
                ),
              ),
              const SizedBox(width: AppConstants.defaultPadding),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: color,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      description,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        behavior: SnackBarBehavior.floating,
        backgroundColor: AppColors.primary,
        action: SnackBarAction(
          label: 'OK',
          textColor: AppColors.onPrimary,
          onPressed: () {},
        ),
      ),
    );
  }
}