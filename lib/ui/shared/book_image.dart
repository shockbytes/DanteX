import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class BookImage extends StatelessWidget {
  const BookImage(
    this.imageUrl, {
    required this.size,
    super.key,
  });

  final String? imageUrl;
  final double size;

  @override
  Widget build(BuildContext context) {
    final imageUrl = this.imageUrl;
    if (imageUrl == null || imageUrl.isEmpty) {
      return Icon(
        key: const ValueKey('book_image_placeholder'),
        Icons.image_outlined,
        size: size,
      );
    }

    final isLocalUrl = imageUrl.startsWith('file://');

    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: isLocalUrl
          ? Image.file(
              File(Uri.parse(imageUrl).path),
              width: size,
              height: size,
            )
          : CachedNetworkImage(
              imageUrl: imageUrl,
              height: size,
              progressIndicatorBuilder: (context, url, progress) => Center(
                child: CircularProgressIndicator(
                  value: progress.progress,
                ),
              ),
            ),
    );
  }
}
