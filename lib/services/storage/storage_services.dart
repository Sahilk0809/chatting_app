import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';

class StorageServices {
  StorageServices._();

  static StorageServices storageServices = StorageServices._();

  final FirebaseStorage _firebaseStorage = FirebaseStorage.instance;

  Future<String> uploadImageToStorage() async {
    XFile? xFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    final reference = _firebaseStorage.ref();
    final imageReference = reference.child("images/${xFile!.name}");
    await imageReference.putFile(
      File(xFile.path),
    );
    String url = await imageReference.getDownloadURL();
    return url;
  }
}
