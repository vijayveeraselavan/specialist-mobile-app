import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/constants/app_routes.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/responsive_builder.dart';

class AccountCreationScreen extends StatefulWidget {
  const AccountCreationScreen({super.key});

  @override
  State<AccountCreationScreen> createState() => _AccountCreationScreenState();
}

class _AccountCreationScreenState extends State<AccountCreationScreen> with TickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  
  late AnimationController _slideController;
  late AnimationController _fadeController;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _fadeAnimation;
  
  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;
  bool _isLoading = false;
  bool _consentGiven = false;

  // Password requirements
  Map<String, bool> _passwordRequirements = {
    'length': false,
    'uppercase': false,
    'lowercase': false,
    'latinOnly': false,
    'number': false,
    'noSpaces': false,
    'specialChar': false,
  };

  @override
  void initState() {
    super.initState();
    _setupAnimations();
    _startAnimations();
    _passwordController.addListener(_validatePassword);
  }

  void _setupAnimations() {
    _slideController = AnimationController(
      duration: AppConstants.mediumAnimation,
      vsync: this,
    );
    
    _fadeController = AnimationController(
      duration: AppConstants.longAnimation,
      vsync: this,
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _slideController,
      curve: Curves.easeOutCubic,
    ));

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeInOut,
    ));
  }

  void _startAnimations() {
    _fadeController.forward();
    Future.delayed(const Duration(milliseconds: 300), () {
      if (mounted) {
        _slideController.forward();
      }
    });
  }

  void _validatePassword() { 
    final password = _passwordController.text;
    setState(() {
      _passwordRequirements['length'] = password.length >= 8;
      _passwordRequirements['uppercase'] = password.contains(RegExp(r'[A-Z]'));
      _passwordRequirements['lowercase'] = password.contains(RegExp(r'[a-z]'));
      _passwordRequirements['latinOnly'] = RegExp(r'^[a-zA-Z0-9~!?@#$%^&*_\-+()\[\]{}<>/\\|«.,:;]*$').hasMatch(password);
      _passwordRequirements['number'] = password.contains(RegExp(r'[0-9]'));
      _passwordRequirements['noSpaces'] = !password.contains(' ');
      _passwordRequirements['specialChar'] = password.contains(RegExp(r'[~!?@#$%^&*_\-+()\[\]{}<>/\\|«.,:;]'));
    });
  }

  bool get _allRequirementsMet {
    return _passwordRequirements.values.every((requirement) => requirement);
  }

  @override
  void dispose() {
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _slideController.dispose();
    _fadeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
        title: Text(
          '9:30',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w500,
          ),
        ),
        centerTitle: false,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SafeArea(
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: SlideTransition(
            position: _slideAnimation,
            child: ResponsiveBuilder(
              builder: (context, deviceType) {
                return SingleChildScrollView(
                  child: ResponsivePadding(
                    mobile: const EdgeInsets.all(AppConstants.largePadding),
                    tablet: const EdgeInsets.all(AppConstants.extraLargePadding),
                    child: ResponsiveConstraints(
                      maxWidth: deviceType == DeviceType.tablet ? 500 : double.infinity,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          _buildHeader(),
                          const SizedBox(height: AppConstants.extraLargePadding),
                          _buildPasswordForm(),
                          const SizedBox(height: AppConstants.largePadding),
                          _buildPrivacyConsent(),
                          const SizedBox(height: AppConstants.largePadding),
                          _buildSocialLoginSection(),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Account creation',
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
      ],
    );
  }

  Widget _buildPasswordForm() {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Password Field
          _buildPasswordField(),
          const SizedBox(height: AppConstants.defaultPadding),
          
          // Password Requirements
          _buildPasswordRequirements(),
          const SizedBox(height: AppConstants.defaultPadding),
          
          // Confirm Password Field
          _buildConfirmPasswordField(),
          const SizedBox(height: AppConstants.largePadding),
          
          // Continue Button
          AppButton.primary(
            text: 'Continue',
            onPressed: (_isLoading || !_allRequirementsMet || !_consentGiven) ? null : _handleAccountCreation,
            size: AppButtonSize.large,
            isLoading: _isLoading,
            icon: Icons.arrow_forward,
            iconAfterText: true,
          ),
        ],
      ),
    );
  }

  Widget _buildPasswordField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Create your password',
          style: Theme.of(context).textTheme.labelLarge?.copyWith(
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: AppConstants.smallPadding),
        TextFormField(
          controller: _passwordController,
          obscureText: !_isPasswordVisible,
          decoration: InputDecoration(
            hintText: 'Enter your password',
            prefixIcon: Icon(Icons.lock_outline, color: AppColors.textSecondary),
            suffixIcon: IconButton(
              icon: Icon(
                _isPasswordVisible ? Icons.visibility_off : Icons.visibility,
                color: AppColors.textSecondary,
              ),
              onPressed: () {
                setState(() {
                  _isPasswordVisible = !_isPasswordVisible;
                });
              },
            ),
            filled: true,
            fillColor: AppColors.surface,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppConstants.defaultRadius),
              borderSide: BorderSide(color: AppColors.outline),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppConstants.defaultRadius),
              borderSide: BorderSide(color: AppColors.outline),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppConstants.defaultRadius),
              borderSide: BorderSide(color: AppColors.primary, width: 2),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppConstants.defaultRadius),
              borderSide: BorderSide(color: AppColors.error),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPasswordRequirements() {
    return Container(
      padding: const EdgeInsets.all(AppConstants.defaultPadding),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppConstants.defaultRadius),
        border: Border.all(color: AppColors.outline),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Mandatory requirements for a secure password',
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: AppConstants.smallPadding),
          ..._buildRequirementsList(),
        ],
      ),
    );
  }

  List<Widget> _buildRequirementsList() {
    final requirements = [
      ('At least 8 characters', 'length'),
      ('At least one uppercase letter and one lowercase letter', 'uppercase'),
      ('Only Latin letters', 'latinOnly'),
      ('At least one number', 'number'),
      ('Without spaces', 'noSpaces'),
      ('Presence of special characters: ~!? @ # \$ % ^ & * _ - + () [] { } > < / \\ | .,:;', 'specialChar'),
    ];

    return requirements.map((requirement) {
      final text = requirement.$1;
      final key = requirement.$2;
      final isMet = _passwordRequirements[key] ?? false;
      
      // Special handling for uppercase/lowercase requirement
      bool isUpperLowerMet = false;
      if (key == 'uppercase') {
        isUpperLowerMet = (_passwordRequirements['uppercase'] ?? false) && 
                         (_passwordRequirements['lowercase'] ?? false);
      }
      
      final actuallyMet = key == 'uppercase' ? isUpperLowerMet : isMet;
      
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 2),
        child: Row(
          children: [
            Icon(
              actuallyMet ? Icons.check_circle : Icons.radio_button_unchecked,
              size: 16,
              color: actuallyMet ? AppColors.success : AppColors.textSecondary,
            ),
            const SizedBox(width: AppConstants.smallPadding),
            Expanded(
              child: Text(
                text,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: actuallyMet ? AppColors.success : AppColors.textSecondary,
                  fontWeight: actuallyMet ? FontWeight.w500 : FontWeight.normal,
                ),
              ),
            ),
          ],
        ),
      );
    }).toList();
  }

  Widget _buildConfirmPasswordField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Confirm your password',
          style: Theme.of(context).textTheme.labelLarge?.copyWith(
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: AppConstants.smallPadding),
        TextFormField(
          controller: _confirmPasswordController,
          obscureText: !_isConfirmPasswordVisible,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please confirm your password';
            }
            if (value != _passwordController.text) {
              return 'Passwords do not match';
            }
            return null;
          },
          decoration: InputDecoration(
            hintText: 'Confirm your password',
            prefixIcon: Icon(Icons.lock_outline, color: AppColors.textSecondary),
            suffixIcon: IconButton(
              icon: Icon(
                _isConfirmPasswordVisible ? Icons.visibility_off : Icons.visibility,
                color: AppColors.textSecondary,
              ),
              onPressed: () {
                setState(() {
                  _isConfirmPasswordVisible = !_isConfirmPasswordVisible;
                });
              },
            ),
            filled: true,
            fillColor: AppColors.surface,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppConstants.defaultRadius),
              borderSide: BorderSide(color: AppColors.outline),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppConstants.defaultRadius),
              borderSide: BorderSide(color: AppColors.outline),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppConstants.defaultRadius),
              borderSide: BorderSide(color: AppColors.primary, width: 2),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppConstants.defaultRadius),
              borderSide: BorderSide(color: AppColors.error),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPrivacyConsent() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Checkbox(
          value: _consentGiven,
          onChanged: (value) {
            setState(() {
              _consentGiven = value ?? false;
            });
          },
          activeColor: AppColors.primary,
        ),
        Expanded(
          child: GestureDetector(
            onTap: () {
              setState(() {
                _consentGiven = !_consentGiven;
              });
            },
            child: Text(
              'I consent to the collection, storage, and processing of my personal data in accordance with the Privacy Policy. My data will be used exclusively for the provision of services, improving the operation of the service, and complying with legal obligations.',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: AppColors.textSecondary,
                height: 1.4,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSocialLoginSection() {
    return Column(
      children: [
        // Divider with "or"
        Row(
          children: [
            Expanded(
              child: Divider(
                color: AppColors.outline,
                thickness: 1,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppConstants.defaultPadding),
              child: Text(
                'or',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppColors.textSecondary,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            Expanded(
              child: Divider(
                color: AppColors.outline,
                thickness: 1,
              ),
            ),
          ],
        ),
        const SizedBox(height: AppConstants.largePadding),
        
        // Social Login Buttons
        Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Continue with Email
            _buildSocialButton(
              text: 'Continue with email',
              icon: Icons.email_outlined,
              color: AppColors.info,
              onPressed: () {
                // TODO: Implement email login
              },
            ),
            const SizedBox(height: AppConstants.defaultPadding),
            
            // Continue with Google
            _buildSocialButton(
              text: 'Continue with Google',
              icon: Icons.g_mobiledata,
              color: const Color(0xFFDB4437),
              onPressed: () {
                // TODO: Implement Google login
              },
            ),
            const SizedBox(height: AppConstants.defaultPadding),
            
            // Continue with Phone
            _buildSocialButton(
              text: 'Continue with phone',
              icon: Icons.phone_outlined,
              color: AppColors.success,
              onPressed: () {
                // TODO: Implement phone login
              },
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSocialButton({
    required String text,
    required IconData icon,
    required Color color,
    required VoidCallback onPressed,
  }) {
    return OutlinedButton.icon(
      onPressed: onPressed,
      icon: Icon(icon, color: color),
      label: Text(
        text,
        style: TextStyle(
          color: AppColors.textPrimary,
          fontWeight: FontWeight.w500,
        ),
      ),
      style: OutlinedButton.styleFrom(
        padding: const EdgeInsets.symmetric(
          horizontal: AppConstants.defaultPadding,
          vertical: AppConstants.defaultPadding,
        ),
        side: BorderSide(color: AppColors.outline),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppConstants.defaultRadius),
        ),
      ),
    );
  }

  void _handleAccountCreation() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (!_allRequirementsMet) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please meet all password requirements'),
          backgroundColor: AppColors.error,
        ),
      );
      return;
    }

    if (!_consentGiven) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please consent to the privacy policy'),
          backgroundColor: AppColors.error,
        ),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    // TODO: Implement actual account creation logic
    await Future.delayed(const Duration(seconds: 2));

    if (mounted) {
      setState(() {
        _isLoading = false;
      });
      
      // Navigate to confirm login screen
      context.go(AppRoutes.confirmLogin);
    }
  }
}