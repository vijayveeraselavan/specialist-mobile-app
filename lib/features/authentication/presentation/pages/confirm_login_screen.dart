import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/constants/app_routes.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/responsive_builder.dart';

class ConfirmLoginScreen extends StatefulWidget {
  const ConfirmLoginScreen({super.key});

  @override
  State<ConfirmLoginScreen> createState() => _ConfirmLoginScreenState();
}

class _ConfirmLoginScreenState extends State<ConfirmLoginScreen> with TickerProviderStateMixin {
  final List<TextEditingController> _otpControllers = List.generate(5, (index) => TextEditingController());
  final List<FocusNode> _focusNodes = List.generate(5, (index) => FocusNode());
  
  late AnimationController _slideController;
  late AnimationController _fadeController;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _fadeAnimation;
  
  bool _isLoading = false;
  String? _errorMessage;
  bool _isComplete = false;
  String _selectedMethod = 'SMS'; // SMS or Email

  @override
  void initState() {
    super.initState();
    _setupAnimations();
    _startAnimations();
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

  String get _otpValue {
    return _otpControllers.map((controller) => controller.text).join();
  }

  bool get _isOtpComplete {
    return _otpValue.length == 5;
  }

  @override
  void dispose() {
    for (var controller in _otpControllers) {
      controller.dispose();
    }
    for (var node in _focusNodes) {
      node.dispose();
    }
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
                          _buildOtpInput(),
                          if (_errorMessage != null) ...[
                            const SizedBox(height: AppConstants.defaultPadding),
                            _buildErrorMessage(),
                          ],
                          const SizedBox(height: AppConstants.extraLargePadding),
                          _buildResendSection(),
                          const SizedBox(height: AppConstants.largePadding),
                          _buildMethodSelection(),
                          const SizedBox(height: AppConstants.extraLargePadding),
                          _buildLoginButton(),
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
          'Confirm login',
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: AppConstants.smallPadding),
        Text(
          'Please enter the 5 digits of the CMS or email',
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
            color: AppColors.textSecondary,
          ),
        ),
      ],
    );
  }

  Widget _buildOtpInput() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: List.generate(5, (index) {
        return SizedBox(
          width: 50,
          height: 60,
          child: TextFormField(
            controller: _otpControllers[index],
            focusNode: _focusNodes[index],
            textAlign: TextAlign.center,
            keyboardType: TextInputType.number,
            maxLength: 1,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            decoration: InputDecoration(
              counterText: '',
              filled: true,
              fillColor: _isComplete && index < _otpValue.length 
                  ? AppColors.success.withValues(alpha: 0.1)
                  : AppColors.surface,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppConstants.defaultRadius),
                borderSide: BorderSide(
                  color: _errorMessage != null 
                      ? AppColors.error 
                      : _isComplete && index < _otpValue.length
                          ? AppColors.success
                          : AppColors.outline,
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppConstants.defaultRadius),
                borderSide: BorderSide(
                  color: _errorMessage != null 
                      ? AppColors.error 
                      : _isComplete && index < _otpValue.length
                          ? AppColors.success
                          : AppColors.outline,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppConstants.defaultRadius),
                borderSide: BorderSide(
                  color: _errorMessage != null 
                      ? AppColors.error 
                      : AppColors.primary, 
                  width: 2,
                ),
              ),
            ),
            onChanged: (value) {
              setState(() {
                _errorMessage = null; // Clear error when user types
              });
              
              if (value.isNotEmpty && index < 4) {
                _focusNodes[index + 1].requestFocus();
              } else if (value.isEmpty && index > 0) {
                _focusNodes[index - 1].requestFocus();
              }
              
              // Check if OTP is complete
              if (_isOtpComplete) {
                setState(() {
                  _isComplete = true;
                });
              }
            },
          ),
        );
      }),
    );
  }

  Widget _buildErrorMessage() {
    return Container(
      padding: const EdgeInsets.all(AppConstants.defaultPadding),
      decoration: BoxDecoration(
        color: AppColors.error.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(AppConstants.defaultRadius),
        border: Border.all(color: AppColors.error.withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          Icon(
            Icons.error_outline,
            color: AppColors.error,
            size: 20,
          ),
          const SizedBox(width: AppConstants.smallPadding),
          Expanded(
            child: Text(
              _errorMessage!,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppColors.error,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildResendSection() {
    return Center(
      child: Column(
        children: [
          Text(
            "Didn't receive the code?",
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: AppConstants.smallPadding),
          TextButton(
            onPressed: _handleResendCode,
            child: Text(
              'Request a new one',
              style: TextStyle(
                color: AppColors.primary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMethodSelection() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildMethodButton('SMS', Icons.sms),
        const SizedBox(width: AppConstants.defaultPadding),
        _buildMethodButton('Email', Icons.email),
      ],
    );
  }

  Widget _buildMethodButton(String method, IconData icon) {
    final isSelected = _selectedMethod == method;
    
    return OutlinedButton.icon(
      onPressed: () {
        setState(() {
          _selectedMethod = method;
        });
        _handleResendCode();
      },
      icon: Icon(
        icon,
        color: isSelected ? AppColors.primary : AppColors.textSecondary,
        size: 18,
      ),
      label: Text(
        method,
        style: TextStyle(
          color: isSelected ? AppColors.primary : AppColors.textSecondary,
          fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
        ),
      ),
      style: OutlinedButton.styleFrom(
        side: BorderSide(
          color: isSelected ? AppColors.primary : AppColors.outline,
          width: isSelected ? 2 : 1,
        ),
        backgroundColor: isSelected ? AppColors.primary.withValues(alpha: 0.1) : null,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppConstants.defaultRadius),
        ),
      ),
    );
  }

  Widget _buildLoginButton() {
    return AppButton.primary(
      text: 'Log in',
      onPressed: (_isLoading || !_isOtpComplete) ? null : _handleLogin,
      size: AppButtonSize.large,
      isLoading: _isLoading,
      icon: Icons.arrow_forward,
      iconAfterText: true,
    );
  }

  void _handleResendCode() {
    // TODO: Implement resend code logic
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Code sent via $_selectedMethod'),
        backgroundColor: AppColors.info,
      ),
    );
  }

  void _handleLogin() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    // Simulate API call
    await Future.delayed(const Duration(seconds: 2));

    if (mounted) {
      // Simulate validation (you can replace this with actual validation logic)
      final enteredCode = _otpValue;
      const correctCode = '57474'; // This would come from your backend
      
      if (enteredCode == correctCode) {
        // Success - navigate to second splash screen with file onboard as next route
        context.go('${AppRoutes.secondSplash}?nextRoute=${AppRoutes.fileOnboard}');
      } else {
        // Error - show error message
        setState(() {
          _isLoading = false;
          _errorMessage = 'The code entered is incorrect. Please enter the correct code or request a new one.';
          _isComplete = false;
        });
      }
    }
  }
}