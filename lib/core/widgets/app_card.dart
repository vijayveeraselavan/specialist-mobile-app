import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../constants/app_constants.dart';

class AppCard extends StatelessWidget {
  final Widget child;
  final EdgeInsets? padding;
  final EdgeInsets? margin;
  final BorderRadius? borderRadius;
  final Color? backgroundColor;
  final Color? shadowColor;
  final double? elevation;
  final Border? border;
  final VoidCallback? onTap;
  final bool isSelected;
  final bool isDisabled;

  const AppCard({
    super.key,
    required this.child,
    this.padding,
    this.margin,
    this.borderRadius,
    this.backgroundColor,
    this.shadowColor,
    this.elevation,
    this.border,
    this.onTap,
    this.isSelected = false,
    this.isDisabled = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final Widget cardChild = Container(
      padding: padding ?? const EdgeInsets.all(AppConstants.defaultPadding),
      decoration: BoxDecoration(
        color: backgroundColor ?? theme.cardColor,
        borderRadius: borderRadius ?? BorderRadius.circular(AppConstants.largeRadius),
        border: border ?? _getBorder(isDark),
        boxShadow: _getBoxShadow(isDark),
      ),
      child: child,
    );

    if (onTap != null && !isDisabled) {
      return Container(
        margin: margin,
        child: Material(
          color: Colors.transparent,
          borderRadius: borderRadius ?? BorderRadius.circular(AppConstants.largeRadius),
          child: InkWell(
            onTap: onTap,
            borderRadius: borderRadius ?? BorderRadius.circular(AppConstants.largeRadius),
            child: cardChild,
          ),
        ),
      );
    }

    return Container(
      margin: margin,
      child: cardChild,
    );
  }

  Border? _getBorder(bool isDark) {
    if (isSelected) {
      return Border.all(
        color: AppColors.primary,
        width: 2,
      );
    }
    
    if (border != null) return border;
    
    return Border.all(
      color: isDark ? AppColors.borderDark : AppColors.borderLight,
      width: 1,
    );
  }

  List<BoxShadow> _getBoxShadow(bool isDark) {
    if (elevation == 0) return [];
    
    final effectiveElevation = elevation ?? (isSelected ? 4 : 2);
    
    return [
      BoxShadow(
        color: shadowColor ?? (isDark ? AppColors.shadowDark : AppColors.shadowLight),
        offset: Offset(0, effectiveElevation),
        blurRadius: effectiveElevation * 2,
        spreadRadius: 0,
      ),
    ];
  }
}

class AppSelectableCard extends StatelessWidget {
  final Widget child;
  final bool isSelected;
  final VoidCallback? onTap;
  final EdgeInsets? padding;
  final EdgeInsets? margin;
  final String? title;
  final String? subtitle;
  final IconData? icon;
  final Widget? leading;
  final Widget? trailing;

  const AppSelectableCard({
    super.key,
    required this.child,
    this.isSelected = false,
    this.onTap,
    this.padding,
    this.margin,
    this.title,
    this.subtitle,
    this.icon,
    this.leading,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AppCard(
      onTap: onTap,
      isSelected: isSelected,
      padding: padding ?? const EdgeInsets.all(AppConstants.defaultPadding),
      margin: margin,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (leading != null || icon != null || title != null || trailing != null)
            Row(
              children: [
                if (leading != null) leading!,
                if (icon != null) 
                  Icon(
                    icon,
                    size: 24,
                    color: isSelected ? AppColors.primary : theme.iconTheme.color,
                  ),
                if ((leading != null || icon != null) && title != null)
                  const SizedBox(width: 12),
                if (title != null)
                  Expanded(
                    child: Text(
                      title!,
                      style: theme.textTheme.titleLarge?.copyWith(
                        color: isSelected ? AppColors.primary : null,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                if (trailing != null) trailing!,
                if (isSelected)
                  Icon(
                    Icons.check_circle,
                    color: AppColors.primary,
                    size: 24,
                  ),
              ],
            ),
          if (subtitle != null) ...[
            const SizedBox(height: 8),
            Text(
              subtitle!,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.textTheme.bodyMedium?.color?.withOpacity(0.7),
              ),
            ),
          ],
          if (title != null || subtitle != null)
            const SizedBox(height: 12),
          child,
        ],
      ),
    );
  }
}