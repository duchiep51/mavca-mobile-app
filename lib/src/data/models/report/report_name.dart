import 'package:formz/formz.dart';

enum ReportNameValidationError { empty }

class ReportName extends FormzInput<String, ReportNameValidationError> {
  const ReportName.pure() : super.pure('');
  const ReportName.dirty([String value = '']) : super.dirty(value);

  @override
  ReportNameValidationError validator(String value) {
    return value?.isNotEmpty == true ? null : ReportNameValidationError.empty;
  }
}
