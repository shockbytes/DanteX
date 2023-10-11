import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class BookImage extends StatelessWidget {
  final String? _imageUrl;
  final double size;

  const BookImage(
    this._imageUrl, {
    super.key,
    required this.size,
  });

  @override
  Widget build(BuildContext context) {
    if (_imageUrl != null) {
      return CachedNetworkImage(
        imageUrl: _imageUrl!,
        height: size,
      );
    } else {
      return Icon(
        Icons.image,
        size: size,
      );
    }
  }
}
