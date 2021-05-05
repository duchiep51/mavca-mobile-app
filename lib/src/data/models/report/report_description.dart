import 'package:formz/formz.dart';

enum ReportDescriptionValidationError { empty }

class ReportDescription
    extends FormzInput<String, ReportDescriptionValidationError> {
  const ReportDescription.pure() : super.pure('');
  const ReportDescription.dirty([String value = '']) : super.dirty(value);

  @override
  ReportDescriptionValidationError validator(String value) {
    return value?.isNotEmpty == true
        ? null
        : ReportDescriptionValidationError.empty;
  }
}
