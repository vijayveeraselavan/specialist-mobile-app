import 'package:equatable/equatable.dart';

enum UserRoleType { patient, specialist }

class UserRole extends Equatable {
  final UserRoleType type;
  final String nameKey;
  final String descriptionKey;
  final String iconPath;
  final List<String> permissions;
  final Map<String, dynamic>? metadata;

  const UserRole({
    required this.type,
    required this.nameKey,
    required this.descriptionKey,
    required this.iconPath,
    this.permissions = const [],
    this.metadata,
  });

  @override
  List<Object?> get props => [
        type,
        nameKey,
        descriptionKey,
        iconPath,
        permissions,
        metadata,
      ];

  UserRole copyWith({
    UserRoleType? type,
    String? nameKey,
    String? descriptionKey,
    String? iconPath,
    List<String>? permissions,
    Map<String, dynamic>? metadata,
  }) {
    return UserRole(
      type: type ?? this.type,
      nameKey: nameKey ?? this.nameKey,
      descriptionKey: descriptionKey ?? this.descriptionKey,
      iconPath: iconPath ?? this.iconPath,
      permissions: permissions ?? this.permissions,
      metadata: metadata ?? this.metadata,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'type': type.name,
      'nameKey': nameKey,
      'descriptionKey': descriptionKey,
      'iconPath': iconPath,
      'permissions': permissions,
      'metadata': metadata,
    };
  }

  factory UserRole.fromMap(Map<String, dynamic> map) {
    return UserRole(
      type: UserRoleType.values.firstWhere(
        (e) => e.name == map['type'],
        orElse: () => UserRoleType.patient,
      ),
      nameKey: map['nameKey'] ?? '',
      descriptionKey: map['descriptionKey'] ?? '',
      iconPath: map['iconPath'] ?? '',
      permissions: List<String>.from(map['permissions'] ?? []),
      metadata: map['metadata'],
    );
  }

  bool hasPermission(String permission) {
    return permissions.contains(permission);
  }

  static const UserRole patient = UserRole(
    type: UserRoleType.patient,
    nameKey: 'patientRole',
    descriptionKey: 'patientRoleDescription',
    iconPath: 'assets/icons/patient.svg',
    permissions: [
      'view_medical_records',
      'manage_appointments',
      'manage_medications',
      'view_reminders',
    ],
  );

  static const UserRole specialist = UserRole(
    type: UserRoleType.specialist,
    nameKey: 'specialistRole',
    descriptionKey: 'specialistRoleDescription',
    iconPath: 'assets/icons/specialist.svg',
    permissions: [
      'manage_patients',
      'create_prescriptions',
      'manage_appointments',
      'view_patient_records',
      'create_diagnoses',
    ],
  );

  static List<UserRole> get availableRoles => [patient, specialist];
}