import 'package:formz/formz.dart';

enum PasswordValidationError { empty, invalid }

class Password extends FormzInput<String, PasswordValidationError> {
  const Password.pure() : super.pure('');
  const Password.dirty([String value = '']) : super.dirty(value);

  static final _passwordRegExp =
      RegExp(r'^(?=.*[A-Za-z])(?=.*\d)[A-Za-z\d]{8,}$');

  @override
  PasswordValidationError validator(String value) {
    // return _passwordRegExp.hasMatch(value)
    //     ? null
    //     : PasswordValidationError.invalid;
    // return value?.isNotEmpty == true ? null : PasswordValidationError.empty;
    if (value.isEmpty) {
      return PasswordValidationError.empty;
    }
    if (value.length < 3) {
      return PasswordValidationError.invalid;
    }
    return null;
  }
}
