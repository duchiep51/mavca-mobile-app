import 'dart:async';
import 'dart:typed_data';

import 'package:capstone_mobile/Api/BaseApi.dart';
import 'package:capstone_mobile/src/data/models/violation/violation.dart';
import 'package:capstone_mobile/src/data/repositories/violation/violation_api.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:http/http.dart' as http;

class ViolationRepository {
  ViolationApi _violationApi = ViolationApi(httpClient: http.Client());

  ViolationRepository();

  Future<List<Violation>> fetchViolations({
    @required String token,
    String sort,
    double page,
    int limit,
    String status,
    int branchId,
    int regulationId,
    DateTime date,
    DateTime onDate,
    int reportId,
    int id,
  }) async {
    return await _violationApi.getViolations(
      token: token,
      sort: sort,
      page: page,
      limit: limit,
      branchId: branchId,
      regulationId: regulationId,
      status: status,
      date: date,
      onDate: onDate,
      reportId: reportId,
      id: id,
    );
  }

  Future<dynamic> uploadImage(List<Asset> assets, String token) async {
    List<MapEntry<String, MultipartFile>> listMapEntries = List();
    for (var asset in assets) {
      ByteData byteData = await asset.getByteData(quality: 80);

      if (byteData != null) {
        List<int> imageData = byteData.buffer.asInt8List();
        listMapEntries.add(new MapEntry(
          'files',
          MultipartFile.fromBytes(
            imageData,
            filename:
                DateTime.now().toString().replaceAll(new RegExp(r"\s+"), "") +
                    asset.name,
          ),
        ));
      }
    }

    if (listMapEntries.isNotEmpty) {
      FormData formData = FormData();
      formData.files.addAll([...listMapEntries]);

      BaseApi baseApi = BaseApi();
      return baseApi.uploadImages('images/upload', formData, token);
    }

    return null;
  }

  Future<String> createViolations({
    @required String token,
    @required List<Violation> violations,
  }) async {
    if (violations == null) {
      return 'fail';
    }

    if (violations.isEmpty) {
      return 'list violations are empty';
    }

    for (int i = 0; i < violations.length; i++) {
      List<String> result = List();

      if (violations[i].assets != null && violations[i].assets.isNotEmpty) {
        var uploadedImages = await uploadImage(violations[i].assets, token);

        if (uploadedImages != null) {
          for (var j = 0; j < uploadedImages['data'].length; j++) {
            result.add(uploadedImages['data'][j]['uri']);
          }
        }
      }

      violations[i].imagePaths = result;
    }
    var result = await _violationApi.createViolations(
      token: token,
      violations: violations,
    );

    return 'success';
  }

  Future<String> editViolation({
    @required String token,
    @required Violation violation,
  }) async {
    var uploadedImage;

    if (violation.assets != null && violation.assets.isNotEmpty) {
      uploadedImage = await uploadImage(violation.assets, token);

      violation.imagePaths = violation.imagePaths +
          List<String>.from(uploadedImage['data'].map((data) => data['uri']));
    }

    var result = await _violationApi.editViolation(
      token: token,
      violation: violation,
    );

    return 'success';
  }

  Future<String> deleteViolation({
    @required String token,
    @required int id,
  }) async {
    var result = await _violationApi.deleteViolation(token: token, id: id);

    return result == 200 ? 'success' : 'fail';
  }
}
