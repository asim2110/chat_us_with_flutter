import 'dart:io';
import 'package:chat_us_with_flutter/view/home_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../model/register_email.dart';
import '../view/auth/all_users.dart';

class AuthNotifier extends StateNotifier<AsyncValue<UserModel?>> {
  AuthNotifier() : super(const AsyncValue.data(null));

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  Future<String?> _uploadProfileImage(File image, String uid) async {
    try {
      final ref = _storage.ref().child('profile_images/$uid.jpg');
      await ref.putFile(image);
      return await ref.getDownloadURL();
    } catch (e) {
      print("Image upload error: $e");
      return null;
    }
  }

  Future<void> signUp(
    String email,
    String password,
    String name,
    BuildContext context,
    File? imageFile,
  ) async {
    state = const AsyncValue.loading();
    try {
      // Sign up user
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      User? user = userCredential.user;

      if (user != null) {
        // Upload profile image if selected
        String? profileImageUrl;
        if (imageFile != null) {
          profileImageUrl = await _uploadProfileImage(imageFile, user.uid);
        }

        // Create new user model
        UserModel newUser = UserModel(
          uid: user.uid,
          email: email,
          name: name,
          profileImageUrl: profileImageUrl ?? '',
        );

        // Save user data to Firestore
        await _firestore.collection('users').doc(user.uid).set(newUser.toMap());

        // Update state
        state = AsyncValue.data(newUser);
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const HomeScreen()),
        );
      }
    } catch (e) {
      print("Sign-up error: $e");
      state = AsyncValue.error(e, StackTrace.current);
    }
  }

  Future<void> login(
      String email, String password, BuildContext context) async {
    state = const AsyncValue.loading();
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      User? user = userCredential.user;

      if (user != null) {
        DocumentSnapshot<Map<String, dynamic>> userDoc =
            await _firestore.collection('users').doc(user.uid).get();

        UserModel fetchedUser = UserModel.fromMap(userDoc.data()!);
        state = AsyncValue.data(fetchedUser);

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const AllUsers()),
        );
      }
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }
  }

  Future<void> logout() async {
    await _auth.signOut();
    state = const AsyncValue.data(null);
  }
}
