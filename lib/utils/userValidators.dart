bool validateEmail(String? value) {
  if (value == null || value.isEmpty) {
    return false; // Or return an error message string if preferred
  } else if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
    return false;
  }
  return true;
}

bool validatePassword(String? value) {
  if (value == null || value.isEmpty) {
    return false;
  }

  // Check if the length is at least 8
  if (value.length < 8) {
    return false;
  }

  // Regular expression to check for at least one letter, one number, and one special character
  RegExp regex =
      RegExp(r'^(?=.*[A-Za-z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{8,}$');

  // Validate against the regular expression
  if (!regex.hasMatch(value)) {
    return false;
  }

  return true;
}
