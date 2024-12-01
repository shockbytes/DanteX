import 'package:dantex/models/book.dart';
import 'package:dantex/models/book_state.dart';
import 'package:dantex/providers/book.dart';
import 'package:dantex/theme/dante_colors.dart';
import 'package:dantex/widgets/language_picker.dart';
import 'package:dantex/widgets/pulsing_grid.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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

  String language = 'Other';
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
                    PulsingGrid(),
                    SizedBox(height: 16),
                    Text('Creating book...'),
                  ],
                ),
              )
            : Form(
                key: _formKey,
                child: Column(
                  children: [
                    Card.outlined(
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
                                  icon: const Icon(Icons.photo_album),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: TextFormField(
                                    controller: _titleController,
                                    decoration: InputDecoration(
                                      labelText: 'book.title'.tr(),
                                    ),
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'add_manual_book.title_required'
                                            .tr();
                                      }
                                      return null;
                                    },
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            TextFormField(
                              controller: _authorsController,
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
                              controller: _pagesController,
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
                    ),
                    const SizedBox(height: 16),
                    Card.outlined(
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'add_manual_book.optional_information'.tr(),
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                            const SizedBox(height: 8),
                            TextFormField(
                              controller: _subtitleController,
                              decoration: InputDecoration(
                                labelText: 'book.subtitle'.tr(),
                              ),
                            ),
                            const SizedBox(height: 8),
                            TextFormField(
                              controller: _publishedDateController,
                              decoration: InputDecoration(
                                labelText:
                                    'add_manual_book.published_date'.tr(),
                              ),
                              keyboardType: TextInputType.datetime,
                              inputFormatters: [
                                _DateInputFormatter(),
                              ],
                            ),
                            const SizedBox(height: 8),
                            LanguagePicker(
                              onLanguageChanged: (language) {
                                setState(() => this.language = language);
                              },
                            ),
                            const SizedBox(height: 8),
                            TextFormField(
                              controller: _isbnController,
                              decoration: InputDecoration(
                                labelText: 'book.isbn'.tr(),
                              ),
                            ),
                            const SizedBox(height: 8),
                            TextFormField(
                              controller: _summaryController,
                              decoration: InputDecoration(
                                labelText: 'book.summary'.tr(),
                              ),
                            ),
                          ],
                        ),
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
        language: language,
        rating: 0,
        notes: null,
        summary: _summaryController.text,
      );

      await ref.read(bookRepositoryProvider).addBook(book);

      setState(() => loading = false);
      if (mounted) {
        Navigator.of(context).pop();
      }
    }
  }
}

class _DateInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final text = newValue.text;

    // Remove non-numeric characters
    final digitsOnly = text.replaceAll(RegExp('[^0-9]'), '');

    // Format to yyyy-MM-dd
    final buffer = StringBuffer();
    for (var i = 0; i < digitsOnly.length; i++) {
      if (i == 4 || i == 6) {
        buffer.write('-');
      }
      buffer.write(digitsOnly[i]);
    }
    var formatted = buffer.toString();

    // Trim to ensure it's not longer than yyyy-MM-dd
    if (formatted.length > 10) {
      formatted = formatted.substring(0, 10);
    }

    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }
}
