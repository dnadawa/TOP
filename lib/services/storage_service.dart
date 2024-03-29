import 'dart:typed_data';

import 'package:firebase_storage/firebase_storage.dart';

class StorageService{

  final _storage = FirebaseStorage.instance;

  Future<String> uploadBytes(String fileName, Uint8List image, {String location="signatures"}) async {
    Reference reference = _storage.ref('$location/$fileName.png');
    TaskSnapshot task = await reference.putData(image);
    String url = await task.ref.getDownloadURL();

    return url;
  }

}