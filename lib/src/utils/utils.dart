import 'package:capstone_mobile/src/blocs/branch/branch_bloc.dart';
import 'package:capstone_mobile/src/blocs/regulation/regulation_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:multi_image_picker/multi_image_picker.dart';

class Utils {
  static String formatDate(DateTime date) {
    return date.day.toString().padLeft(2, '0') +
        '-' +
        date.month.toString().padLeft(2, '0') +
        '-' +
        date.year.toString();
  }

  static String yMMMd(DateTime date, String locale) {
    return DateFormat.yMMMd(locale).format(date);
  }

  static Future<void> getImage() async {
    final picker = ImagePicker();

    await picker.getImage(source: ImageSource.camera).then((pickedFile) {
      if (pickedFile != null && pickedFile.path != null) {
        GallerySaver.saveImage(pickedFile.path).then((isSaved) {});
      }
    });
  }

  static Future<List<Asset>> loadImages(int quantity) async {
    List<Asset> assets = <Asset>[];

    try {
      assets = await MultiImagePicker.pickImages(
        maxImages: quantity,
        enableCamera: true,
      );
    } catch (e) {
      print(e.toString());
    }

    return assets;
  }

  static String findBranchName(int id, BuildContext context) {
    var branchState = BlocProvider.of<BranchBloc>(context).state;
    if (branchState is BranchLoadSuccess) {
      return branchState.branches
          .firstWhere(
            (branch) => branch.id == id,
            orElse: () => null,
          )
          ?.name;
    }
    return 'All branches';
  }

  static String findRegulationName(int id, BuildContext context) {
    var regulationState = BlocProvider.of<RegulationBloc>(context).state;
    if (regulationState is RegulationLoadSuccess) {
      return regulationState.regulations
          .firstWhere(
            (regulation) => regulation.id == id,
            orElse: () => null,
          )
          ?.name;
    }
    return null;
  }
}
