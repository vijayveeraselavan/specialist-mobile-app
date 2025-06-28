import 'package:flutter/material.dart';
import '../constants/app_constants.dart';

enum DeviceType { mobile, tablet, desktop }

class ResponsiveBuilder extends StatelessWidget {
  final Widget Function(BuildContext context, DeviceType deviceType) builder;
  final Widget? mobile;
  final Widget? tablet;
  final Widget? desktop;

  const ResponsiveBuilder({
    super.key,
    required this.builder,
  }) : mobile = null, tablet = null, desktop = null;

  const ResponsiveBuilder.widgets({
    super.key,
    this.mobile,
    this.tablet,
    this.desktop,
  }) : builder = _defaultBuilder;

  static Widget _defaultBuilder(BuildContext context, DeviceType deviceType) {
    return const SizedBox.shrink();
  }

  @override
  Widget build(BuildContext context) {
    final deviceType = getDeviceType(context);
    
    if (mobile != null || tablet != null || desktop != null) {
      switch (deviceType) {
        case DeviceType.mobile:
          return mobile ?? tablet ?? desktop ?? const SizedBox.shrink();
        case DeviceType.tablet:
          return tablet ?? desktop ?? mobile ?? const SizedBox.shrink();
        case DeviceType.desktop:
          return desktop ?? tablet ?? mobile ?? const SizedBox.shrink();
      }
    }
    
    return builder(context, deviceType);
  }

  static DeviceType getDeviceType(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    
    if (screenWidth < AppConstants.mobileBreakpoint) {
      return DeviceType.mobile;
    } else if (screenWidth < AppConstants.tabletBreakpoint) {
      return DeviceType.tablet;
    } else {
      return DeviceType.desktop;
    }
  }

  static bool isMobile(BuildContext context) {
    return getDeviceType(context) == DeviceType.mobile;
  }

  static bool isTablet(BuildContext context) {
    return getDeviceType(context) == DeviceType.tablet;
  }

  static bool isDesktop(BuildContext context) {
    return getDeviceType(context) == DeviceType.desktop;
  }
}

class ResponsivePadding extends StatelessWidget {
  final Widget child;
  final EdgeInsets? mobile;
  final EdgeInsets? tablet;
  final EdgeInsets? desktop;

  const ResponsivePadding({
    super.key,
    required this.child,
    this.mobile,
    this.tablet,
    this.desktop,
  });

  @override
  Widget build(BuildContext context) {
    return ResponsiveBuilder(
      builder: (context, deviceType) {
        EdgeInsets padding;
        
        switch (deviceType) {
          case DeviceType.mobile:
            padding = mobile ?? const EdgeInsets.all(AppConstants.defaultPadding);
            break;
          case DeviceType.tablet:
            padding = tablet ?? const EdgeInsets.all(AppConstants.largePadding);
            break;
          case DeviceType.desktop:
            padding = desktop ?? const EdgeInsets.all(AppConstants.extraLargePadding);
            break;
        }
        
        return Padding(
          padding: padding,
          child: child,
        );
      },
    );
  }
}

class ResponsiveConstraints extends StatelessWidget {
  final Widget child;
  final double? maxWidth;
  final double? maxHeight;
  final bool centerHorizontally;
  final bool centerVertically;

  const ResponsiveConstraints({
    super.key,
    required this.child,
    this.maxWidth,
    this.maxHeight,
    this.centerHorizontally = true,
    this.centerVertically = false,
  });

  @override
  Widget build(BuildContext context) {
    Widget constrainedChild = ConstrainedBox(
      constraints: BoxConstraints(
        maxWidth: maxWidth ?? double.infinity,
        maxHeight: maxHeight ?? double.infinity,
      ),
      child: child,
    );

    if (centerHorizontally) {
      constrainedChild = Center(child: constrainedChild);
    }

    if (centerVertically && !centerHorizontally) {
      constrainedChild = Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [constrainedChild],
      );
    }

    return constrainedChild;
  }
}

class ResponsiveColumns extends StatelessWidget {
  final List<Widget> children;
  final int mobileColumns;
  final int tabletColumns;
  final int desktopColumns;
  final double spacing;
  final double runSpacing;
  final WrapAlignment alignment;
  final WrapCrossAlignment crossAxisAlignment;

  const ResponsiveColumns({
    super.key,
    required this.children,
    this.mobileColumns = 1,
    this.tabletColumns = 2,
    this.desktopColumns = 3,
    this.spacing = AppConstants.defaultPadding,
    this.runSpacing = AppConstants.defaultPadding,
    this.alignment = WrapAlignment.start,
    this.crossAxisAlignment = WrapCrossAlignment.start,
  });

  @override
  Widget build(BuildContext context) {
    return ResponsiveBuilder(
      builder: (context, deviceType) {
        int columns;
        
        switch (deviceType) {
          case DeviceType.mobile:
            columns = mobileColumns;
            break;
          case DeviceType.tablet:
            columns = tabletColumns;
            break;
          case DeviceType.desktop:
            columns = desktopColumns;
            break;
        }

        final screenWidth = MediaQuery.of(context).size.width;
        final availableWidth = screenWidth - (spacing * (columns - 1));
        final itemWidth = availableWidth / columns;

        return Wrap(
          spacing: spacing,
          runSpacing: runSpacing,
          alignment: alignment,
          crossAxisAlignment: crossAxisAlignment,
          children: children.map((child) {
            return SizedBox(
              width: itemWidth,
              child: child,
            );
          }).toList(),
        );
      },
    );
  }
}