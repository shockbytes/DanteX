enum Language {
  na(
    countryCode: null,
    translationKey: 'countries.not-available',
  ),
  english(
    countryCode: 'GB',
    translationKey: 'countries.gb',
    alternativeCountryCodes: [
      'en',
    ],
  ),
  german(
    countryCode: 'DE',
    translationKey: 'countries.de',
  ),
  italian(
    countryCode: 'IT',
    translationKey: 'countries.it',
  ),
  french(
    countryCode: 'FR',
    translationKey: 'countries.fr',
  ),
  spanish(
    countryCode: 'ES',
    translationKey: 'countries.es',
  ),
  portuguese(
    countryCode: 'PT',
    translationKey: 'countries.pt',
  ),
  dutch(
    countryCode: 'NL',
    translationKey: 'countries.nl',
  ),
  chinese(
    countryCode: 'CH',
    translationKey: 'countries.ch',
  ),
  ukrainian(
    countryCode: 'UA',
    translationKey: 'countries.ua',
  ),
  swedish(
    countryCode: 'SE',
    translationKey: 'countries.se',
  ),
  danish(
    countryCode: 'DK',
    translationKey: 'countries.dk',
  ),
  norwegian(
    countryCode: 'NO',
    translationKey: 'countries.no',
  ),
  polish(
    countryCode: 'PL',
    translationKey: 'countries.pl',
  ),
  rumanian(
    countryCode: 'RO',
    translationKey: 'countries.ro',
  ),
  bulgarian(
    countryCode: 'BG',
    translationKey: 'countries.bg',
  ),
  croatian(
    countryCode: 'HR',
    translationKey: 'countries.hr',
  ),
  hungarian(
    countryCode: 'HU',
    translationKey: 'countries.hu',
  ),
  turkish(
    countryCode: 'TR',
    translationKey: 'countries.tr',
  ),
  russian(
    countryCode: 'RU',
    translationKey: 'countries.ru',
  ),
  indonesian(
    countryCode: 'ID',
    translationKey: 'countries.id',
  ),
  thai(
    countryCode: 'TH',
    translationKey: 'countries.th',
  );

  final String? countryCode;
  final String translationKey;
  final List<String> alternativeCountryCodes;

  List<String?> get countryCodes {
    return [
      countryCode?.toLowerCase(),
      ...alternativeCountryCodes.map((a) => a.toLowerCase()),
    ];
  }

  const Language({
    required this.countryCode,
    required this.translationKey,
    this.alternativeCountryCodes = const [],
  });

  static Language fromCountryCode(String countryCode) {
    return Language.values.firstWhere(
      (element) => element.countryCodes.contains(countryCode.toLowerCase()),
      orElse: () => Language.na,
    );
  }
}
