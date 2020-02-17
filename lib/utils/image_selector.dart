import 'dart:io';

import 'package:image_picker/image_picker.dart';

class ImageSelector {
  Future<File> selectImageFromCamera() async {
    return await ImagePicker.pickImage(source: ImageSource.camera);
  }

  Future<File> selectImageFromGallery() async {
    return await ImagePicker.pickImage(source: ImageSource.gallery);
  }
}
