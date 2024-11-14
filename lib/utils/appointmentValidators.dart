// lib/validators.dart

bool validateDate(String? date) {
  if (date == null || date.isEmpty) {
    return false;
  }
  return true;
}

bool validateTime(String? time) {
  if (time == null || time.isEmpty) {
    return false;
  }
  return true;
}

bool validateAddress(String? address) {
  if (address == null || address.isEmpty) {
    return false;
  }
  return true;
}

bool validateMessage(String? message) {
  if (message == null || message.isEmpty) {
    return false;
  }
  return true;
}
