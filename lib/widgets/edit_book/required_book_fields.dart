import 'package:dantex/widgets/shared/book_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class RequiredBookFields extends StatelessWidget {
  const RequiredBookFields({
    required this.titleController,
    required this.authorsController,
    required this.pagesController,
    this.imageUrl,
    super.key,
  });

  final TextEditingController titleController;
  final TextEditingController authorsController;
  final TextEditingController pagesController;
  final String? imageUrl;

  @override
  Widget build(BuildContext context) {
    final imageUrl = this.imageUrl;
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
                  onPressed: () {},
                  iconSize: 48,
                  icon: imageUrl != null
                      ? BookImage(imageUrl, size: 48)
                      : const Icon(Icons.photo_album),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: TextFormField(
                    controller: titleController,
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
              controller: authorsController,
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
              controller: pagesController,
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
