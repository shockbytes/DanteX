import 'package:cached_network_image/cached_network_image.dart';
import 'package:dantex/providers/auth.dart';
import 'package:dantex/providers/logger.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class UserAvatar extends ConsumerWidget {
  const UserAvatar({super.key, this.size = 40});

  final double size;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userProvider);

    return user.maybeWhen(
      data: (user) {
        final imageUrl = user?.photoUrl;
        if (imageUrl == null) {
          return Icon(Icons.account_circle_outlined, size: size);
        }

        return CircleAvatar(
          radius: size / 2,
          backgroundColor: Colors.transparent,
          child: ClipOval(
            child: CachedNetworkImage(
              imageUrl: imageUrl,
              fit: BoxFit.cover,
              width: size,
              height: size,
              errorWidget: (context, url, error) {
                ref.read(loggerProvider).e(
                      'Error loading user image',
                      error: error,
                    );
                return Icon(Icons.account_circle_outlined, size: size);
              },
              placeholder: (context, url) => const Center(
                child: SizedBox(
                  height: 160,
                  width: 160,
                  child: Padding(
                    padding: EdgeInsets.all(40),
                    child: CircularProgressIndicator(),
                  ),
                ),
              ),
            ),
          ),
        );
      },
      orElse: () => Icon(Icons.account_circle_outlined, size: size),
    );
  }
}
