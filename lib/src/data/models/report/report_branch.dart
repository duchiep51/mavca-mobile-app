import 'package:formz/formz.dart';

enum ReportBranchValidationError { empty }

class ReportBranch extends FormzInput<int, ReportBranchValidationError> {
  const ReportBranch.pure() : super.pure(-1);
  const ReportBranch.dirty([int value = -1]) : super.dirty(value);

  @override
  ReportBranchValidationError validator(int value) {
    return value > -1 ? null : ReportBranchValidationError.empty;
  }
}
