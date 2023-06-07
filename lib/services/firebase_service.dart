import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

class FirebaseService {
  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;
  final _storage = FirebaseStorage.instance;

  Future createAccount({
    required String email,
    required String password,
    required String username,
    required File selectedImage,
  }) async {
    try {
      final userCredentials = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // U P L O A D   I M A G E
      final ref = _storage
          .ref()
          .child('user_images')
          .child('${userCredentials.user!.uid}.jpg');
      await ref.putFile(selectedImage);
      final imageUrl = await ref.getDownloadURL();

      //S T O R E   U S E R   D A T A
      await _firestore.collection('users').doc(userCredentials.user!.uid).set({
        'username': username,
        'email': email,
        'image_url': imageUrl,
      });
    } on FirebaseAuthException catch (_) {
      rethrow;
    }
  }

  Future loginUser({
    required String email,
    required String password,
  }) async {
    try {
      await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on FirebaseAuthException catch (_) {
      rethrow;
    }
  }

  Future changeUserPassword({required String newPassword}) async {
    final user = _auth.currentUser!;
    try {
      await user.updatePassword(newPassword);
    } on FirebaseAuthException catch (_) {
      rethrow;
    }
  }

  Future<void> changeUsername({required String username}) async {
    final user = _auth.currentUser!;

    try {
      await _firestore.collection('users').doc(user.uid).update(
        {
          'username': username,
        },
      );
    } on FirebaseException catch (_) {
      rethrow;
    }
  }
}
