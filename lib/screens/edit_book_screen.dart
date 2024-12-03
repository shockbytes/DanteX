import 'package:dantex/models/book.dart';
import 'package:dantex/providers/book.dart';
import 'package:dantex/widgets/edit_book/optional_book_fields.dart';
import 'package:dantex/widgets/edit_book/required_book_fields.dart';
import 'package:dantex/widgets/shared/dante_loading_indicator.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class EditBookScreen extends ConsumerStatefulWidget {
  const EditBookScreen({required this.bookId, super.key});

  final String bookId;

  static String get routeName => 'edit_book';
  static String get routeLocation => '/$routeName/:bookId';

  @override
  ConsumerState<EditBookScreen> createState() => _EditBookScreenState();
}

class _EditBookScreenState extends ConsumerState<EditBookScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _authorsController = TextEditingController();
  final _pagesController = TextEditingController();
  final _subtitleController = TextEditingController();
  final _publishedDateController = TextEditingController();
  final _isbnController = TextEditingController();
  final _summaryController = TextEditingController();

  String languageIsoCode = '';
  bool loading = false;

  @override
  void dispose() {
    _titleController.dispose();
    _authorsController.dispose();
    _pagesController.dispose();
    _subtitleController.dispose();
    _publishedDateController.dispose();
    _isbnController.dispose();
    _summaryController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final book = ref.watch(bookProvider(widget.bookId));

    return Scaffold(
      appBar: AppBar(
        title: const Text('edit_book.edit_book').tr(),
      ),
      body: book.when(
        data: (book) {
          if (book == null) {
            return Center(child: const Text('edit_book.book_not_found').tr());
          }

          _titleController.text = book.title;
          _authorsController.text = book.author;
          _pagesController.text = book.pageCount.toString();
          _subtitleController.text = book.subTitle;
          _publishedDateController.text = book.publishedDate;
          _isbnController.text = book.isbn;
          _summaryController.text = book.summary ?? '';
          languageIsoCode = book.language;

          return Form(
            key: _formKey,
            child: ListView(
              children: [
                RequiredBookFields(
                  titleController: _titleController,
                  authorsController: _authorsController,
                  pagesController: _pagesController,
                  imageUrl: book.thumbnailAddress,
                ),
                const SizedBox(height: 16),
                OptionalBookFields(
                  subtitleController: _subtitleController,
                  publishedDateController: _publishedDateController,
                  isbnController: _isbnController,
                  summaryController: _summaryController,
                  onLanguageChanged: (languageIsoCode) => setState(
                    () => this.languageIsoCode = languageIsoCode,
                  ),
                  initialLanguageIsoCode: languageIsoCode,
                ),
              ],
            ),
          );
        },
        error: (e, s) {
          return null;
        },
        loading: () => const Center(
          child: DanteLoadingIndicator(),
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: [
              Expanded(
                child: TextButton.icon(
                  icon: const Icon(Icons.delete_outline, color: Colors.red),
                  onPressed: () async => showDialog(
                    context: context,
                    builder: (context) => _DiscardChangesDialog(),
                  ),
                  label: Text(
                    'edit_book.discard'.tr().toUpperCase(),
                    style: const TextStyle(color: Colors.red),
                  ),
                ),
              ),
              Expanded(
                child: TextButton.icon(
                  icon: const Icon(Icons.done_outline, color: Colors.grey),
                  onPressed: () async => _saveChanges(book.value),
                  label: Text(
                    'edit_book.save'.tr().toUpperCase(),
                    style: const TextStyle(color: Colors.grey),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _saveChanges(Book? book) async {
    if (!(_formKey.currentState?.validate() ?? false)) {
      return;
    }

    if (book == null) {
      return;
    }

    final updatedBook = book.copyWith(
      title: _titleController.text,
      author: _authorsController.text,
      pageCount: int.tryParse(_pagesController.text) ?? 0,
      subTitle: _subtitleController.text,
      publishedDate: _publishedDateController.text,
      isbn: _isbnController.text,
      summary: _summaryController.text,
      language: languageIsoCode,
    );

    setState(() => loading = true);
    await ref.read(bookRepositoryProvider).updateBook(updatedBook);
    setState(() => loading = false);
    if (mounted) {
      Navigator.of(context).pop();
    }
  }
}

class _DiscardChangesDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Row(
        children: [
          const Icon(Icons.delete_outline, color: Colors.red, size: 32),
          const SizedBox(width: 16),
          Expanded(
            child: const Text('edit_book.discard_changes').tr(),
          ),
        ],
      ),
      content: const Text('edit_book.discard_changes_description').tr(),
      actions: [
        TextButton(
          onPressed: () {
            // Pop the dialog and the screen.
            Navigator.of(context).pop();
            Navigator.of(context).pop();
          },
          child: Text('edit_book.discard'.tr().toUpperCase()),
        ),
      ],
    );
  }
}
