import 'package:dantex/ui/shared/language_picker.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class OptionalBookFields extends StatelessWidget {
  const OptionalBookFields({
    required this.subtitleController,
    required this.publishedDateController,
    required this.isbnController,
    required this.summaryController,
    required this.onLanguageChanged,
    this.initialLanguageIsoCode,
    super.key,
  });

  final TextEditingController subtitleController;
  final TextEditingController publishedDateController;
  final TextEditingController isbnController;
  final TextEditingController summaryController;
  final void Function(String languageIsoCode) onLanguageChanged;
  final String? initialLanguageIsoCode;

  @override
  Widget build(BuildContext context) {
    return Card.outlined(
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
              controller: subtitleController,
              decoration: InputDecoration(
                labelText: 'book.subtitle'.tr(),
              ),
            ),
            const SizedBox(height: 8),
            TextFormField(
              controller: publishedDateController,
              decoration: InputDecoration(
                labelText: 'add_manual_book.published_date'.tr(),
              ),
              keyboardType: TextInputType.datetime,
              inputFormatters: [
                _DateInputFormatter(),
              ],
            ),
            const SizedBox(height: 8),
            LanguagePicker(
              onLanguageChanged: onLanguageChanged,
              initialLanguageIsoCode: initialLanguageIsoCode,
            ),
            const SizedBox(height: 8),
            TextFormField(
              controller: isbnController,
              decoration: InputDecoration(
                labelText: 'book.isbn'.tr(),
              ),
            ),
            const SizedBox(height: 8),
            TextFormField(
              controller: summaryController,
              maxLines: 5,
              minLines: 5,
              decoration: InputDecoration(
                labelText: 'book.summary'.tr(),
              ),
            ),
          ],
        ),
      ),
    );
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
