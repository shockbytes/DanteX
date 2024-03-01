import 'dart:async';

import 'package:dantex/src/data/book/entity/book.dart';
import 'package:dantex/src/data/book/entity/book_state.dart';
import 'package:dantex/src/data/core/language.dart';
import 'package:dantex/src/providers/repository.dart';
import 'package:dantex/src/ui/add/widgets/book_cover_picker_widget.dart';
import 'package:dantex/src/ui/add/widgets/date_picker_widget.dart';
import 'package:dantex/src/ui/add/widgets/language_picker_widget.dart';
import 'package:dantex/src/ui/core/dante_components.dart';
import 'package:dantex/src/ui/core/themed_app_bar.dart';
import 'package:dantex/src/util/extensions.dart';
import 'package:dantex/src/util/layout_utils.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

/// TODO
/// -[ ] Upload image
/// -[ ] Test
///   -[ ] Web
///   -[ ] App
class ManualAddEditBookPage extends ConsumerStatefulWidget {
  final String? bookId;

  const ManualAddEditBookPage({
    super.key,
    this.bookId,
  });

  @override
  ConsumerState<ManualAddEditBookPage> createState() => _ManualAddEditBookPageState();
}

class _ManualAddEditBookPageState extends ConsumerState<ManualAddEditBookPage> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _authorController = TextEditingController();
  final TextEditingController _pageController = TextEditingController();
  final TextEditingController _subtitleController = TextEditingController();
  final TextEditingController _isbnController = TextEditingController();
  final TextEditingController _summaryController = TextEditingController();

  final LanguageController _languageController = LanguageController(Language.na);
  final BookCoverController _bookCoverController = BookCoverController(null);
  final DateController _publishDateController = DateController(null);

  String? _title = '';
  Book? _bookEditMode;

  bool get _isInEditMode => widget.bookId != null;

  @override
  void initState() {
    super.initState();

    if (widget.bookId != null) {
      _loadBookById();
    }
  }

  void _loadBookById() {
    unawaited(
      ref.read(bookRepositoryProvider).getBook(widget.bookId!).first.then(_initializeWithBook),
    );
  }

  void _initializeWithBook(Book book) {
    _bookEditMode = book;

    _bookCoverController.value = book.thumbnailAddress;
    _publishDateController.value = book.publishedDate.parseWithDefaultDateFormat();
    _languageController.value = Language.fromCountryCode(book.language);

    _titleController.text = book.title;
    _authorController.text = book.author;
    _pageController.text = book.pageCount.toString();
    _subtitleController.text = book.subTitle;
    _isbnController.text = book.isbn;
    _summaryController.text = book.summary ?? '';

    setState(() {
      _title = book.title;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ThemedAppBar.withBackNavigation(
          context: context,
          onBack: () {
            // TODO Handle back navigation
            context.pop();
          },
          title: Text(_title ?? ''),
        ),
        Expanded(
          child: Container(
            color: Theme.of(context).colorScheme.surface,
            child: LayoutBuilder(
              builder: (context, constraints) {
                return switch (getDeviceFormFactor(constraints)) {
                  DeviceFormFactor.desktop => _buildDesktopLayout(context),
                  _ => _buildMobileLayout(context),
                };
              },
            ),
          ),
        ),
        Container(
          color: Theme.of(context).colorScheme.tertiaryContainer,
          height: 100,
          child: _buildActionButtons(),
        ),
      ],
    );
  }

  Widget _buildActionButtons() {
    if (_isInEditMode) {
      return _buildEditBookActionButtons();
    } else {
      return _buildNewBookActionButtons();
    }
  }

  Widget _buildEditBookActionButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        TextButton.icon(
          onPressed: () {
            context.pop();
          },
          icon: Icon(
            Icons.close,
            color: Theme.of(context).colorScheme.error,
          ),
          label: Text(
            'dismiss'.tr(),
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: Theme.of(context).colorScheme.error,
                ),
          ),
        ),
        TextButton.icon(
          onPressed: _saveExistingBook,
          icon: Icon(
            Icons.check_circle_outline_outlined,
            color: Theme.of(context).colorScheme.onTertiaryContainer,
          ),
          label: Text(
            'save'.tr(),
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: Theme.of(context).colorScheme.onTertiaryContainer,
                ),
          ),
        ),
      ],
    );
  }

  Widget _buildNewBookActionButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildBookStateButton(BookState.readLater),
        _buildBookStateButton(BookState.reading),
        _buildBookStateButton(BookState.read),
      ],
    );
  }

  Widget _buildDesktopLayout(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(64),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Expanded(
            child: _buildRequiredInformationCard(isDesktop: true),
          ),
          const SizedBox(width: 64),
          Expanded(
            child: _buildOptionalInformationCard(
              context,
              isDesktop: true,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMobileLayout(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: ListView(
        shrinkWrap: true,
        children: [
          _buildRequiredInformationCard(isDesktop: false),
          const SizedBox(height: 16),
          _buildOptionalInformationCard(
            context,
            isDesktop: false,
          ),
        ],
      ),
    );
  }

  Widget _buildRequiredInformationCard({required bool isDesktop}) {
    return Card(
      child: Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            if (isDesktop) ...[
              const Spacer(),
              BookCoverPickerWidget(
                controller: _bookCoverController,
                size: 200,
              ),
              const Spacer(),
            ],
            Row(
              children: [
                if (!isDesktop) ...[
                  BookCoverPickerWidget(
                    controller: _bookCoverController,
                    size: 64,
                  ),
                  const SizedBox(width: 16),
                ],
                Expanded(
                  child: DanteTextField(
                    controller: _titleController,
                    hint: 'add-manual.title'.tr(),
                    onChanged: (String? changedTitle) {
                      setState(() {
                        _title = changedTitle;
                      });
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            DanteTextField(
              controller: _authorController,
              hint: 'add-manual.authors'.tr(),
            ),
            const SizedBox(height: 16),
            DanteTextField(
              controller: _pageController,
              hint: 'add-manual.page-count'.tr(),
            ),
            if (isDesktop) const Spacer(),
          ],
        ),
      ),
    );
  }

  Widget _buildOptionalInformationCard(BuildContext context, {required bool isDesktop}) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'add-manual.optional-info'.tr(),
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
            ),
            const SizedBox(height: 32),
            DanteTextField(
              controller: _subtitleController,
              hint: 'add-manual.subtitle'.tr(),
            ),
            const SizedBox(height: 16),
            DatePickerWidget(
              controller: _publishDateController,
            ),
            const SizedBox(height: 16),
            LanguagePickerWidget(
              controller: _languageController,
            ),
            const SizedBox(height: 16),
            DanteTextField(
              controller: _isbnController,
              hint: 'add-manual.isbn'.tr(),
            ),
            const SizedBox(height: 16),
            DanteTextField(
              controller: _summaryController,
              hint: 'add-manual.summary'.tr(),
              maxLines: 5,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBookStateButton(BookState state) {
    return SizedBox(
      width: 120,
      child: OutlinedButton(
        onPressed: () async => _saveNewBook(state),
        child: Text(_getTitleForBookState(state)),
      ),
    );
  }

  Future<void> _saveExistingBook() async {
    if (!_hasBookRequiredInformation()) {
      _showError(errorKey: 'add-manual.error.missing-information');
    }

    //  Save new book and navigate back
    try {
      await ref
          .read(bookRepositoryProvider)
          .update(
        _bookEditMode!.copyWith(
          title: _titleController.text,
          author: _authorController.text,
          pageCount: int.tryParse(_pageController.text) ?? 0,
          subTitle: _subtitleController.text,
          publishedDate: _publishDateController.value?.formatDefault() ?? _bookEditMode!.publishedDate,
          isbn: _isbnController.text,
          thumbnailAddress: _bookCoverController.value,
          language: _languageController.value.countryCode ?? _bookEditMode!.language,
          summary: _summaryController.text,
        ),
      )
          .then(
            (value) => context.pop(),
      );
    } catch (e) {
      _showError(errorKey: 'add-manual.error.update');
    }
  }

  Future<void> _saveNewBook(BookState bookState) async {
    if (!_hasBookRequiredInformation()) {
      _showError(errorKey: 'add-manual.error.missing-information');
    }

    //  Save new book and navigate back
    try {
      await ref
          .read(bookRepositoryProvider)
          .create(
            Book(
              id: '',
              title: _titleController.text,
              subTitle: _subtitleController.text,
              author: _authorController.text,
              state: bookState,
              pageCount: int.tryParse(_pageController.text) ?? 0,
              currentPage: 0,
              publishedDate: _publishDateController.value?.formatDefault() ?? '',
              position: 0,
              isbn: _isbnController.text,
              thumbnailAddress: _bookCoverController.value,
              startDate: (bookState == BookState.reading) ? DateTime.now() : null,
              endDate: (bookState == BookState.read) ? DateTime.now() : null,
              forLaterDate: (bookState == BookState.readLater) ? DateTime.now() : null,
              language: _languageController.value.countryCode ?? 'na',
              rating: 0,
              notes: '',
              summary: _summaryController.text,
            ),
          )
          .then(
            (value) => context.pop(),
          );
    } catch (e) {
      print(e);
      _showError(errorKey: 'add-manual.error.create');
    }
  }

  bool _hasBookRequiredInformation() {
    return _hasValue(_titleController, (v) => v.text.isNotEmpty) &&
        _hasValue(_authorController, (v) => v.text.isNotEmpty) &&
        _hasValue(_pageController, (v) => int.tryParse(v.text) != null);
  }

  bool _hasValue<T>(ValueNotifier<T?> vn, bool Function(T value) probe) {
    return vn.value != null && probe(vn.value as T);
  }

  void _showError({required String errorKey}) {
    // TODO Show error information
    print('Missing data: ${errorKey.tr()}');
  }

  String _getTitleForBookState(BookState state) {
    return switch (state) {
      BookState.readLater => 'tabs.for_later'.tr(),
      BookState.reading => 'tabs.reading'.tr(),
      BookState.read => 'tabs.read'.tr(),
      BookState.wishlist => 'tabs.wishlist'.tr(),
    };
  }
}
