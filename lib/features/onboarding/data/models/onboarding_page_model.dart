import '../../domain/entities/onboarding_page.dart';

class OnboardingPageModel extends OnboardingPage {
  const OnboardingPageModel({
    required super.id,
    required super.titleKey,
    required super.descriptionKey,
    required super.imagePath,
    super.animationPath,
    super.metadata,
  });

  factory OnboardingPageModel.fromEntity(OnboardingPage entity) {
    return OnboardingPageModel(
      id: entity.id,
      titleKey: entity.titleKey,
      descriptionKey: entity.descriptionKey,
      imagePath: entity.imagePath,
      animationPath: entity.animationPath,
      metadata: entity.metadata,
    );
  }

  factory OnboardingPageModel.fromJson(Map<String, dynamic> json) {
    return OnboardingPageModel(
      id: json['id'] ?? '',
      titleKey: json['titleKey'] ?? '',
      descriptionKey: json['descriptionKey'] ?? '',
      imagePath: json['imagePath'] ?? '',
      animationPath: json['animationPath'],
      metadata: json['metadata'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'titleKey': titleKey,
      'descriptionKey': descriptionKey,
      'imagePath': imagePath,
      'animationPath': animationPath,
      'metadata': metadata,
    };
  }

  OnboardingPageModel copyWith({
    String? id,
    String? titleKey,
    String? descriptionKey,
    String? imagePath,
    String? animationPath,
    Map<String, dynamic>? metadata,
  }) {
    return OnboardingPageModel(
      id: id ?? this.id,
      titleKey: titleKey ?? this.titleKey,
      descriptionKey: descriptionKey ?? this.descriptionKey,
      imagePath: imagePath ?? this.imagePath,
      animationPath: animationPath ?? this.animationPath,
      metadata: metadata ?? this.metadata,
    );
  }
}