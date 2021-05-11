/// Is Email and/or Password is valid
class Validators {
  static final RegExp _emailRegExp = RegExp(
    r'^([a-zA-Z0-9_\-\.]+)@([a-zA-Z0-9_\-\.]+)\.([a-zA-Z]{2,5})$',
  );
  //! ^	The password string will start this way
  //! (?=.*[a-z])	The string must contain at least 1 lowercase alphabetical character
  //! (?=.*[A-Z])	The string must contain at least 1 uppercase alphabetical character
  //! (?=.*[0-9]) => The string must contain at least 1 numeric character
  //! (?=.[!@#\$%\^&]) => The string must contain at least one special character, but we are escaping reserved RegEx characters to avoid conflict
  //! (?=.{8,})	The string must be eight characters or longer
  static final RegExp _passwordRegExp = RegExp(
    r'^(?=.*[A-Za-z])(?=.*\d)[A-Za-z\d]{8,}$', // Minimum eight characters, at least one letter and one number
  );
  static final RegExp _phoneNumberRegExp = RegExp(r'^[0-9]{8}$');

  static isValidEmail(String email) {
    return _emailRegExp.hasMatch(email);
  }

  static isValidPassword(String password) {
    return _passwordRegExp.hasMatch(password);
  }

  static isValidPhoneNumber(String phoneNumber) {
    return _phoneNumberRegExp.hasMatch(phoneNumber);
  }
}
