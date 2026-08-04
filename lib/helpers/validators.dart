class Validators {
  static String? validateNotEmpty(String? value, [String field = 'Field']) {
    if (value == null || value.trim().isEmpty) return '$field cannot be empty.';
    return null;
  }

  static String? validateName(String? value) {
    if (value == null || value.trim().isEmpty) return 'Name cannot be empty.';
    if (value.trim().length < 2) return 'Name must be at least 2 characters.';
    if (value.trim().length > 50) return 'Name cannot exceed 50 characters.';
    return null;
  }

  static bool isValidIndex(int index, int length) =>
      index >= 0 && index < length;
}
