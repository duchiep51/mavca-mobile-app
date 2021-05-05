import 'package:equatable/equatable.dart';
import 'package:multi_image_picker/multi_image_picker.dart';

class Violation extends Equatable {
  final int id;
  final String name;
  final String status;
  final String violationCode;
  final DateTime createdAt;
  final String description;
  final int regulationId;
  final String regulationName;
  final int branchId;
  final branchName;
  List<String> imagePaths;
  List<Asset> assets;
  final String excuse;
  final int reportId;
  final int createdBy;
  final String creatorName;

  Violation({
    this.id,
    this.name,
    this.status,
    this.violationCode,
    this.createdAt,
    this.description,
    this.regulationId,
    this.regulationName,
    this.branchId,
    this.branchName,
    this.imagePaths,
    this.assets,
    this.excuse,
    this.reportId,
    this.createdBy,
    this.creatorName,
  });

  @override
  List<Object> get props => [
        id,
        name,
        status,
        violationCode,
        createdAt,
        description,
        regulationId,
        regulationName,
        branchId,
        branchName,
        imagePaths,
        assets,
        excuse,
        creatorName,
        createdBy,
      ];

  static Violation fromJson(dynamic json) {
    return Violation(
      id: json['id'],
      name: json['name'],
      branchId: json['branch']['id'],
      branchName: json['branch']['name'],
      description: json['description'],
      createdAt: DateTime.parse(json['createdAt']),
      status: json['status'],
      regulationId: json['regulation']['id'],
      regulationName: json['regulation']['name'],
      excuse: json['excuse'],
      reportId: json['report']['id'] as int,
      createdBy: json['createdBy']['id'] as int,
      creatorName:
          json['createdBy']['firstName'] + ' ' + json['createdBy']['lastName'],
      imagePaths:
          List<String>.from(json['evidence'].map((e) => e['imagePath'])),
    );
  }

  Violation copyWith({
    DateTime createdAt,
    int id,
    String name,
    String description,
    int regulationId,
    String regulationName,
    int branchId,
    String branchName,
    String status,
    List<String> imagePaths,
    List<Asset> assets,
    String excuse,
    int reportId,
  }) {
    return Violation(
      branchId: branchId ?? this.branchId,
      branchName: branchName ?? this.branchName,
      createdAt: this.createdAt,
      description: description ?? this.description,
      id: this.id,
      name: name ?? this.name,
      regulationId: regulationId ?? this.regulationId,
      regulationName: regulationName ?? this.regulationName,
      status: status ?? this.status,
      violationCode: this.violationCode,
      imagePaths: imagePaths ?? this.imagePaths,
      assets: assets ?? this.assets,
      excuse: excuse ?? this.excuse,
      reportId: reportId ?? this.reportId,
      createdBy: this.createdBy,
    );
  }

  static List<Map<String, dynamic>> convertListViolationToListMap(
      List<Violation> violations) {
    List<Map<String, dynamic>> list = List();

    violations.forEach((violation) {
      list.add(<String, dynamic>{
        'reportId': violation.reportId,
        'name': 'name',
        'description': violation.description.trim(),
        'regulationId': violation.regulationId,
        'branchId': violation.branchId,
        'excuse': violation.excuse,
        'evidenceCreate': [
          ...violation.imagePaths.map((imagePath) => {"imagePath": imagePath})
        ]
      });
    });

    return list;
  }
}
