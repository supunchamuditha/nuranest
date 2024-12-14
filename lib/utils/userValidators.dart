// This file contains functions to validate user input for registration and login

// Validate email
bool validateEmail(String? value) {
  if (value == null || value.isEmpty) {
    return false; // Or return an error message string if preferred
  } else if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
    return false;
  }
  return true;
}

// Validate password
bool validatePassword(String? value) {
  if (value == null || value.isEmpty) {
    return false;
  }

  // Check if the length is at least 8
  if (value.length < 8 || value.length > 20) {
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

// Validate confirm password
bool validateConfirmPassword(String? password, String? confirmPassword) {
  if (password == null || confirmPassword == null) {
    return false;
  }

  return password == confirmPassword;
}

// Validate name
bool validateName(String? value) {
  if (value == null || value.isEmpty) {
    return false;
  }

  return true;
}

// Validate phone number
bool validatePhone(String? value) {
  if (value == null || value.isEmpty) {
    return false;
  }

  // Regular expression to check for valid phone number (optional country code)
  RegExp regex = RegExp(r'^[0-9]{10,15}$');
  // Validate against the regular expression
  if (!regex.hasMatch(value)) {
    return false;
  }

  return true;
}

bool validateDob(String? value) {
  if (value == null || value.isEmpty) return false;

  try {
    DateTime dob = DateTime.parse(value);
    DateTime today = DateTime.now();

    // Check if the date is in the future
    if (dob.isAfter(today)) return false;

    return true; // Valid date
  } catch (e) {
    return false; // Invalid date format
  }
}

bool validateGender(String? value) {
  // Assuming valid genders are "Male" and "Female"
  if (value == null || value.isEmpty) return false;

  List<String> validGenders = ['male', 'female', 'other'];
  return validGenders.contains(value);
}

bool validateUsername(String? value) {
  if (value == null || value.isEmpty) return false;

  // Regular expression: 3–15 characters, alphanumeric, underscores allowed
  final usernameRegex = RegExp(r'^[a-zA-Z0-9_]{3,15}$');
  return usernameRegex.hasMatch(value);
}
