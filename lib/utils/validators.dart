class Validators {
  static final RegExp _emailRegExp = RegExp(
    r'^[a-zA-Z0-9.!#$%&’*+/=?^_`{|}~-]+@[a-zA-Z0-9-]+(?:\.[a-zA-Z0-9-]+)*$',
  );

  static String fullNameValidator(String name) {
    if (name.isEmpty) {
      return 'Name cannot be blank';
    }
    return null;
  }

  static String emailValidator(String email) {
    if (email.isEmpty) {
      return 'Email cannot be blank';
    } else if (!_emailRegExp.hasMatch(email)) {
      return 'Email is invalid';
    }
    return null;
  }

  static String passwordValidator(String password) {
    if (password.isEmpty) {
      return 'Password cannot be blank';
    } else if (password.length < 8) {
      return 'Short Password';
    }
    return null;
  }

  static String phoneValidator(String value) {
    // Indian Mobile number are of 10 digit only
    if (value.length != 10)
      return 'Mobile Number must be of 10 digit';
    else
      return null;
  }

  static String addressValidator(String str) {
    if (str.length < 8) {
      return 'Address is too short';
    }
    return null;
  }
}
