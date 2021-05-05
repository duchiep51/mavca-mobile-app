import 'package:formz/formz.dart';

enum ViolationDescriptionValidationError { empty }

class ViolationDescription
    extends FormzInput<String, ViolationDescriptionValidationError> {
  const ViolationDescription.pure() : super.pure('');
  const ViolationDescription.dirty([String value = '']) : super.dirty(value);

  @override
  ViolationDescriptionValidationError validator(String value) {
    return value?.isNotEmpty == true
        ? null
        : ViolationDescriptionValidationError.empty;
  }
}
