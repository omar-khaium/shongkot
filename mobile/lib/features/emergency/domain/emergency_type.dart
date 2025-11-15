/// Types of emergencies supported by the Rapid Crime SOS feature
enum EmergencyType {
  /// Violent crime (generic)
  violentCrime,

  /// Sexual assault or rape
  sexualAssault,

  /// Physical assault or beating
  physicalAssault,

  /// Kidnapping or abduction
  kidnapping,

  /// Other violent crime not covered by above categories
  otherViolentCrime,
}

/// Extension to provide human-readable labels for emergency types
extension EmergencyTypeExtension on EmergencyType {
  /// Get display name for the emergency type
  String get displayName {
    switch (this) {
      case EmergencyType.violentCrime:
        return 'Violent Crime';
      case EmergencyType.sexualAssault:
        return 'Sexual Assault / Rape';
      case EmergencyType.physicalAssault:
        return 'Physical Assault / Beating';
      case EmergencyType.kidnapping:
        return 'Kidnapping / Abduction';
      case EmergencyType.otherViolentCrime:
        return 'Other Violent Crime';
    }
  }
}
