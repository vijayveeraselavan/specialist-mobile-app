import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../constants/app_constants.dart';

enum AppButtonType { primary, secondary, outline, text }

enum AppButtonSize { small, medium, large }

class AppButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final AppButtonType type;
  final AppButtonSize size;
  final bool isLoading;
  final bool isDisabled;
  final IconData? icon;
  final bool iconAfterText;
  final double? width;
  final BorderRadius? borderRadius;

  const AppButton({
    super.key,
    required this.text,
    this.onPressed,
    this.type = AppButtonType.primary,
    this.size = AppButtonSize.medium,
    this.isLoading = false,
    this.isDisabled = false,
    this.icon,
    this.iconAfterText = false,
    this.width,
    this.borderRadius,
  });

  // Primary Button Constructor
  const AppButton.primary({
    super.key,
    required this.text,
    this.onPressed,
    this.size = AppButtonSize.medium,
    this.isLoading = false,
    this.isDisabled = false,
    this.icon,
    this.iconAfterText = false,
    this.width,
    this.borderRadius,
  }) : type = AppButtonType.primary;

  // Secondary Button Constructor
  const AppButton.secondary({
    super.key,
    required this.text,
    this.onPressed,
    this.size = AppButtonSize.medium,
    this.isLoading = false,
    this.isDisabled = false,
    this.icon,
    this.iconAfterText = false,
    this.width,
    this.borderRadius,
  }) : type = AppButtonType.secondary;

  // Outline Button Constructor
  const AppButton.outline({
    super.key,
    required this.text,
    this.onPressed,
    this.size = AppButtonSize.medium,
    this.isLoading = false,
    this.isDisabled = false,
    this.icon,
    this.iconAfterText = false,
    this.width,
    this.borderRadius,
  }) : type = AppButtonType.outline;

  // Text Button Constructor
  const AppButton.text({
    super.key,
    required this.text,
    this.onPressed,
    this.size = AppButtonSize.medium,
    this.isLoading = false,
    this.isDisabled = false,
    this.icon,
    this.iconAfterText = false,
    this.width,
    this.borderRadius,
  }) : type = AppButtonType.text;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return SizedBox(
      width: width,
      height: _getButtonHeight(),
      child: _buildButton(context, isDark),
    );
  }

  Widget _buildButton(BuildContext context, bool isDark) {
    final VoidCallback? effectiveOnPressed = 
        (isLoading || isDisabled) ? null : onPressed;

    switch (type) {
      case AppButtonType.primary:
        return _buildElevatedButton(context, effectiveOnPressed);
      case AppButtonType.secondary:
        return _buildSecondaryButton(context, effectiveOnPressed);
      case AppButtonType.outline:
        return _buildOutlinedButton(context, effectiveOnPressed);
      case AppButtonType.text:
        return _buildTextButton(context, effectiveOnPressed);
    }
  }

  Widget _buildElevatedButton(BuildContext context, VoidCallback? onPressed) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.onPrimary,
        disabledBackgroundColor: AppColors.textTertiary,
        disabledForegroundColor: AppColors.textInverse,
        elevation: type == AppButtonType.primary ? 2 : 0,
        padding: _getButtonPadding(),
        shape: RoundedRectangleBorder(
          borderRadius: borderRadius ?? BorderRadius.circular(AppConstants.defaultRadius),
        ),
        textStyle: _getTextStyle(context),
      ),
      child: _buildButtonContent(),
    );
  }

  Widget _buildSecondaryButton(BuildContext context, VoidCallback? onPressed) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.accent,
        foregroundColor: AppColors.onSecondary,
        disabledBackgroundColor: AppColors.textTertiary,
        disabledForegroundColor: AppColors.textInverse,
        elevation: 1,
        padding: _getButtonPadding(),
        shape: RoundedRectangleBorder(
          borderRadius: borderRadius ?? BorderRadius.circular(AppConstants.defaultRadius),
        ),
        textStyle: _getTextStyle(context),
      ),
      child: _buildButtonContent(),
    );
  }

  Widget _buildOutlinedButton(BuildContext context, VoidCallback? onPressed) {
    return OutlinedButton(
      onPressed: onPressed,
      style: OutlinedButton.styleFrom(
        foregroundColor: AppColors.primary,
        disabledForegroundColor: AppColors.textTertiary,
        side: BorderSide(
          color: isDisabled ? AppColors.textTertiary : AppColors.primary,
          width: 1.5,
        ),
        padding: _getButtonPadding(),
        shape: RoundedRectangleBorder(
          borderRadius: borderRadius ?? BorderRadius.circular(AppConstants.defaultRadius),
        ),
        textStyle: _getTextStyle(context),
      ),
      child: _buildButtonContent(),
    );
  }

  Widget _buildTextButton(BuildContext context, VoidCallback? onPressed) {
    return TextButton(
      onPressed: onPressed,
      style: TextButton.styleFrom(
        foregroundColor: AppColors.primary,
        disabledForegroundColor: AppColors.textTertiary,
        padding: _getButtonPadding(),
        shape: RoundedRectangleBorder(
          borderRadius: borderRadius ?? BorderRadius.circular(AppConstants.defaultRadius),
        ),
        textStyle: _getTextStyle(context),
      ),
      child: _buildButtonContent(),
    );
  }

  Widget _buildButtonContent() {
    if (isLoading) {
      return SizedBox(
        width: _getIconSize(),
        height: _getIconSize(),
        child: const CircularProgressIndicator(
          strokeWidth: 2,
          valueColor: AlwaysStoppedAnimation<Color>(AppColors.onPrimary),
        ),
      );
    }

    final List<Widget> children = [];

    if (icon != null && !iconAfterText) {
      children.add(Icon(icon, size: _getIconSize()));
      children.add(const SizedBox(width: 8));
    }

    children.add(
      Text(
        text,
        style: _getTextStyle(null),
        textAlign: TextAlign.center,
      ),
    );

    if (icon != null && iconAfterText) {
      children.add(const SizedBox(width: 8));
      children.add(Icon(icon, size: _getIconSize()));
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: children,
    );
  }

  double _getButtonHeight() {
    switch (size) {
      case AppButtonSize.small:
        return 36;
      case AppButtonSize.medium:
        return 48;
      case AppButtonSize.large:
        return 56;
    }
  }

  EdgeInsets _getButtonPadding() {
    switch (size) {
      case AppButtonSize.small:
        return const EdgeInsets.symmetric(horizontal: 16, vertical: 8);
      case AppButtonSize.medium:
        return const EdgeInsets.symmetric(horizontal: 24, vertical: 12);
      case AppButtonSize.large:
        return const EdgeInsets.symmetric(horizontal: 32, vertical: 16);
    }
  }

  double _getIconSize() {
    switch (size) {
      case AppButtonSize.small:
        return 16;
      case AppButtonSize.medium:
        return 20;
      case AppButtonSize.large:
        return 24;
    }
  }

  TextStyle? _getTextStyle(BuildContext? context) {
    double fontSize;
    FontWeight fontWeight = FontWeight.w600;

    switch (size) {
      case AppButtonSize.small:
        fontSize = 14;
        break;
      case AppButtonSize.medium:
        fontSize = 16;
        break;
      case AppButtonSize.large:
        fontSize = 18;
        break;
    }

    return TextStyle(
      fontSize: fontSize,
      fontWeight: fontWeight,
    );
  }
}