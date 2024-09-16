import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../common/provider/providers.dart';
import '../../common/widget/textfield.dart';
import 'email_login_ui.dart';

class SignUpScreen extends StatelessWidget {
  SignUpScreen({super.key});
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(22.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 40),
                Consumer(builder: (context, WidgetRef ref, child) {
                  final imageFile = ref.watch(imagePickerProvider);
                  return Center(
                    child: Container(
                      height: 200,
                      width: 200,
                      child: Stack(
                        children: [
                          Positioned(
                            top: 17,
                            left: 20,
                            child: CircleAvatar(
                              radius: 80,
                              backgroundColor: Colors.white,
                              backgroundImage: imageFile != null
                                  ? FileImage(imageFile)
                                  : const AssetImage('images/user.png')
                                      as ImageProvider,
                            ),
                          ),
                          Positioned(
                            top: 125,
                            left: 160,
                            child: GestureDetector(
                              onTap: () {
                                _showImagePickerOptions(context, ref);
                              },
                              child: Container(
                                  decoration: const BoxDecoration(
                                    color: Colors.white,
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(
                                    Icons.add_a_photo_outlined,
                                    color: Color.fromARGB(255, 68, 71, 249),
                                  )),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }),
                const SizedBox(height: 40),
                CustomTextField(
                  keyboardType: TextInputType.emailAddress,
                  controller: _nameController,
                  labelText: "Name",
                  hintText: 'Enter your Name',
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Required Name';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                CustomTextField(
                  keyboardType: TextInputType.emailAddress,
                  controller: _emailController,
                  labelText: 'Email',
                  hintText: 'Enter your Email',
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Required Email';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                CustomTextField(
                  keyboardType: TextInputType.text,
                  controller: _passwordController,
                  labelText: 'Password',
                  hintText: 'Enter Password',
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Required Password';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 40),
                Consumer(
                  builder: (context, WidgetRef ref, child) {
                    final authState = ref.watch(authProvider);

                    return ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          final imageFile = ref.read(imagePickerProvider);
                          ref.read(authProvider.notifier).signUp(
                                _emailController.text.trim(),
                                _passwordController.text.trim(),
                                _nameController.text.trim(),
                                context,
                                imageFile,
                              );
                        }
                      },
                      child: authState.when(
                        data: (_) => const Text(
                          'Sign Up',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        error: (err, stack) {
                          WidgetsBinding.instance.addPostFrameCallback((_) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                  'Sign-up failed. Please try again.',
                                  style: TextStyle(color: Colors.white),
                                ),
                                backgroundColor: Colors.red,
                              ),
                            );
                          });
                          return const Text(
                            'Sign Up',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          );
                        },
                        loading: () => const Center(
                          child: CircularProgressIndicator(
                            color: Colors.white,
                          ),
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromARGB(255, 42, 28, 246),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 24, vertical: 12),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 40),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Already have an account?"),
                    const SizedBox(width: 10),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => LogInScreen()),
                        );
                      },
                      child: const Text(
                        "Log In",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w500,
                          color: Color.fromARGB(255, 42, 28, 246),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showImagePickerOptions(BuildContext context, WidgetRef ref) {
    showModalBottomSheet(
      context: context,
      builder: (_) {
        return Wrap(
          children: [
            ListTile(
              leading: Icon(Icons.camera),
              title: Text('Camera'),
              onTap: () {
                Navigator.of(context).pop();
                ref.read(imagePickerProvider.notifier).pickImageFromCamera();
              },
            ),
            ListTile(
              leading: Icon(Icons.photo_library),
              title: Text('Gallery'),
              onTap: () {
                Navigator.of(context).pop();
                ref.read(imagePickerProvider.notifier).pickImageFromGallery();
              },
            ),
          ],
        );
      },
    );
  }
}
