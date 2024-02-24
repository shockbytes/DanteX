import 'package:dantex/src/data/book/entity/book_state.dart';
import 'package:dantex/src/ui/core/dante_components.dart';
import 'package:dantex/src/ui/core/themed_app_bar.dart';
import 'package:dantex/src/util/layout_utils.dart';
import 'package:flutter/material.dart';

/// TODO
/// 2. Manual Add book
///   -[ ] Web
///   -[ ] Translations
///   -[ ] App
///   -[ ] Dark Mode
/// 3. Upload image
/// 4. Entry points for edit book:
///   - Overflow
///   - Detail Page
/// 4. Edit existing book
/// 5. Test
///   - Web
///   - App
class ManualAddEditBookPage extends StatelessWidget {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _authorController = TextEditingController();
  final TextEditingController _pageController = TextEditingController();
  final TextEditingController _subtitleController = TextEditingController();
  final TextEditingController _isbnController = TextEditingController();
  final TextEditingController _summaryController = TextEditingController();

  ManualAddEditBookPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ThemedAppBar(
          // TODO
          title: Text('Book Title goes here'),
        ),
        Expanded(
          child: LayoutBuilder(
            builder: (context, constraints) {
              return switch (getDeviceFormFactor(constraints)) {
                DeviceFormFactor.desktop => _buildDesktopLayout(context),
                _ => _buildMobileLayout(context),
              };
            },
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
            child: _buildOptionalInformationCard(isDesktop: true),
          ),
        ],
      ),
    );
  }

  // TODO
  Widget _buildMobileLayout(BuildContext context) {
    return ListView(
      shrinkWrap: true,
      children: [
        _buildRequiredInformationCard(isDesktop: false),
        _buildOptionalInformationCard(isDesktop: false),
      ],
    );
  }

  Widget _buildRequiredInformationCard({ required bool isDesktop }) {
    return Card(
      child: Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            if (isDesktop)...[
              const Spacer(),
              Text('Image'),
              const Spacer(),
            ],
            Row(
              children: [
                if (!isDesktop)...[
                  Text('Image'),
                  const SizedBox(width: 16),
                ],
                Expanded(
                  child: DanteTextField(
                    controller: _titleController,
                    hint: 'Title',
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            DanteTextField(
              controller: _authorController,
              hint: 'Authors',
            ),
            const SizedBox(height: 16),
            DanteTextField(
              controller: _pageController,
              hint: 'Page Count',
            ),
            if (isDesktop)
              const Spacer(),
          ],
        ),
      ),
    );
  }

  Widget _buildOptionalInformationCard({required bool isDesktop}) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text('Optional information'),
            const SizedBox(height: 32),
            DanteTextField(
              controller: _subtitleController,
              hint: 'Subtitle',
            ),
            const SizedBox(height: 16),
            Text('DatePicker PublishDate'),
            const SizedBox(height: 16),
            Text('Language'),
            const SizedBox(height: 16),
            DanteTextField(
              controller: _isbnController,
              hint: 'ISBN',
            ),
            const SizedBox(height: 16),
            DanteTextField(
              controller: _summaryController,
              hint: 'Summary',
              maxLines: 5,
            ),
          ],
        )
      ),
    );
  }

  Widget _buildStateButton(BookState state) {
    return SizedBox(
      width: 140,
      child: OutlinedButton(
        onPressed: () {},
        // icon: state.icon,
        child: Text(state.name),
      ),
    );
  }
}
