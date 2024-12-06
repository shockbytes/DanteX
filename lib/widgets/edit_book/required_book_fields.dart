import 'dart:io';

import 'package:dantex/widgets/shared/book_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';

class RequiredBookFields extends StatefulWidget {
  const RequiredBookFields({
    required this.titleController,
    required this.authorsController,
    required this.pagesController,
    required this.onImageSelected,
    this.imageUrl,
    super.key,
  });

  final TextEditingController titleController;
  final TextEditingController authorsController;
  final TextEditingController pagesController;
  final String? imageUrl;
  final Future<void> Function(File image)? onImageSelected;

  @override
  State<RequiredBookFields> createState() => _RequiredBookFieldsState();
}

class _RequiredBookFieldsState extends State<RequiredBookFields> {
  String? imageUrl;
  bool imageLoading = false;

  @override
  void initState() {
    super.initState();
    imageUrl = widget.imageUrl;
  }

  @override
  Widget build(BuildContext context) {
    return Card.outlined(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              children: [
                IconButton(
                  style: ButtonStyle(
                    shape: WidgetStatePropertyAll(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    side: WidgetStateBorderSide.resolveWith(
                      (states) {
                        return BorderSide(
                          color: Theme.of(context).dividerColor,
                        );
                      },
                    ),
                  ),
                  onPressed: () async {
                    setState(() => imageLoading = true);
                    final picker = ImagePicker();
                    final pickedFile =
                        await picker.pickImage(source: ImageSource.gallery);

                    if (pickedFile != null) {
                      final directory = await getTemporaryDirectory();
                      final cachedImagePath =
                          '${directory.path}/${pickedFile.name}';
                      final cachedImage = File(cachedImagePath);

                      // Copy the image to the cache directory
                      await File(pickedFile.path).copy(cachedImagePath);

                      await widget.onImageSelected?.call(cachedImage);
                      setState(() => imageUrl = cachedImage.uri.toString());
                    }
                    setState(() => imageLoading = false);
                  },
                  iconSize: 48,
                  icon: imageLoading
                      ? const SizedBox(
                          height: 48,
                          width: 48,
                          child: CircularProgressIndicator(),
                        )
                      : BookImage(imageUrl, size: 48),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: TextFormField(
                    controller: widget.titleController,
                    decoration: InputDecoration(
                      labelText: 'book.title'.tr(),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'add_manual_book.title_required'.tr();
                      }
                      return null;
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            TextFormField(
              controller: widget.authorsController,
              decoration: InputDecoration(
                labelText: 'book.author'.plural(2),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'add_manual_book.author_required'.tr();
                }
                return null;
              },
            ),
            const SizedBox(height: 8),
            TextFormField(
              controller: widget.pagesController,
              decoration: InputDecoration(
                labelText: 'book.pages'.tr(),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'add_manual_book.pages_required'.tr();
                }
                return null;
              },
            ),
          ],
        ),
      ),
    );
  }
}
