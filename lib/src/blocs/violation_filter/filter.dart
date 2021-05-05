import 'package:equatable/equatable.dart';

class Filter extends Equatable {
  final int branchId;
  final String status;
  final int regulationId;
  final DateTime date;

  Filter({
    this.branchId,
    this.status,
    this.regulationId,
    this.date,
  });

  @override
  List<Object> get props => [
        branchId,
        status,
        regulationId,
        date,
      ];

  @override
  String toString() =>
      '{ branchId: $branchId, status: $status, regulationId: $regulationId , date: $date }';

  Filter copyWith({
    int branchId,
    String status,
    int regulationId,
    DateTime date,
  }) {
    return Filter(
      branchId: branchId ?? this.branchId,
      status: status ?? this.status,
      regulationId: regulationId ?? this.regulationId,
      date: date ?? this.date,
    );
  }
}
