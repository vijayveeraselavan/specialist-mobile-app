import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/constants/app_constants.dart';

class PageIndicator extends StatelessWidget {
  final int itemCount;
  final int currentIndex;
  final Color activeColor;
  final Color inactiveColor;
  final double activeWidth;
  final double inactiveWidth;
  final double height;
  final double spacing;

  const PageIndicator({
    super.key,
    required this.itemCount,
    required this.currentIndex,
    this.activeColor = AppColors.primary,
    this.inactiveColor = AppColors.textTertiary,
    this.activeWidth = 32.0,
    this.inactiveWidth = 8.0,
    this.height = 8.0,
    this.spacing = 8.0,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        itemCount,
        (index) => AnimatedContainer(
          duration: AppConstants.shortAnimation,
          curve: Curves.easeInOut,
          width: index == currentIndex ? activeWidth : inactiveWidth,
          height: height,
          margin: EdgeInsets.symmetric(horizontal: spacing / 2),
          decoration: BoxDecoration(
            color: index == currentIndex ? activeColor : inactiveColor,
            borderRadius: BorderRadius.circular(height / 2),
          ),
        ),
      ),
    );
  }
}

class DotPageIndicator extends StatelessWidget {
  final int itemCount;
  final int currentIndex;
  final Color activeColor;
  final Color inactiveColor;
  final double size;
  final double spacing;

  const DotPageIndicator({
    super.key,
    required this.itemCount,
    required this.currentIndex,
    this.activeColor = AppColors.primary,
    this.inactiveColor = AppColors.textTertiary,
    this.size = 10.0,
    this.spacing = 12.0,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        itemCount,
        (index) => AnimatedContainer(
          duration: AppConstants.shortAnimation,
          curve: Curves.easeInOut,
          width: size,
          height: size,
          margin: EdgeInsets.symmetric(horizontal: spacing / 2),
          decoration: BoxDecoration(
            color: index == currentIndex ? activeColor : inactiveColor,
            shape: BoxShape.circle,
          ),
        ),
      ),
    );
  }
}

class NumberedPageIndicator extends StatelessWidget {
  final int itemCount;
  final int currentIndex;
  final Color activeColor;
  final Color inactiveColor;
  final Color activeTextColor;
  final Color inactiveTextColor;
  final double size;
  final double spacing;

  const NumberedPageIndicator({
    super.key,
    required this.itemCount,
    required this.currentIndex,
    this.activeColor = AppColors.primary,
    this.inactiveColor = AppColors.textTertiary,
    this.activeTextColor = AppColors.onPrimary,
    this.inactiveTextColor = AppColors.textInverse,
    this.size = 32.0,
    this.spacing = 12.0,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        itemCount,
        (index) => AnimatedContainer(
          duration: AppConstants.shortAnimation,
          curve: Curves.easeInOut,
          width: size,
          height: size,
          margin: EdgeInsets.symmetric(horizontal: spacing / 2),
          decoration: BoxDecoration(
            color: index == currentIndex ? activeColor : inactiveColor,
            shape: BoxShape.circle,
            border: index == currentIndex
                ? null
                : Border.all(color: inactiveColor, width: 1),
          ),
          child: Center(
            child: Text(
              '${index + 1}',
              style: TextStyle(
                color: index == currentIndex ? activeTextColor : inactiveTextColor,
                fontWeight: FontWeight.w600,
                fontSize: 14,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class ProgressPageIndicator extends StatelessWidget {
  final int itemCount;
  final int currentIndex;
  final Color backgroundColor;
  final Color progressColor;
  final double height;
  final double borderRadius;

  const ProgressPageIndicator({
    super.key,
    required this.itemCount,
    required this.currentIndex,
    this.backgroundColor = AppColors.textTertiary,
    this.progressColor = AppColors.primary,
    this.height = 6.0,
    this.borderRadius = 3.0,
  });

  @override
  Widget build(BuildContext context) {
    final progress = (currentIndex + 1) / itemCount;
    
    return Container(
      height: height,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      child: FractionallySizedBox(
        alignment: Alignment.centerLeft,
        widthFactor: progress,
        child: AnimatedContainer(
          duration: AppConstants.shortAnimation,
          curve: Curves.easeInOut,
          decoration: BoxDecoration(
            color: progressColor,
            borderRadius: BorderRadius.circular(borderRadius),
          ),
        ),
      ),
    );
  }
}