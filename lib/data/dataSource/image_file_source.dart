

import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';

class ImageFileSource{

  final _storage = FirebaseStorage.instance;

  Future<List<String>> uploadImages(List<XFile> images,String locId,String address) async {
    final imageUrls = await Future.wait(images.map((image) async {
      final ref = _storage.ref('warehouses/$locId/$address/${image.name}');
      await ref.putFile(File(image.path));
      return await ref.getDownloadURL();
    }));
    return imageUrls;
  }
}