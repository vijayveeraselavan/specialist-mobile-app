import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../constants/app_constants.dart';
import 'responsive_builder.dart';

class FeatureShowcaseCard extends StatefulWidget {
  final IconData icon;
  final String title;
  final String description;
  final List<String> features;
  final Color? accentColor;
  final VoidCallback? onTap;
  final bool isExpanded;
  final Widget? customIcon;

  const FeatureShowcaseCard({
    super.key,
    required this.icon,
    required this.title,
    required this.description,
    this.features = const [],
    this.accentColor,
    this.onTap,
    this.isExpanded = false,
    this.customIcon,
  });

  @override
  State<FeatureShowcaseCard> createState() => _FeatureShowcaseCardState();
}

class _FeatureShowcaseCardState extends State<FeatureShowcaseCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;
  bool _isHovered = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: AppConstants.shortAnimation,
      vsync: this,
    );

    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 1.02,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));

    _fadeAnimation = Tween<double>(
      begin: 0.8,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onHoverChanged(bool isHovered) {
    setState(() {
      _isHovered = isHovered;
    });
    if (isHovered) {
      _controller.forward();
    } else {
      _controller.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final accentColor = widget.accentColor ?? AppColors.primary;
    
    return ResponsiveBuilder(
      builder: (context, deviceType) {
        return AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            return Transform.scale(
              scale: _scaleAnimation.value,
              child: MouseRegion(
                onEnter: (_) => _onHoverChanged(true),
                onExit: (_) => _onHoverChanged(false),
                child: GestureDetector(
                  onTap: widget.onTap,
                  child: Container(
                    margin: const EdgeInsets.only(bottom: AppConstants.defaultPadding),
                    padding: const EdgeInsets.all(AppConstants.largePadding),
                    decoration: BoxDecoration(
                      color: theme.cardColor,
                      borderRadius: BorderRadius.circular(AppConstants.largeRadius),
                      border: Border.all(
                        color: _isHovered 
                            ? accentColor.withValues(alpha: 0.3)
                            : theme.dividerColor.withValues(alpha: 0.1),
                        width: _isHovered ? 2 : 1,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: _isHovered 
                              ? accentColor.withValues(alpha: 0.1)
                              : Colors.black.withValues(alpha: 0.05),
                          blurRadius: _isHovered ? 20 : 8,
                          offset: Offset(0, _isHovered ? 8 : 4),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Icon and Title Row
                        Row(
                          children: [
                            _buildIcon(theme, accentColor),
                            const SizedBox(width: AppConstants.defaultPadding),
                            Expanded(
                              child: _buildTitle(theme, accentColor),
                            ),
                            if (widget.features.isNotEmpty)
                              _buildExpandIcon(theme),
                          ],
                        ),
                        
                        const SizedBox(height: AppConstants.defaultPadding),
                        
                        // Description
                        _buildDescription(theme),
                        
                        // Features List (if expanded)
                        if (widget.isExpanded && widget.features.isNotEmpty) ...[
                          const SizedBox(height: AppConstants.defaultPadding),
                          _buildFeaturesList(theme, accentColor),
                        ],
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildIcon(ThemeData theme, Color accentColor) {
    return Container(
      width: 56,
      height: 56,
      decoration: BoxDecoration(
        color: accentColor.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(AppConstants.defaultRadius),
        border: Border.all(
          color: accentColor.withValues(alpha: 0.2),
        ),
      ),
      child: widget.customIcon ?? Icon(
        widget.icon,
        size: 28,
        color: accentColor,
      ),
    );
  }

  Widget _buildTitle(ThemeData theme, Color accentColor) {
    return Text(
      widget.title,
      style: ResponsiveBuilder.isMobile(context)
          ? theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
              color: _isHovered ? accentColor : null,
            )
          : theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
              color: _isHovered ? accentColor : null,
            ),
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
    );
  }

  Widget _buildDescription(ThemeData theme) {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: Text(
        widget.description,
        style: theme.textTheme.bodyLarge?.copyWith(
          height: 1.5,
          color: theme.textTheme.bodyLarge?.color?.withValues(alpha: 0.8),
        ),
        maxLines: widget.isExpanded ? null : 3,
        overflow: widget.isExpanded ? null : TextOverflow.ellipsis,
      ),
    );
  }

  Widget _buildExpandIcon(ThemeData theme) {
    return AnimatedRotation(
      turns: widget.isExpanded ? 0.5 : 0.0,
      duration: AppConstants.shortAnimation,
      child: Icon(
        Icons.keyboard_arrow_down,
        color: theme.iconTheme.color?.withValues(alpha: 0.6),
      ),
    );
  }

  Widget _buildFeaturesList(ThemeData theme, Color accentColor) {
    return AnimatedContainer(
      duration: AppConstants.shortAnimation,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Key Features:',
            style: theme.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w600,
              color: accentColor,
            ),
          ),
          const SizedBox(height: AppConstants.smallPadding),
          ...widget.features.map((feature) => Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 6,
                  height: 6,
                  margin: const EdgeInsets.only(top: 8, right: 12),
                  decoration: BoxDecoration(
                    color: accentColor,
                    shape: BoxShape.circle,
                  ),
                ),
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
          )),
        ],
      ),
    );
  }
}