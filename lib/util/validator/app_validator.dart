class AppValidator {
  static String? Function(String?)? validateEmail = (value) {
    if (value == null ||
        value.isEmpty ||
        !RegExp(
          r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+",
        ).hasMatch(value))
      return "Please enter a valid email";
    else
      return null;
  };

  /// Validate password
  static String? Function(String?)? validatePassword = (value) {
    if (value == null || value.isEmpty || value.length < 6) {
      return "Password must be at least 6 characters long";
    }
    return null;
  };


  /// Validate username
  static String? Function(String?)? validateUsername = (value) {
    if (value == null || value.isEmpty || value.length < 3) {
      return "Username must be at least 3 characters long";
    }
    return null;
  };

//validateFirstName
static String? Function(String?)? validateFirstName = (value) {
  if (value == null || value.isEmpty || value.length < 2) {
    return "Please enter first name";
  }
  return null;
};

//validateLastName
static String? Function(String?)? validateLastName = (value) {
  if (value == null || value.isEmpty || value.length < 2) {
    return "Please enter last name";
  }
  return null;
};

// Validate phone number
  static String? Function(String?)? validatePhoneNumber = (value) {
    if (value == null || value.isEmpty || !RegExp(r"^\+?[0-9]{10,15}$").hasMatch(value))
      return "Please enter a valid phone number";
    return null;
  };


/// Validate name
  static String? Function(String?)? validateName = (value) {
    if (value == null || value.isEmpty || value.length < 2) {
      return "Name must be at least 2 characters long";
    }
    return null;
  };

  

  /// Validate address
  static String? Function(String?)? validateAddress = (value) {
    if (value == null || value.isEmpty || value.length < 4) {
      return "Address must be at least 4 characters long";
    }
    return null;
  };

  /// Validate description
  static String? Function(String?)? validateDescription = (value) {
    if (value == null || value.isEmpty || value.length < 8) {
      return "Description must be at least 8 characters long";
    }
    return null;
  };


/// Validate title
  static String? Function(String?)? validateTitle = (value) {
    if (value == null || value.isEmpty || value.length < 3) {
      return "Title must be at least 3 characters long";
    }
    return null;
  };

  static String? Function(String?)? validateDate = (value) {
    if (value == null || value.isEmpty || !RegExp(r"^\d{4}-\d{2}-\d{2}$").hasMatch(value))
      return "Please enter a valid date in YYYY-MM-DD format";
    return null;
  };
}
