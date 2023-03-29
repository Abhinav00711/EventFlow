import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';

class FirebaseStorageService {
  final _eventRef = FirebaseStorage.instance.ref('Events/');

  Future<String> uploadEventBanner(
      String eid, String fileName, String filePath) async {
    final ref = _eventRef.child('$eid/$fileName');
    final uploadTask = await ref.putFile(File(filePath));
    final url = await uploadTask.ref.getDownloadURL();
    return url;
  }
}
