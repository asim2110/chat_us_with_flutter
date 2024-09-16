// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_storage/firebase_storage.dart';
// import 'package:image_picker/image_picker.dart';
// import '../../common/provider/providers.dart';
// import '../../common/widget/textfield.dart';

// class UserModel {
//   final String uid;
//   final String email;
//   final String name;
//   final String profileImageUrl;

//   UserModel({
//     required this.uid,
//     required this.email,
//     required this.name,
//     required this.profileImageUrl,
//   });

//   Map<String, dynamic> toMap() {
//     return {
//       'uid': uid,
//       'email': email,
//       'name': name,
//       'profileImageUrl': profileImageUrl,
//     };
//   }

//   factory UserModel.fromMap(Map<String, dynamic> data) {
//     return UserModel(
//       uid: data['uid'] ?? '',
//       email: data['email'] ?? '',
//       name: data['name'] ?? '',
//       profileImageUrl: data['profileImageUrl'] ?? '',
//     );
//   }
// }

// class AuthNotifier extends StateNotifier<AsyncValue<UserModel?>> {
//   AuthNotifier() : super(const AsyncValue.data(null));

//   final FirebaseAuth _auth = FirebaseAuth.instance;
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;
//   final FirebaseStorage _storage = FirebaseStorage.instance;

//   Future<String?> _uploadProfileImage(File image, String uid) async {
//     try {
//       final ref = _storage.ref().child('profile_images/$uid.jpg');
//       await ref.putFile(image);
//       return await ref.getDownloadURL();
//     } catch (e) {
//       print("Image upload error: $e");
//       return null;
//     }
//   }

//   Future<void> signUp(
//     String email,
//     String password,
//     String name,
//     BuildContext context,
//     File? imageFile,
//   ) async {
//     state = const AsyncValue.loading();
//     try {
//       // Sign up user
//       UserCredential userCredential =
//           await _auth.createUserWithEmailAndPassword(
//         email: email,
//         password: password,
//       );

//       User? user = userCredential.user;

//       if (user != null) {
//         // Upload profile image if selected
//         String? profileImageUrl;
//         if (imageFile != null) {
//           profileImageUrl = await _uploadProfileImage(imageFile, user.uid);
//         }

//         // Create new user model
//         UserModel newUser = UserModel(
//           uid: user.uid,
//           email: email,
//           name: name,
//           profileImageUrl: profileImageUrl ?? '',
//         );

//         // Save user data to Firestore
//         await _firestore.collection('users').doc(user.uid).set(newUser.toMap());

//         // Update state
//         state = AsyncValue.data(newUser);
//       }
//     } catch (e) {
//       print("Sign-up error: $e");
//       state = AsyncValue.error(e, StackTrace.current);
//     }
//   }
// }

// class SignUpScreen extends StatelessWidget {
//   SignUpScreen({super.key});
//   final _formKey = GlobalKey<FormState>();

//   final TextEditingController _nameController = TextEditingController();
//   final TextEditingController _emailController = TextEditingController();
//   final TextEditingController _passwordController = TextEditingController();

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Padding(
//         padding: const EdgeInsets.all(22.0),
//         child: Form(
//           key: _formKey,
//           child: SingleChildScrollView(
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 const SizedBox(height: 40),
//                 Consumer(builder: (context, WidgetRef ref, child) {
//                   final imageFile = ref.watch(imagePickerProvider);
//                   return Center(
//                     child: Container(
//                       height: 200,
//                       width: 200,
//                       child: Stack(
//                         children: [
//                           Positioned(
//                             top: 17,
//                             left: 20,
//                             child: CircleAvatar(
//                               radius: 80,
//                               backgroundColor: Colors.white,
//                               backgroundImage: imageFile != null
//                                   ? FileImage(imageFile)
//                                   : const AssetImage('images/user.png')
//                                       as ImageProvider,
//                             ),
//                           ),
//                           Positioned(
//                             top: 125,
//                             left: 160,
//                             child: GestureDetector(
//                               onTap: () {
//                                 _showImagePickerOptions(context, ref);
//                               },
//                               child: Container(
//                                   decoration: const BoxDecoration(
//                                     color: Colors.white,
//                                     shape: BoxShape.circle,
//                                   ),
//                                   child: const Icon(
//                                     Icons.add_a_photo_outlined,
//                                     color: Color.fromARGB(255, 68, 71, 249),
//                                   )),
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   );
//                 }),
//                 const SizedBox(height: 40),
//                 CustomTextField(
//                   keyboardType: TextInputType.emailAddress,
//                   controller: _nameController,
//                   labelText: "Name",
//                   hintText: 'Enter your Name',
//                   validator: (value) {
//                     if (value == null || value.isEmpty) {
//                       return 'Required Name';
//                     }
//                     return null;
//                   },
//                 ),
//                 const SizedBox(height: 20),
//                 CustomTextField(
//                   keyboardType: TextInputType.emailAddress,
//                   controller: _emailController,
//                   labelText: 'Email',
//                   hintText: 'Enter your Email',
//                   validator: (value) {
//                     if (value == null || value.isEmpty) {
//                       return 'Required Email';
//                     }
//                     return null;
//                   },
//                 ),
//                 const SizedBox(height: 20),
//                 CustomTextField(
//                   keyboardType: TextInputType.text,
//                   controller: _passwordController,
//                   labelText: 'Password',
//                   hintText: 'Enter Password',
//                   validator: (value) {
//                     if (value == null || value.isEmpty) {
//                       return 'Required Password';
//                     }
//                     return null;
//                   },
//                 ),
//                 const SizedBox(height: 40),
//                 Consumer(
//                   builder: (context, WidgetRef ref, child) {
//                     final authState = ref.watch(authProvider);

