import 'package:dantex/models/book.dart';
import 'package:dantex/models/book_state.dart';
import 'package:dantex/providers/book.dart';
import 'package:dantex/theme/dante_colors.dart';
import 'package:dantex/widgets/edit_book/optional_book_fields.dart';
import 'package:dantex/widgets/edit_book/required_book_fields.dart';
import 'package:dantex/widgets/shared/dante_loading_indicator.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class AddCustomBookScreen extends ConsumerStatefulWidget {
  const AddCustomBookScreen({super.key});

  static String get routeName => 'add_custom_book';
  static String get routeLocation => '/$routeName';

  @override
  ConsumerState<AddCustomBookScreen> createState() =>
      _AddCustomBookScreenState();
}

class _AddCustomBookScreenState extends ConsumerState<AddCustomBookScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _authorsController = TextEditingController();
  final _pagesController = TextEditingController();
  final _subtitleController = TextEditingController();
  final _publishedDateController = TextEditingController();
  final _isbnController = TextEditingController();
  final _summaryController = TextEditingController();

  String languageIsoCode = 'Other';
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
    final danteColors = Theme.of(context).extension<DanteColors>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('add_manual_book.add_book_manually').tr(),
        leading: BackButton(
          onPressed: () => context.pop(),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: loading
            ? const Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    DanteLoadingIndicator(),
                    SizedBox(height: 16),
                    Text('Creating book...'),
                  ],
                ),
              )
            : Form(
                key: _formKey,
                child: ListView(
                  children: [
                    RequiredBookFields(
                      titleController: _titleController,
                      authorsController: _authorsController,
                      pagesController: _pagesController,
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
                    ),
                  ],
                ),
              ),
      ),
      bottomNavigationBar: loading
          ? null
          : SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: [
                    Expanded(
                      child: TextButton(
                        onPressed: () async => _createBook(BookState.readLater),
                        child: Text(
                          'book_state.for_later'.tr().toUpperCase(),
                          style: TextStyle(color: danteColors?.forLaterColor),
                        ),
                      ),
                    ),
                    Expanded(
                      child: TextButton(
                        onPressed: () async => _createBook(BookState.reading),
                        child: Text(
                          'book_state.reading'.tr().toUpperCase(),
                          style: TextStyle(color: danteColors?.readingColor),
                        ),
                      ),
                    ),
                    Expanded(
                      child: TextButton(
                        onPressed: () async => _createBook(BookState.read),
                        child: Text(
                          'book_state.read'.tr().toUpperCase(),
                          style: TextStyle(color: danteColors?.readColor),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }

  Future<void> _createBook(BookState state) async {
    if (_formKey.currentState?.validate() ?? false) {
      setState(() => loading = true);
      final book = Book(
        // Placeholder as Firebase will create this for us.
        id: '-1',
        title: _titleController.text,
        subTitle: _subtitleController.text,
        author: _authorsController.text,
        state: state,
        pageCount: int.tryParse(_pagesController.text) ?? 0,
        currentPage: 0,
        publishedDate: _publishedDateController.text,
        position: 0,
        isbn: _isbnController.text,
        thumbnailAddress: null,
        startDate: null,
        endDate: null,
        forLaterDate: state == BookState.readLater ? DateTime.now() : null,
        language: languageIsoCode,
        rating: 0,
        notes: null,
        summary: _summaryController.text,
        googleBooksLink: null,
        labels: [],
      );

      await ref.read(bookRepositoryProvider).addBook(book);

      setState(() => loading = false);
      if (mounted) {
        Navigator.of(context).pop();
      }
    }
  }
}
