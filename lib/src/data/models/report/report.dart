import 'package:capstone_mobile/src/data/models/violation/violation.dart';
import 'package:equatable/equatable.dart';

class Report extends Equatable {
  final int id;
  final int branchId;
  final String branchName;
  final String name;
  final String description;
  final String status;
  final DateTime createdAt;
  final DateTime updatedAt;
  final int createdBy;
  final List<Violation> violations;
  final String qcNote;
  final int totalMinusPoint;
  final String assigneeName;
  final String adminNote;

  Report({
    this.id,
    this.branchId,
    this.branchName,
    this.name,
    this.description,
    this.status,
    this.createdAt,
    this.updatedAt,
    this.createdBy,
    this.violations,
    this.qcNote,
    this.totalMinusPoint,
    this.assigneeName,
    this.adminNote,
  });

  List<Map<String, dynamic>> convertListViolationToMap(
      List<Violation> violations) {
    List<Map<String, dynamic>> list = List();

    violations.forEach((violation) {
      list.add(<String, dynamic>{
        'name': violation.name,
        'description': violation.description,
        'regulationId': violation.regulationId,
        'branchId': violation.branchId,
      });
    });

    return list;
  }

  Map<String, dynamic> toJson() {
    return {
      'createdBy': this.createdBy,
      'branchId': this.branchId,
      'name': this.name,
      'description': this.description,
      'status': this.status,
    };
  }

  List<Violation> jsonToListViolation(List<Map> list) {
    List<Violation> parsedList;

    list.forEach((violation) {
      parsedList.add(Violation(
        name: violation['name'],
        description: violation['description'],
        status: violation['status'],
        createdAt: violation['createdDate'],
        branchId: violation['branchId'],
      ));
    });
  }

  static Report fromJson(dynamic json) {
    return Report(
      name: json['name'],
      id: json['id'],
      branchId: json['branch']['id'],
      branchName: json['branch']['name'],
      description: json['description'],
      createdAt: DateTime.parse(json['createdAt']),
      status: json['status'],
      violations: json['violationCreate'],
      qcNote: json['qcNote'],
      totalMinusPoint: json['totalMinusPoint'],
      assigneeName: json['assigneeNavigation']['firstName'] +
          ' ' +
          json['assigneeNavigation']['lastName'],
      adminNote: json['adminNote'],
    );
  }

  Report copyWith({
    String status,
    String name,
    int branchId,
    int createdBy,
    String description,
    List<Violation> violations,
    String qcNote,
  }) {
    return Report(
      status: status ?? this.status,
      branchId: branchId ?? this.branchId,
      createdBy: createdBy ?? this.createdBy,
      name: name ?? this.name,
      description: description ?? this.description,
      violations: violations ?? this.violations,
      id: id ?? this.id,
      qcNote: qcNote ?? this.qcNote,
      totalMinusPoint: this.totalMinusPoint,
    );
  }

  @override
  List<Object> get props => [
        id,
        name,
        status,
        branchId,
        description,
        createdBy,
        qcNote,
        totalMinusPoint,
      ];
}
