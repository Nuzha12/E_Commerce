class Validators {
  static String? name(String value) {
    if (value.trim().isEmpty) return 'Name is required';
    if (value.trim().length < 3) return 'Enter at least 3 characters';
    return null;
  }

  static String? email(String value) {
    if (value.trim().isEmpty) return 'Email is required';
    final regex = RegExp(r'^[^@]+@[^@]+\.[^@]+$');
    if (!regex.hasMatch(value.trim())) return 'Enter a valid email';
    return null;
  }

  static String? password(String value) {
    if (value.trim().isEmpty) return 'Password is required';
    if (value.trim().length < 6) return 'Minimum 6 characters';
    return null;
  }
}