import 'package:capstone_mobile/src/data/models/regulation/regulation.dart';
import 'package:formz/formz.dart';

enum ViolationRegulationValidationError { empty }

class ViolationRegulation
    extends FormzInput<Regulation, ViolationRegulationValidationError> {
  const ViolationRegulation.pure() : super.pure(null);
  const ViolationRegulation.dirty([Regulation value]) : super.dirty(value);

  @override
  ViolationRegulationValidationError validator(Regulation value) {
    return value != null ? null : ViolationRegulationValidationError.empty;
  }
}
