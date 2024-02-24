import 'package:country_flags/country_flags.dart';
import 'package:dantex/src/data/core/language.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class LanguagePickerWidget extends StatefulWidget {
  final Language preSelectedLanguage;
  final Function(Language language) onLanguageSelected;

  const LanguagePickerWidget({
    required this.onLanguageSelected,
    this.preSelectedLanguage = Language.na,
    super.key,
  });

  @override
  State<LanguagePickerWidget> createState() => _LanguagePickerWidgetState();
}

class _LanguagePickerWidgetState extends State<LanguagePickerWidget> {
  final List<Language> _supportedLanguages = Language.values;
  Language _selectedLanguage = Language.na;

  @override
  void initState() {
    _selectedLanguage = widget.preSelectedLanguage;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          'language-picker.title'.tr(),
          style: Theme.of(context).textTheme.titleMedium,
        ),
        Container(
          constraints: BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width,
          ),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(
              Radius.circular(4),
            ),
            border: Border.all(width: 0.7),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<Language>(
              isExpanded: true,
              hint: Text(
                'language-picker.empty'.tr(),
                textAlign: TextAlign.center,
              ),
              icon: Icon(
                Icons.arrow_drop_down,
                color: Theme.of(context).colorScheme.onSurface,
              ),
              iconSize: 30,
              value: _selectedLanguage,
              items: _supportedLanguages.map(
                (Language language) {
                  return DropdownMenuItem<Language>(
                    value: language,
                    child: Row(
                      children: [
                        const SizedBox(width: 12),
                        _buildCountryFlag(language),
                        const SizedBox(width: 16),
                        Text(
                          language.translationKey.tr(),
                        ),
                      ],
                    ),
                  );
                },
              ).toList(),
              onChanged: (Language? language) {
                if (language != null) {
                  widget.onLanguageSelected(language);

                  setState(() {
                    _selectedLanguage = language;
                  });
                }
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCountryFlag(Language language) {
    if (language.countryCode == null) {
      return const SizedBox(
        width: 48,
        child: Center(
          child: Text('NA'),
        ),
      );
    }

    return CountryFlag.fromCountryCode(
      language.countryCode!,
      height: 48,
      width: 48,
      borderRadius: 12,
    );
  }
}
