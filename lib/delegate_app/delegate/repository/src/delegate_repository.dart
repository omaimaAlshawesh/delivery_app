import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

import 'models/model.dart';

abstract class _DelegateRepository {
  Future<void> createDelegate(Delegate delegate);
  Future<void> updateDelegate(Delegate delegate);
  Stream<Delegate> fetchDelegate(String id);
  Future<void> deleteDelegate(String id);
}

class DelegateRepository implements _DelegateRepository {
  final FirebaseFirestore _store;
  final FirebaseStorage _storage;

  DelegateRepository()
      : _storage = FirebaseStorage.instance,
        _store = FirebaseFirestore.instance;

  @override
  Future<void> createDelegate(Delegate delegate) async {
    final String docId = FirebaseAuth.instance.currentUser!.uid;
    final String photoUrl =
        await uploadImage(delegate.photoUrl, 'profilePhoto', docId);
    final String docImage =
        await uploadImage(delegate.idCard.docUrl, 'docsPhoto', docId);
    try {
      await _store.collection('delegates').doc(docId).set(delegate
          .copyWith(
              id: docId,
              photoUrl: photoUrl,
              idCard: delegate.idCard.copyWith(docUrl: docImage))
          .toMap());
    } catch (e) {
      print('createDelegate: $e');
    }
  }

  Future<String> uploadImage(path, folderName, id) async {
    try {
      final ref = _storage.ref('delegates').child(id).child('$folderName.png');
      final task = await ref.putFile(File(path));
      if (task.state == TaskState.success) {
        return await task.ref.getDownloadURL();
      } else {
        return '';
      }
    } catch (e) {
      print('uploadImage: $e');
      return '';
    }
  }

  @override
  Future<void> deleteDelegate(String id) async {
    try {
      await _storage.ref('delegtes').child(id).delete().then((value) async {
        await _store.collection('delegates').doc(id).delete();
      });
    } catch (e) {
      print('deleteDelegate: $e');
    }
  }

  @override
  Stream<Delegate> fetchDelegate(String id) {
    try {
      return _store.collection('delegates').doc(id).snapshots().map((event) =>
          (event.data() == null
              ? Delegate.empty()
              : Delegate.fromMap(event.data()!)));
    } catch (e) {
      print('fetchDelegate: $e');
      return Stream.error(Delegate.empty());
    }
  }

  @override
  Future<void> updateDelegate(Delegate delegate) async {
    try {
      final String profilePhoto = delegate.photoUrl.startsWith('https://')
          ? delegate.photoUrl
          : await uploadImage(delegate.photoUrl, 'profilePhoto', delegate.id);
      await _store
          .collection('delegates')
          .doc(delegate.id)
          .update(delegate.copyWith(photoUrl: profilePhoto).toMap());
    } catch (e) {
      print('updateDelegate: $e');
    }
  }
}
