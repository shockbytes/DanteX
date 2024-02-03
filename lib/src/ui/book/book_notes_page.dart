import 'package:cached_network_image/cached_network_image.dart';
import 'package:dantex/src/providers/book.dart';
import 'package:dantex/src/providers/repository.dart';
import 'package:dantex/src/ui/core/generic_error_widget.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class BookNotesPage extends ConsumerStatefulWidget {
  final String id;

  const BookNotesPage({required this.id, super.key});

  @override
  ConsumerState<BookNotesPage> createState() => _BookNotesPageState();
}

class _BookNotesPageState extends ConsumerState<BookNotesPage> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final book = ref.watch(bookProvider(widget.id));

    return book.when(
      data: (book) {
        _controller.text = book.notes ?? '';
        return Scaffold(
          appBar: AppBar(
            leading: const BackButton(),
            title: Text(
              'book_notes.my_notes'.tr(),
              key: const ValueKey('book-notes-app-bar-title'),
            ),
          ),
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        'book_notes.subtitle'.tr(
                          namedArgs: {'title': book.title},
                        ),
                        softWrap: true,
                      ),
                    ),
                    const SizedBox(width: 20),
                    CachedNetworkImage(
                      key: const ValueKey('book-notes-image'),
                      imageUrl: book.thumbnailAddress!,
                      width: 40,
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Expanded(
                  child: TextField(
                    controller: _controller,
                    textAlignVertical: TextAlignVertical.top,
                    maxLines: null,
                    expands: true,
                    decoration: InputDecoration(
                      hintText: 'book_notes.my_thoughts'.tr(),
                      border: const OutlineInputBorder(),
                    ),
                  ),
                ),
              ],
            ),
          ),
          bottomNavigationBar: SafeArea(
            child: Padding(
              padding:
                  const EdgeInsets.only(top: 20.0, left: 20.0, right: 20.0),
              child: Row(
                children: [
                  InkWell(
                    onTap: () async {
                      _controller.clear();
                      await ref.read(bookRepositoryProvider).deleteNotes(
                            widget.id,
                          );
                    },
                    child: Row(
                      children: [
                        const Icon(Icons.delete_outline),
                        Text('delete'.tr()),
                      ],
                    ),
                  ),
                  const Spacer(),
                  InkWell(
                    onTap: () async {
                      await ref.read(bookRepositoryProvider).saveNotes(
                            widget.id,
                            _controller.text,
                          );
                      if (context.mounted) {
                        Navigator.of(context).pop();
                      }
                    },
                    child: Row(
                      children: [
                        Text('save'.tr()),
                        const Icon(Icons.check_outlined),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
      error: (error, stackTrace) => GenericErrorWidget(
        error,
        key: const ValueKey('book-notes-error'),
      ),
      loading: () => const CircularProgressIndicator.adaptive(
        key: ValueKey('book-notes-loading'),
      ),
    );
  }
}
