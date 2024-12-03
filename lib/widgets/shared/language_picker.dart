import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:language_picker/language_picker_dropdown.dart';
import 'package:language_picker/languages.dart';

class LanguagePicker extends StatelessWidget {
  const LanguagePicker({
    required this.onLanguageChanged,
    this.initialLanguageIsoCode,
    super.key,
  });

  final void Function(String languageIsoCode) onLanguageChanged;
  final String? initialLanguageIsoCode;

  @override
  Widget build(BuildContext context) {
    return LanguagePickerDropdown(
      onValuePicked: (language) => onLanguageChanged(language.isoCode),
      initialValue: initialLanguageIsoCode?.toLanguage(),
      itemBuilder: (language) {
        var isoCode = language.isoCode;
        if (language == Languages.english) {
          isoCode = 'us';
        } else if (language == Languages.chinese) {
          isoCode = 'cn';
        }

        Widget icon;
        if (language == _otherLanguage) {
          icon = const Icon(Icons.language, size: 32);
        } else {
          icon = ClipOval(
            child: SizedBox(
              width: 32,
              height: 32,
              child: SvgPicture.asset(
                'icons/flags/svg/$isoCode.svg',
                package: 'country_icons',
                fit: BoxFit.cover,
              ),
            ),
          );
        }

        return Row(
          children: [
            icon,
            const SizedBox(width: 8),
            Expanded(child: Text(language.name.toUpperCase())),
          ],
        );
      },
      languages: _languageOptions,
    );
  }
}

final _languageOptions = [
  _otherLanguage,
  Languages.english,
  Languages.german,
  Languages.italian,
  Languages.french,
  Languages.spanish,
  Languages.portuguese,
  Languages.dutch,
  Languages.chinese,
  Languages.russian,
  Languages.swedish,
  Languages.norwegian,
  Languages.polish,
  Languages.romanian,
  Languages.croatian,
  Languages.hungarian,
  Languages.indonesian,
  Languages.thai,
];

extension on String {
  Language toLanguage() {
    return _languageOptions.firstWhere(
      (language) => language.isoCode == this,
      orElse: () => _otherLanguage,
    );
  }
}

const _otherLanguage = Language('', 'Other', '');
