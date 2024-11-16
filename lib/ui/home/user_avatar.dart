import 'package:dantex/providers/auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class UserAvatar extends ConsumerWidget {
  const UserAvatar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userProvider);

    return user.maybeWhen(
      data: (user) {
        final imageUrl = user?.photoUrl;
        if (imageUrl == null) {
          return const Icon(Icons.account_circle_outlined, size: 40);
        }
        return CircleAvatar(
          backgroundImage: NetworkImage(imageUrl),
        );
      },
      orElse: () => const Icon(Icons.account_circle_outlined, size: 40),
    );
  }
}
