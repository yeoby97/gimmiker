

import 'package:gimmiker/data/dataSource/image_file_source.dart';
import 'package:image_picker/image_picker.dart';

class ImageFileRepository{

  final ImageFileSource _imageResource;

  ImageFileRepository(this._imageResource);

  Future<List<String>> uploadImages(List<XFile> images,String locId,String address){
    return _imageResource.uploadImages(images ,locId, address);
  }
}