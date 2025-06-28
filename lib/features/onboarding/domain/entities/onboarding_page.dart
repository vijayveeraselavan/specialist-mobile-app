import 'package:equatable/equatable.dart';

class OnboardingPage extends Equatable {
  final String id;
  final String titleKey;
  final String descriptionKey;
  final String imagePath;
  final String? animationPath;
  final Map<String, dynamic>? metadata;

  const OnboardingPage({
    required this.id,
    required this.titleKey,
    required this.descriptionKey,
    required this.imagePath,
    this.animationPath,
    this.metadata,
  });

  @override
  List<Object?> get props => [
        id,
        titleKey,
        descriptionKey,
        imagePath,
        animationPath,
        metadata,
      ];

  OnboardingPage copyWith({
    String? id,
    String? titleKey,
    String? descriptionKey,
    String? imagePath,
    String? animationPath,
    Map<String, dynamic>? metadata,
  }) {
    return OnboardingPage(
      id: id ?? this.id,
      titleKey: titleKey ?? this.titleKey,
      descriptionKey: descriptionKey ?? this.descriptionKey,
      imagePath: imagePath ?? this.imagePath,
      animationPath: animationPath ?? this.animationPath,
      metadata: metadata ?? this.metadata,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'titleKey': titleKey,
      'descriptionKey': descriptionKey,
      'imagePath': imagePath,
      'animationPath': animationPath,
      'metadata': metadata,
    };
  }

  factory OnboardingPage.fromMap(Map<String, dynamic> map) {
    return OnboardingPage(
      id: map['id'] ?? '',
      titleKey: map['titleKey'] ?? '',
      descriptionKey: map['descriptionKey'] ?? '',
      imagePath: map['imagePath'] ?? '',
      animationPath: map['animationPath'],
      metadata: map['metadata'],
    );
  }
}