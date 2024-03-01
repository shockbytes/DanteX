import 'package:country_flags/country_flags.dart';
import 'package:dantex/src/data/core/language.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class LanguagePickerWidget extends StatelessWidget {
  final LanguageController controller;
  final Function(Language language)? onLanguageSelected;

  const LanguagePickerWidget({
    required this.controller,
    this.onLanguageSelected,
    super.key,
  });

  final List<Language> _supportedLanguages = Language.values;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          'language-picker.title'.tr(),
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            color: Theme.of(context).colorScheme.onSurface,
          ),
        ),
        ValueListenableBuilder<Language>(
          valueListenable: controller,
          builder: (context, language, _) {
            return Container(
              constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width,
              ),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.all(
                  Radius.circular(4),
                ),
                border: Border.all(
                  width: 0.7,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<Language>(
                  isExpanded: true,
                  hint: Text(
                    'language-picker.empty'.tr(),
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                  ),
                  icon: Icon(
                    Icons.arrow_drop_down,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                  iconSize: 30,
                  value: language,
                  items: _supportedLanguages.map(
                    (Language language) {
                      return DropdownMenuItem<Language>(
                        value: language,
                        child: Row(
                          children: [
                            const SizedBox(width: 12),
                            _buildCountryFlag(context, language),
                            const SizedBox(width: 16),
                            Text(
                              language.translationKey.tr(),
                              style: TextStyle(
                                color: Theme.of(context).colorScheme.onSurface,
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ).toList(),
                  onChanged: (Language? language) {
                    if (language != null) {
                      controller.value = language;
                      onLanguageSelected?.call(language);
                    }
                  },
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildCountryFlag(BuildContext context, Language language) {
    if (language.countryCode == null) {
      return SizedBox(
        width: 48,
        child: Center(
          child: Text(
            'NA',
            style: TextStyle(
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
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

class LanguageController extends ValueNotifier<Language> {
  LanguageController(super.value);
}
