import 'package:dantex/src/data/book/entity/book.dart';
import 'package:dantex/src/providers/service.dart';
import 'package:dantex/src/ui/book/book_image.dart';
import 'package:dantex/src/ui/core/dante_components.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class RecommendBookBottomSheet extends ConsumerStatefulWidget {
  final Book book;
  final bool isWeb;

  const RecommendBookBottomSheet({
    required this.book,
    super.key,
    this.isWeb = false,
  });

  @override
  createState() => _RecommendBookBottomSheetState();
}

class _RecommendBookBottomSheetState
    extends ConsumerState<RecommendBookBottomSheet> {
  late TextEditingController textController;

  @override
  void initState() {
    super.initState();
    textController = TextEditingController();
  }

  @override
  void dispose() {
    textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            BookImage(
              widget.book.thumbnailAddress,
              size: 96,
            ),
            const SizedBox(height: 16),
            Text(
              widget.book.title,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 16),
            DanteTextField(
              controller: textController,
              maxLines: 6,
              hint: 'recommendations.enter_recommendation'.tr(),
              // formatter: LengthLimitingTextInputFormatter(180),
              maxLength: 180,
              buildCounter: (
                context, {
                required currentLength,
                required isFocused,
                required maxLength,
              }) {
                return Container(
                  child: Text(
                    '$currentLength/$maxLength',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                );
              },
            ),
            const SizedBox(height: 16),
            DanteOutlinedButton(
              child: Text('recommendations.suggest'.tr()),
              onPressed: () async {
                await ref
                    .read(recommendationsProvider)
                    .recommendBook(widget.book, textController.text);
                if (context.mounted) {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        'recommendations.success'.tr(),
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ),
                  );
                }
              },
            ),
            if (widget.isWeb) const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
