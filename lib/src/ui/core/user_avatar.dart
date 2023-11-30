


import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class UserAvatar extends StatelessWidget {
  final String? userImageUrl;

  const UserAvatar({
    required this.userImageUrl,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    if (userImageUrl != null) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(20.0),
        child: CachedNetworkImage(
          imageUrl: userImageUrl!,
          width: 40,
          height: 40,
        ),
      );
    }
    return Icon(
      Icons.account_circle_outlined,
      size: 32,
      color: Theme.of(context).colorScheme.onSurface,
    );
  }
}