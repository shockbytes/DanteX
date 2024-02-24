import 'package:dantex/src/data/book/entity/book_state.dart';
import 'package:dantex/src/data/core/language.dart';
import 'package:dantex/src/ui/add/book_cover_picker_widget.dart';
import 'package:dantex/src/ui/add/date_picker_widget.dart';
import 'package:dantex/src/ui/add/language_picker_widget.dart';
import 'package:dantex/src/ui/core/dante_components.dart';
import 'package:dantex/src/ui/core/themed_app_bar.dart';
import 'package:dantex/src/util/layout_utils.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

/// TODO
/// 3. Save manual book
/// 4. Upload image
/// 5. Entry points for edit book:
///   - Overflow
///   - Detail Page
/// 6. Edit existing book
/// 7. Test
///   - Web
///   - App
class ManualAddEditBookPage extends StatefulWidget {
  const ManualAddEditBookPage({super.key});

  @override
  State<ManualAddEditBookPage> createState() => _ManualAddEditBookPageState();
}

class _ManualAddEditBookPageState extends State<ManualAddEditBookPage> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _authorController = TextEditingController();
  final TextEditingController _pageController = TextEditingController();
  final TextEditingController _subtitleController = TextEditingController();
  final TextEditingController _isbnController = TextEditingController();
  final TextEditingController _summaryController = TextEditingController();

  String? _title = '';

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ThemedAppBar(
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
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildStateButton(BookState.readLater),
              _buildStateButton(BookState.reading),
              _buildStateButton(BookState.read),
            ],
          ),
        ),
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

  // TODO
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
              BookCoverPickerWidget(),
              const Spacer(),
            ],
            Row(
              children: [
                if (!isDesktop) ...[
                  BookCoverPickerWidget(),
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
              onDateSelected: (DateTime date) {
                print(date);
              },
            ),
            const SizedBox(height: 16),
            LanguagePickerWidget(
              onLanguageSelected: (Language language) {
                print(language);
              },
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

  Widget _buildStateButton(BookState state) {
    return SizedBox(
      width: 120,
      child: OutlinedButton(
        onPressed: () {},
        // icon: state.icon,
        child: Text(state.name),
      ),
    );
  }
}
