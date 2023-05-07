import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';

import '../../generated/abstract_service.dart';

enum File_Type { IMAGE, VIDEO }

class CloudStorage extends AbstractService{
  Future<String> uploadFile(
    XFile file,
    String fileName, {
    File_Type type = File_Type.IMAGE,
  }) async {
    var refPath = _getRefPathFromFileType(type);
    final storageRef = FirebaseStorage.instance.ref(refPath);
    final fileRef = storageRef.child(fileName);
    var data = await file.readAsBytes();
    var upload = await fileRef.putData(data);
    return await upload.ref.getDownloadURL();
  }

  Future<List<String>> getDownloadURLs() async {
    final storageRef =
        FirebaseStorage.instance.ref(_getRefPathFromFileType(File_Type.VIDEO));
    var listResult = await storageRef.listAll();
    return [for (var item in listResult.items) await item.getDownloadURL()];
  }

  String _getRefPathFromFileType(File_Type file_type) {
    var fileTypeName = file_type.name.toLowerCase();
    return "${fileTypeName}s";
  }
  
  @override
  void dispose() {
    // TODO: implement dispose
  }
  
  @override
  void init() {
    // TODO: implement init
  }
}
