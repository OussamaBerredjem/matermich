import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';

class ImageServices {
    final FirebaseStorage _firebaseStorage = FirebaseStorage.instance;

    Future<String> uploadFile({required String path,required String storagePath}) async{
      try {
        await _RemoveImage(storagePath: storagePath);
        final ref = _firebaseStorage.ref().child(storagePath);

        TaskSnapshot taskSnapshot = await  ref.putFile(File(path));
        String url = await taskSnapshot.ref.getDownloadURL();
        return url;
      } catch (e) {
        return "";
      }
    
  }

  // ignore: non_constant_identifier_names
  Future<void> _RemoveImage({required String storagePath}) async{
    try {
      await _firebaseStorage.ref().child(storagePath).delete();
    } catch (e) {
      
    }
  }
}