//                     return ElevatedButton(
//                       onPressed: () {
//                         if (_formKey.currentState!.validate()) {
//                           final imageFile = ref.read(imagePickerProvider);
//                           ref.read(authProvider.notifier).signUp(
//                                 _emailController.text.trim(),
//                                 _passwordController.text.trim(),
//                                 _nameController.text.trim(),
//                                 context,
//                                 imageFile,
//                               );
//                         }
//                       },
//                       child: authState.when(
//                         data: (_) => const Text(
//                           'Sign Up',
//                           style: TextStyle(
//                             fontSize: 18,
//                             fontWeight: FontWeight.bold,
//                             color: Colors.white,
//                           ),
//                         ),
//                         error: (err, stack) {
//                           WidgetsBinding.instance.addPostFrameCallback((_) {
//                             ScaffoldMessenger.of(context).showSnackBar(
//                               const SnackBar(
//                                 content: Text(
//                                   'Sign-up failed. Please try again.',
//                                   style: TextStyle(color: Colors.white),
//                                 ),
//                                 backgroundColor: Colors.red,
//                               ),
//                             );
//                           });
//                           return const Text(
//                             'Sign Up',
//                             style: TextStyle(
//                               fontSize: 18,
//                               fontWeight: FontWeight.bold,
//                               color: Colors.white,
//                             ),
//                           );
//                         },
//                         loading: () => const Center(
//                           child: CircularProgressIndicator(
//                             color: Colors.white,
//                           ),
//                         ),
//                       ),
//                       style: ElevatedButton.styleFrom(
//                         backgroundColor: const Color.fromARGB(255, 42, 28, 246),
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(10),
//                         ),
//                         padding: const EdgeInsets.symmetric(
//                             horizontal: 24, vertical: 12),
//                       ),
//                     );
//                   },
//                 ),
//                 const SizedBox(height: 40),
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     const Text("Already have an account?"),
//                     const SizedBox(width: 10),
//                     GestureDetector(
//                       onTap: () {
//                         // Navigator.push(
//                         //   context,
//                         //   MaterialPageRoute(
//                         //       builder: (context) => LogInScreen()),
//                         // );
//                       },
//                       child: const Text(
//                         "Log In",
//                         style: TextStyle(
//                           fontSize: 20,
//                           fontWeight: FontWeight.w500,
//                           color: Color.fromARGB(255, 42, 28, 246),
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   void _showImagePickerOptions(BuildContext context, WidgetRef ref) {
//     showModalBottomSheet(
//       context: context,
//       builder: (_) {
//         return Wrap(
//           children: [
//             ListTile(
//               leading: Icon(Icons.camera),
//               title: Text('Camera'),
//               onTap: () {
//                 Navigator.of(context).pop();
//                 ref.read(imagePickerProvider.notifier).pickImageFromCamera();
//               },
//             ),
//             ListTile(
//               leading: Icon(Icons.photo_library),
//               title: Text('Gallery'),
//               onTap: () {
//                 Navigator.of(context).pop();
//                 ref.read(imagePickerProvider.notifier).pickImageFromGallery();
//               },
//             ),
//           ],
//         );
//       },
//     );
//   }
// }
