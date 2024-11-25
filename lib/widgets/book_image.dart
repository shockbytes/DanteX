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
    if (imageUrl == null) {
      return Icon(
        key: const ValueKey('book_image_placeholder'),
        Icons.image_outlined,
        size: size,
      );
    }

    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: SizedBox(
        width: size,
        child: CachedNetworkImage(
          imageUrl: imageUrl,
          width: size,
          progressIndicatorBuilder: (context, url, progress) => Center(
            child: CircularProgressIndicator(
              value: progress.progress,
            ),
          ),
        ),
      ),
    );
  }
}
