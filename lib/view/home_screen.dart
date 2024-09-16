import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../common/provider/providers.dart';
import 'auth/email_login_ui.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Icon(CupertinoIcons.home),
        title: Text("We Chat"),
        actions: [
          IconButton(
            onPressed: () {},
            icon: Icon(
              Icons.search,
            ),
          ),
          Consumer(builder: (context, WidgetRef ref, child) {
            return PopupMenuButton<String>(
              icon: Icon(Icons.more_vert),
              itemBuilder: (context) => [
                PopupMenuItem<String>(
                  value: 'logout',
                  child: Text('Logout'),
                  onTap: () {
                    ref.read(authProvider.notifier).logout();
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(builder: (context) => LogInScreen()),
                    );
                  },
                ),
              ],
            );
          }),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blue,
        onPressed: () {},
        child: Icon(
          Icons.add_comment_rounded,
          color: Colors.white,
          size: 30,
        ),
      ),
    );
  }
}
