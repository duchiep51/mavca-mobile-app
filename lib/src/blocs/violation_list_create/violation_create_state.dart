part of 'violation_create_bloc.dart';

class ViolationCreateState extends Equatable {
  const ViolationCreateState({
    this.violationDescription = const ViolationDescription.pure(),
    this.violationRegulation = const ViolationRegulation.pure(),
    // this.violationBranch = const ViolationBranch.pure(),
    this.status = FormzStatus.pure,
  });

  final FormzStatus status;
  final ViolationDescription violationDescription;
  final ViolationRegulation violationRegulation;
  // final ViolationBranch violationBranch;

  ViolationCreateState copyWith({
    FormzStatus status,
    ViolationDescription violationDescription,
    String createdDate,
    ViolationRegulation violationRegulation,
    // ViolationBranch violationBranch,
  }) {
    return ViolationCreateState(
      status: status ?? this.status,
      violationDescription: violationDescription ?? this.violationDescription,
      violationRegulation: violationRegulation ?? this.violationRegulation,
      // violationBranch: violationBranch ?? this.violationBranch,
    );
  }

  @override
  List<Object> get props => [
        status,
        violationDescription,
        violationRegulation,
        // violationBranch
      ];
}
