import 'dart:io';
import 'package:chat_us_with_flutter/model/register_email.dart';
import 'package:chat_us_with_flutter/view_model/auth_notifir.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../view_model/pic_image_function.dart';

final authProvider =
    StateNotifierProvider<AuthNotifier, AsyncValue<UserModel?>>((ref) {
  return AuthNotifier();
});

//////fetch all userss
final usersProvider = StreamProvider<List<UserModel>>((ref) {
  return FirebaseFirestore.instance.collection('users').snapshots().map(
    (snapshot) {
      return snapshot.docs.map((doc) => UserModel.fromMap(doc.data())).toList();
    },
  );
});

//////////////////////////////////////////////////////////////////////////
final imagePickerProvider = StateNotifierProvider<ImagePickerNotifier, File?>(
    (ref) => ImagePickerNotifier());
