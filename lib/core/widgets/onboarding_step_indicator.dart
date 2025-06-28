import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../constants/app_constants.dart';

class OnboardingStepIndicator extends StatefulWidget {
  final int currentStep;
  final int totalSteps;
  final List<String>? stepLabels;
  final Color activeColor;
  final Color inactiveColor;
  final Color completedColor;
  final double stepSize;
  final bool showLabels;
  final bool vertical;

  const OnboardingStepIndicator({
    super.key,
    required this.currentStep,
    required this.totalSteps,
    this.stepLabels,
    this.activeColor = AppColors.primary,
    this.inactiveColor = AppColors.textTertiary,
    this.completedColor = AppColors.success,
    this.stepSize = 32.0,
    this.showLabels = false,
    this.vertical = false,
  });

  @override
  State<OnboardingStepIndicator> createState() => _OnboardingStepIndicatorState();
}

class _OnboardingStepIndicatorState extends State<OnboardingStepIndicator>
    with TickerProviderStateMixin {
  late List<AnimationController> _controllers;
  late List<Animation<double>> _scaleAnimations;
  late List<Animation<double>> _fadeAnimations;

  @override
  void initState() {
    super.initState();
    _setupAnimations();
    _animateToCurrentStep();
  }

  @override
  void didUpdateWidget(OnboardingStepIndicator oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.currentStep != widget.currentStep) {
      _animateToCurrentStep();
    }
  }

  void _setupAnimations() {
    _controllers = List.generate(
      widget.totalSteps,
      (index) => AnimationController(
        duration: AppConstants.shortAnimation,
        vsync: this,
      ),
    );

    _scaleAnimations = _controllers.map((controller) =>
        Tween<double>(begin: 0.8, end: 1.0).animate(
          CurvedAnimation(parent: controller, curve: Curves.elasticOut),
        )).toList();

    _fadeAnimations = _controllers.map((controller) =>
        Tween<double>(begin: 0.5, end: 1.0).animate(
          CurvedAnimation(parent: controller, curve: Curves.easeInOut),
        )).toList();
  }

  void _animateToCurrentStep() {
    for (int i = 0; i < widget.totalSteps; i++) {
      if (i <= widget.currentStep) {
        _controllers[i].forward();
      } else {
        _controllers[i].reverse();
      }
    }
  }

  @override
  void dispose() {
    for (final controller in _controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.vertical ? _buildVerticalIndicator() : _buildHorizontalIndicator();
  }

  Widget _buildHorizontalIndicator() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        for (int i = 0; i < widget.totalSteps; i++) ...[
          _buildStep(i),
          if (i < widget.totalSteps - 1) _buildConnector(i),
        ],
      ],
    );
  }

  Widget _buildVerticalIndicator() {
    return Column(
      children: [
        for (int i = 0; i < widget.totalSteps; i++) ...[
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _buildStep(i),
              if (widget.showLabels && widget.stepLabels != null && i < widget.stepLabels!.length)
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(left: AppConstants.defaultPadding),
                    child: _buildStepLabel(i),
                  ),
                ),
            ],
          ),
          if (i < widget.totalSteps - 1) _buildVerticalConnector(i),
        ],
      ],
    );
  }

  Widget _buildStep(int index) {
    final isCompleted = index < widget.currentStep;
    final isActive = index == widget.currentStep;
    final isInactive = index > widget.currentStep;

    Color stepColor;
    if (isCompleted) {
      stepColor = widget.completedColor;
    } else if (isActive) {
      stepColor = widget.activeColor;
    } else {
      stepColor = widget.inactiveColor;
    }

    return AnimatedBuilder(
      animation: _controllers[index],
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimations[index].value,
          child: FadeTransition(
            opacity: _fadeAnimations[index],
            child: Container(
              width: widget.stepSize,
              height: widget.stepSize,
              decoration: BoxDecoration(
                color: stepColor,
                shape: BoxShape.circle,
                border: Border.all(
                  color: stepColor.withValues(alpha: 0.3),
                  width: isActive ? 3 : 1,
                ),
                boxShadow: isActive || isCompleted ? [
                  BoxShadow(
                    color: stepColor.withValues(alpha: 0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ] : null,
              ),
              child: Center(
                child: _buildStepContent(index, stepColor),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildStepContent(int index, Color stepColor) {
    final isCompleted = index < widget.currentStep;
    final isActive = index == widget.currentStep;

    if (isCompleted) {
      return Icon(
        Icons.check,
        size: widget.stepSize * 0.5,
        color: Colors.white,
      );
    } else if (isActive) {
      return Container(
        width: widget.stepSize * 0.3,
        height: widget.stepSize * 0.3,
        decoration: const BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
        ),
      );
    } else {
      return Text(
        '${index + 1}',
        style: TextStyle(
          color: Colors.white,
          fontSize: widget.stepSize * 0.35,
          fontWeight: FontWeight.bold,
        ),
      );
    }
  }

  Widget _buildConnector(int index) {
    final isActive = index < widget.currentStep;
    
    return AnimatedContainer(
      duration: AppConstants.shortAnimation,
      width: 40,
      height: 2,
      margin: const EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
        color: isActive ? widget.completedColor : widget.inactiveColor,
        borderRadius: BorderRadius.circular(1),
      ),
    );
  }

  Widget _buildVerticalConnector(int index) {
    final isActive = index < widget.currentStep;
    
    return AnimatedContainer(
      duration: AppConstants.shortAnimation,
      width: 2,
      height: 40,
      margin: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: isActive ? widget.completedColor : widget.inactiveColor,
        borderRadius: BorderRadius.circular(1),
      ),
    );
  }

  Widget _buildStepLabel(int index) {
    final isCompleted = index < widget.currentStep;
    final isActive = index == widget.currentStep;
    
    Color textColor;
    if (isCompleted) {
      textColor = widget.completedColor;
    } else if (isActive) {
      textColor = widget.activeColor;
    } else {
      textColor = widget.inactiveColor;
    }

    return AnimatedDefaultTextStyle(
      duration: AppConstants.shortAnimation,
      style: Theme.of(context).textTheme.bodyMedium!.copyWith(
        color: textColor,
        fontWeight: isActive ? FontWeight.w600 : FontWeight.normal,
      ),
      child: Text(
        widget.stepLabels![index],
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }
}