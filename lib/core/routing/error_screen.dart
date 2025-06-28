import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../constants/app_constants.dart';
import '../widgets/app_button.dart';

class ErrorScreen extends StatelessWidget {
  final String error;
  
  const ErrorScreen({
    super.key,
    required this.error,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppConstants.largePadding),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Error Icon
              Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  color: AppColors.error.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.error_outline,
                  size: 60,
                  color: AppColors.error,
                ),
              ),
              
              const SizedBox(height: AppConstants.extraLargePadding),
              
              // Error Title
              Text(
                'Oops! Something went wrong',
                style: theme.textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppColors.error,
                ),
                textAlign: TextAlign.center,
              ),
              
              const SizedBox(height: AppConstants.defaultPadding),
              
              // Error Message
              Text(
                error,
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: theme.textTheme.bodyLarge?.color?.withOpacity(0.8),
                ),
                textAlign: TextAlign.center,
              ),
              
              const SizedBox(height: AppConstants.extraLargePadding),
              
              // Retry Button
              SizedBox(
                width: double.infinity,
                child: AppButton.primary(
                  text: 'Go Back',
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  size: AppButtonSize.large,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}