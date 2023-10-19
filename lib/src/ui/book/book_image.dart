import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class BookImage extends StatelessWidget {
  final String? _imageUrl;
  final double size;

  const BookImage(
    this._imageUrl, {
    required this.size,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    if (_imageUrl != null) {
      return CachedNetworkImage(
        imageUrl: _imageUrl!,
        width: size,
      );
    } else {
      return Icon(
        Icons.image,
        size: size,
      );
    }
  }
}
