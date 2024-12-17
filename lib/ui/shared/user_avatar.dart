import 'package:cached_network_image/cached_network_image.dart';
import 'package:dantex/providers/auth.dart';
import 'package:dantex/providers/service.dart';
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

        return _NetworkAvatar(imageUrl: imageUrl, size: size);
      },
      orElse: () => Icon(Icons.account_circle_outlined, size: size),
    );
  }
}

class ExternalUserAvatar extends StatelessWidget {
  const ExternalUserAvatar({required this.imageUrl, super.key, this.size = 40});

  final String? imageUrl;
  final double size;

  @override
  Widget build(BuildContext context) {
    final imageUrl = this.imageUrl;
    if (imageUrl == null) {
      return Icon(Icons.account_circle_outlined, size: size);
    }

    return _NetworkAvatar(imageUrl: imageUrl, size: size);
  }
}

class _NetworkAvatar extends ConsumerWidget {
  const _NetworkAvatar({required this.imageUrl, required this.size});

  final String imageUrl;
  final double size;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return CachedNetworkImage(
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
      imageBuilder: (context, imageProvider) => CircleAvatar(
        radius: size / 2,
        backgroundImage: imageProvider,
      ),
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
    );
  }
}
