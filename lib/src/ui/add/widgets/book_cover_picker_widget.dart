import 'package:flutter/material.dart';

class BookCoverPickerWidget extends StatelessWidget {
  final BookCoverController controller;
  final double size;
  final Function(String uploadedUrl)? onImageUploaded;

  const BookCoverPickerWidget({
    required this.controller,
    required this.size,
    this.onImageUploaded,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(
          Radius.circular(8),
        ),
        border: Border.all(
          width: 0.7,
          color: Theme.of(context).colorScheme.onSurface,
        ),
      ),
      child: InkWell(
        child: ValueListenableBuilder<String?>(
          valueListenable: controller,
          builder: (context, imageUrl, _) {
            return _buildBookCover(imageUrl);
          },
        ),
        onTap: () {
          // TODO Pick image
        },
      ),
    );
  }

  Widget _buildBookCover(String? imageUrl) {
    if (imageUrl != null) {
      return Padding(
        padding: const EdgeInsets.all(4.0),
        child: Image.network(
          imageUrl,
          width: size,
        ),
      );
    } else {
      return Icon(
        Icons.image_outlined,
        size: size * 0.66,
      );
    }
  }
}

class BookCoverController extends ValueNotifier<String?> {
  BookCoverController(super.value);
}