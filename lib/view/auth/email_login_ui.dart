import 'package:chat_us_with_flutter/view/auth/email_signup_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../common/provider/providers.dart';
import '../../common/widget/textfield.dart';

class LogInScreen extends StatelessWidget {
  LogInScreen({super.key});
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 40),

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

              // Handle different states
              Consumer(
                builder: (context, WidgetRef ref, child) {
                  final authState = ref.watch(authProvider);

                  return ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        ref.read(authProvider.notifier).login(
                            _emailController.text.trim(),
                            _passwordController.text.trim(),
                            context);
                      }
                    },
                    child: authState.when(
                      data: (_) => const Text(
                        'LogIn',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      error: (err, stack) {
                        WidgetsBinding.instance.addPostFrameCallback((_) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: const Text(
                                'Something went wrong!',
                                style: TextStyle(color: Colors.white),
                              ),
                              backgroundColor: Colors.red,
                            ),
                          );
                        });
                        return const Text(
                          'LogIn',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        );
                      },
                      loading: () => Center(
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
                  const Text("Dont  have an account?"),
                  const SizedBox(width: 10),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => SignUpScreen()),
                      );
                    },
                    child: const Text(
                      "SignUp",
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
    );
  }
}
