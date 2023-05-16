bool validateAlphabetsOnly(String value) {
  // Define the regex pattern for alphabets only
  final RegExp alphabetsOnlyRegex = RegExp(r'^[a-zA-Z]+$');

  // Check if the value matches the regex pattern
  return alphabetsOnlyRegex.hasMatch(value);
}

bool passwordHasUppercaseLetter(String value) {
  // Iterate through each character in the value
  for (int i = 0; i < value.length; i++) {
    // Check if the character is an uppercase letter
    if (value[i].toUpperCase() == value[i]) {
      return true; // Found an uppercase letter, return true
    }
  }
  return false; // No uppercase letter found
}

bool passwordHasSpecialCharacter(String value) {
  // Define a list of special characters
  List<String> specialCharacters = [
    '!', '@', '#', '\$', '%', '^', '&', '*', '(', ')', '-', '_', '+', '=', '[', ']', '{', '}', '|', '\\', ';', ':', "'", '"', ',', '.', '<', '>', '/', '?'
  ];
  
  // Iterate through each character in the value
  for (int i = 0; i < value.length; i++) {
    // Check if the character is a special character
    if (specialCharacters.contains(value[i])) {
      return true; // Found a special character, return true
    }
  }
  return false; // No special character found
}

bool passwordHasNumber(String value) {
  // Iterate through each character in the value
  for (int i = 0; i < value.length; i++) {
    // Check if the character is a number
    if (value.codeUnitAt(i) >= 48 && value.codeUnitAt(i) <= 57) {
      return true; // Found a number, return true
    }
  }
  return false; // No number found
}


bool validateMinimumLength(String value, int minLength) {
  // check if value is greater than or equal to minimum length
  return value.trim().length >= minLength;
}

bool validateMaximumLength(String value, int maxLength) {
  // check if value is lesser than or equal to maximum length
  return value.trim().length <= maxLength;
}

bool validateMinimumNumber(String value, int minNumber) {
  // check if value is greater than or equal to minimum length
  return int.parse(value.trim()) >= minNumber;
}

bool validateMaximumNumber(String value, int maxNumber) {
  // check if value is lesser than or equal to maximum length
  return int.parse(value.trim()) <= maxNumber;
}

bool validateRequired(String value) {
  // check if value is fulfills required status
  return value.trim().isNotEmpty;
}

bool validateNumeric(String value) {
  // check if the value is made of numbers and not double or decimals
  return double.tryParse(value.trim()) != null;
}

bool validateEmail(String value) {
  // check if the value is a valid email string
  return value.trim().contains('@');
}
