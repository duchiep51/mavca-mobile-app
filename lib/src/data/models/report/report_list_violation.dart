import 'package:capstone_mobile/src/data/models/violation/violation.dart';
import 'package:formz/formz.dart';

enum ReportListViolationValidationError { empty }

class ReportListViolation
    extends FormzInput<List<Violation>, ReportListViolationValidationError> {
  const ReportListViolation.pure() : super.pure(null);
  const ReportListViolation.dirty([List<Violation> value]) : super.dirty(value);

  @override
  ReportListViolationValidationError validator(List<Violation> value) {
    if (value == null || value.length == 0) {
      return ReportListViolationValidationError.empty;
    }

    return null;
  }
}
