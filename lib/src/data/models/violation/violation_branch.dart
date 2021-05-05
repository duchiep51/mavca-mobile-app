import 'package:capstone_mobile/src/data/models/branch/branch.dart';
import 'package:formz/formz.dart';

enum ViolationBranchValidationError { empty }

class ViolationBranch
    extends FormzInput<Branch, ViolationBranchValidationError> {
  const ViolationBranch.pure() : super.pure(null);
  const ViolationBranch.dirty([Branch value]) : super.dirty(value);

  @override
  ViolationBranchValidationError validator(Branch value) {
    return value != null ? null : ViolationBranchValidationError.empty;
  }
}
