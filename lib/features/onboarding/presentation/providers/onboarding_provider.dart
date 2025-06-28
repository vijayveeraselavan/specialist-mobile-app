import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../domain/entities/onboarding_page.dart';
import '../../domain/entities/user_role.dart';
import '../../domain/usecases/get_onboarding_pages.dart';
import '../../domain/usecases/complete_onboarding.dart';
import '../../domain/usecases/check_onboarding_status.dart';

enum OnboardingState { initial, loading, loaded, error, completed }

class OnboardingProvider extends ChangeNotifier {
  final GetOnboardingPages _getOnboardingPages;
  final CompleteOnboarding _completeOnboarding;
  final CheckOnboardingStatus _checkOnboardingStatus;

  OnboardingProvider({
    required GetOnboardingPages getOnboardingPages,
    required CompleteOnboarding completeOnboarding,
    required CheckOnboardingStatus checkOnboardingStatus,
  })  : _getOnboardingPages = getOnboardingPages,
        _completeOnboarding = completeOnboarding,
        _checkOnboardingStatus = checkOnboardingStatus;

  // State
  OnboardingState _state = OnboardingState.initial;
  List<OnboardingPage> _pages = [];
  int _currentIndex = 0;
  UserRoleType? _selectedRole;
  String? _errorMessage;
  bool _isCompleted = false;
  bool _canSkip = true;

  // Getters
  OnboardingState get state => _state;
  List<OnboardingPage> get pages => _pages;
  int get currentIndex => _currentIndex;
  UserRoleType? get selectedRole => _selectedRole;
  String? get errorMessage => _errorMessage;
  bool get isCompleted => _isCompleted;
  bool get canSkip => _canSkip;
  bool get isFirstPage => _currentIndex == 0;
  bool get isLastPage => _currentIndex == _pages.length - 1;
  bool get isLoading => _state == OnboardingState.loading;
  bool get hasError => _state == OnboardingState.error;
  OnboardingPage? get currentPage => 
      _pages.isNotEmpty && _currentIndex < _pages.length 
          ? _pages[_currentIndex] 
          : null;

  // Methods
  Future<void> initialize() async {
    _setState(OnboardingState.loading);
    try {
      final status = await _checkOnboardingStatus();
      if (status.isCompleted) {
        _isCompleted = true;
        _setState(OnboardingState.completed);
        return;
      }

      _pages = await _getOnboardingPages();
      _currentIndex = status.currentProgress;
      _setState(OnboardingState.loaded);
    } catch (e) {
      _errorMessage = e.toString();
      _setState(OnboardingState.error);
    }
  }

  void nextPage() {
    if (_currentIndex < _pages.length - 1) {
      _currentIndex++;
      notifyListeners();
    }
  }

  void previousPage() {
    if (_currentIndex > 0) {
      _currentIndex--;
      notifyListeners();
    }
  }

  void goToPage(int index) {
    if (index >= 0 && index < _pages.length) {
      _currentIndex = index;
      notifyListeners();
    }
  }

  void setSelectedRole(UserRoleType? role) {
    _selectedRole = role;
    notifyListeners();
  }

  Future<void> completeOnboarding() async {
    _setState(OnboardingState.loading);
    try {
      await _completeOnboarding(_selectedRole);
      _isCompleted = true;
      _setState(OnboardingState.completed);
    } catch (e) {
      _errorMessage = e.toString();
      _setState(OnboardingState.error);
    }
  }

  Future<void> skipOnboarding() async {
    if (_canSkip) {
      await completeOnboarding();
    }
  }

  void retry() {
    _errorMessage = null;
    initialize();
  }

  void reset() {
    _state = OnboardingState.initial;
    _pages = [];
    _currentIndex = 0;
    _selectedRole = null;
    _errorMessage = null;
    _isCompleted = false;
    notifyListeners();
  }

  void _setState(OnboardingState newState) {
    _state = newState;
    notifyListeners();
  }

  // Static helper methods
  static OnboardingProvider of(BuildContext context, {bool listen = true}) {
    return Provider.of<OnboardingProvider>(context, listen: listen);
  }

  static OnboardingProvider read(BuildContext context) {
    return Provider.of<OnboardingProvider>(context, listen: false);
  }
}