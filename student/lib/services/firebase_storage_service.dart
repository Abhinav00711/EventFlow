import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';

class FirebaseStorageService {
  final _eventRef = FirebaseStorage.instance.ref('Events/');

  Future<String> uploadEventBanner(String eid, String filePath) async {
    final ref = _eventRef.child('$eid/banner');
    final uploadTask = await ref.putFile(File(filePath));
    final url = await uploadTask.ref.getDownloadURL();
    return url;
  }

  Future<void> deleteEventBanner(String eid) async {
    final ref = _eventRef.child('$eid/banner');
    await ref.delete();
  }
}
