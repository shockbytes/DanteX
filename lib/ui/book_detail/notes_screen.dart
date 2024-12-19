import 'package:dantex/providers/book.dart';
import 'package:dantex/providers/repository.dart';
import 'package:dantex/providers/service.dart';
import 'package:dantex/ui/book_detail/book_detail_screen.dart';
import 'package:dantex/ui/shared/book_image.dart';
import 'package:dantex/ui/shared/dante_loading_indicator.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class NotesScreen extends ConsumerStatefulWidget {
  const NotesScreen({required this.bookId, super.key});

  final String bookId;

  static String routeName = 'notes';
  static String routeLocation = routeName;
  static String navigationUrl =
      '${BookDetailScreen.routeLocation}/$routeLocation';

  @override
  ConsumerState<NotesScreen> createState() => _NotesScreenState();
}

class _NotesScreenState extends ConsumerState<NotesScreen> {
  final _notesController = TextEditingController();

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('book_detail.my_notes').tr(),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: ref.watch(bookProvider(widget.bookId)).when(
              data: (book) {
                if (book == null) {
                  return const Text('Book not found');
                }

                final notes = book.notes;
                if (notes != null) {
                  _notesController.text = notes;
                }

                return Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: const Text('book_detail.notes_description')
                              .tr(args: [book.title]),
                        ),
                        const SizedBox(width: 16),
                        BookImage(book.thumbnailAddress, size: 96),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Expanded(
                      child: TextField(
                        expands: true,
                        maxLines: null,
                        textAlignVertical: TextAlignVertical.top,
                        controller: _notesController,
                        decoration: InputDecoration(
                          border: const OutlineInputBorder(),
                          labelText: 'book_detail.notes_hint'.tr(),
                          alignLabelWithHint: true,
                          floatingLabelAlignment: FloatingLabelAlignment.start,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        OutlinedButton.icon(
                          onPressed: _notesController.clear,
                          label: const Text('book_detail.delete').tr(),
                          icon: const Icon(Icons.delete_outline),
                        ),
                        OutlinedButton.icon(
                          onPressed: () async {
                            await ref.read(bookRepositoryProvider).setNotes(
                                  book.id,
                                  _notesController.text,
                                );
                            if (context.mounted) {
                              Navigator.of(context).pop();
                            }
                          },
                          label: const Text('book_detail.save').tr(),
                          icon: const Icon(Icons.done_outline),
                        ),
                      ],
                    ),
                  ],
                );
              },
              error: (e, s) {
                ref
                    .read(loggerProvider)
                    .e('Error loading book', error: e, stackTrace: s);
                return const Text('Error loading book');
              },
              loading: DanteLoadingIndicator.new,
            ),
      ),
    );
  }
}
