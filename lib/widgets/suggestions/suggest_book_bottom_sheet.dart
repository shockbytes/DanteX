import 'package:dantex/logger/event.dart';
import 'package:dantex/models/book.dart';
import 'package:dantex/providers/book.dart';
import 'package:dantex/providers/logger.dart';
import 'package:dantex/widgets/shared/book_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SuggestBookBottomSheet extends ConsumerStatefulWidget {
  const SuggestBookBottomSheet({required this.book, super.key});

  final Book book;

  @override
  ConsumerState<SuggestBookBottomSheet> createState() =>
      _SuggestBookBottomSheetState();
}

class _SuggestBookBottomSheetState
    extends ConsumerState<SuggestBookBottomSheet> {
  final textController = TextEditingController();

  @override
  void dispose() {
    textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context);
    return ConstrainedBox(
      constraints: BoxConstraints(
        maxHeight: mq.size.height * 0.95,
      ),
      child: SafeArea(
        child: Padding(
          padding: EdgeInsets.only(
            left: 16,
            right: 16,
            bottom: mq.viewInsets.bottom,
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                BookImage(widget.book.thumbnailAddress, size: 96),
                const SizedBox(height: 16),
                Text(
                  widget.book.title,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: textController,
                  maxLength: 180,
                  maxLines: 5,
                  decoration: InputDecoration(
                    hintText: 'suggestions.suggest_book_hint'.tr(),
                    border: const OutlineInputBorder(),
                  ),
                  buildCounter: (
                    context, {
                    required currentLength,
                    required isFocused,
                    required maxLength,
                  }) =>
                      Text(
                    '$currentLength/$maxLength',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ),
                const SizedBox(height: 16),
                OutlinedButton(
                  onPressed: () async {
                    final logger = ref.read(loggerProvider);
                    Navigator.of(context).pop();
                    await ref
                        .read(recommendationsRepositoryProvider)
                        .recommendBook(
                          widget.book,
                          textController.text,
                        );
                    logger.trackEvent(DanteEvent.suggestBook);
                  },
                  child: const Text('suggestions.suggest').tr(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
