enum Gender { male, female, other, notSpecified }

extension GenderExtension on Gender {
  String get displayValue {
    switch (this) {
      case Gender.male:
        return 'Male';
      case Gender.female:
        return 'Female';
      case Gender.other:
        return 'Other';
      case Gender.notSpecified:
        return 'Not Specified';
    }
  }

  static Gender fromString(String value) {
    switch (value) {
      case 'Male':
        return Gender.male;
      case 'Female':
        return Gender.female;
      case 'Other':
        return Gender.other;
      default:
        return Gender.notSpecified;
    }
  }
}
