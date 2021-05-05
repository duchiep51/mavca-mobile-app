import 'dart:io';

import 'package:capstone_mobile/src/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'dart:async';

import 'package:multi_image_picker/multi_image_picker.dart';

class ImgPicker extends StatefulWidget {
  static Route route() {
    return MaterialPageRoute<void>(builder: (_) => ImgPicker());
  }

  @override
  _ImgPickerState createState() => _ImgPickerState();
}

class _ImgPickerState extends State<ImgPicker> {
  File _image;
  String imagePath;
  String firstButtonText = 'Take photo';
  String secondButtonText = 'Record video';
  double textSize = 20;
  List<Asset> resultList = List();
  List<Asset> images = <Asset>[];

  final picker = ImagePicker();

  Future getImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.camera);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
  }

  void _takePhoto() async {
    picker
        .getImage(source: ImageSource.camera)
        .then((PickedFile recordedImage) {
      if (recordedImage != null && recordedImage.path != null) {
        GallerySaver.saveImage(recordedImage.path).then((isSaved) {
          setState(() {
            firstButtonText = 'image saved!';
          });
        });
      }
    });
  }

  Future<void> loadAssets() async {
    List<Asset> resultList = <Asset>[];
    String error = 'No Error Detected';

    // try {
    //   resultList = await MultiImagePicker.pickImages(
    //     maxImages: 300,
    //     enableCamera: true,
    //     selectedAssets: images,
    //     cupertinoOptions: CupertinoOptions(takePhotoIcon: "chat"),
    //     materialOptions: MaterialOptions(
    //       actionBarColor: "#abcdef",
    //       actionBarTitle: "Example App",
    //       allViewTitle: "All Photos",
    //       useDetailsView: false,
    //       selectCircleStrokeColor: "#000000",
    //     ),
    //   );
    // } on Exception catch (e) {
    //   error = e.toString();
    // }

    resultList = await Utils.loadImages(5);

    if (!mounted) return;

    setState(() {
      images = resultList;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
            body: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          height: 100,
        ),
        ElevatedButton(onPressed: loadAssets, child: Text('get image')),
        Expanded(
          child: ListView.builder(
            shrinkWrap: true,
            // itemExtent: resultList.length,
            itemCount: images.length,
            itemBuilder: (context, index) {
              Asset asset = images[index];
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: AssetThumb(
                  asset: asset,
                  width: 200,
                  height: 200,
                ),
              );
            },
          ),
        ),
      ],
    )));
  }

  Widget _previewImage() {
    return Semantics(
        child: Image.file(File(_image.path)),
        label: 'image_picker_example_picked_image');
  }
}

class ImagePickerButton extends StatefulWidget {
  @override
  _ImagePickerButtonState createState() => _ImagePickerButtonState();
}

class _ImagePickerButtonState extends State<ImagePickerButton> {
  File _image;
  String imagePath;

  final picker = ImagePicker();

  Future<void> getImage() async {
    final pickedFile =
        await picker.getImage(source: ImageSource.camera).then((pickedFile) {
      if (pickedFile != null && pickedFile.path != null) {
        GallerySaver.saveImage(pickedFile.path).then((isSaved) {
          setState(() {
            if (pickedFile != null) {
              _image = File(pickedFile.path);
            } else {
              print('No image selected.');
            }
          });
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    var size = MediaQuery.of(context).size;
    return Container(
      child: Center(
          child: IconButton(
        icon: Icon(Icons.camera_alt_outlined),
        color: Colors.white,
        onPressed: () {
          getImage();
        },
      )),
      height: size.width * 0.1,
      width: size.width * 0.15,
      decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(10.0)),
          color: theme.accentColor),
    );
  }
}
