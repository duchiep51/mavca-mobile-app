import 'package:formz/formz.dart';

enum ViolationReportValidationError { empty }

class ViolationReport extends FormzInput<int, ViolationReportValidationError> {
  const ViolationReport.pure() : super.pure(0);
  const ViolationReport.dirty([int value]) : super.dirty(value);

  @override
  ViolationReportValidationError validator(int value) {
    return value != 0 ? null : ViolationReportValidationError.empty;
  }
}
