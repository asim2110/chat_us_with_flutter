import 'package:chat_us_with_flutter/view_model/auth_notifir.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../common/provider/providers.dart';

class AllUsers extends ConsumerWidget {
  const AllUsers({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Watch the users stream
    final usersState = ref.watch(usersProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('All Users')),
      body: usersState.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stackTrace) => Center(
          child: Text('Error: ${error.toString()}'),
        ),
        data: (users) {
          if (users.isNotEmpty) {
            return ListView.builder(
              itemCount: users.length,
              itemBuilder: (context, index) {
                final user = users[index];
                return ListTile(
                  leading: CircleAvatar(
                    backgroundImage: NetworkImage(user.profileImageUrl),
                  ),
                  title: Text(user.name),
                  subtitle: Text(user.email),
                );
              },
            );
          } else {
            return const Center(child: Text('No users found'));
          }
        },
      ),
    );
  }
}
