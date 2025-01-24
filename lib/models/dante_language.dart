import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'dante_language.g.dart';

@JsonEnum(alwaysCreate: true)
enum DanteLanguage {
  @JsonValue('other')
  other(isoCode: 'other', name: 'Other'),
  @JsonValue('en')
  english(isoCode: 'en', name: 'English'),
  @JsonValue('de')
  german(isoCode: 'de', name: 'German'),
  @JsonValue('it')
  italian(isoCode: 'it', name: 'Italian'),
  @JsonValue('fr')
  french(isoCode: 'fr', name: 'French'),
  @JsonValue('es')
  spanish(isoCode: 'es', name: 'Spanish'),
  @JsonValue('pt')
  portuguese(isoCode: 'pt', name: 'Portuguese'),
  @JsonValue('nl')
  dutch(isoCode: 'nl', name: 'Dutch'),
  @JsonValue('zh')
  chinese(isoCode: 'zh', name: 'Chinese'),
  @JsonValue('ru')
  russian(isoCode: 'ru', name: 'Russian'),
  @JsonValue('sv')
  swedish(isoCode: 'sv', name: 'Swedish'),
  @JsonValue('no')
  norwegian(isoCode: 'no', name: 'Norwegian'),
  @JsonValue('pl')
  polish(isoCode: 'pl', name: 'Polish'),
  @JsonValue('ro')
  romanian(isoCode: 'ro', name: 'Romanian'),
  @JsonValue('hr')
  croatian(isoCode: 'hr', name: 'Croatian'),
  @JsonValue('hu')
  hungarian(isoCode: 'hu', name: 'Hungarian'),
  @JsonValue('id')
  indonesian(isoCode: 'id', name: 'Indonesian'),
  @JsonValue('th')
  thai(isoCode: 'th', name: 'Thai');

  const DanteLanguage({
    required this.isoCode,
    required this.name,
  });

  final String isoCode;
  final String name;

  Color get color {
    if (isoCode == 'en') {
      return Colors.blue;
    } else if (isoCode == 'de') {
      return Colors.black;
    } else if (isoCode == 'it') {
      return Colors.green;
    } else if (isoCode == 'fr') {
      return Colors.blue;
    } else if (isoCode == 'es') {
      return Colors.red;
    } else if (isoCode == 'pt') {
      return Colors.green;
    } else if (isoCode == 'nl') {
      return Colors.red;
    } else if (isoCode == 'zh') {
      return Colors.red;
    } else if (isoCode == 'ru') {
      return Colors.red;
    } else if (isoCode == 'sv') {
      return Colors.blue;
    } else if (isoCode == 'no') {
      return Colors.red;
    } else if (isoCode == 'pl') {
      return Colors.red;
    } else if (isoCode == 'ro') {
      return Colors.blue;
    } else if (isoCode == 'hr') {
      return Colors.red;
    } else if (isoCode == 'hu') {
      return Colors.red;
    } else if (isoCode == 'id') {
      return Colors.red;
    } else if (isoCode == 'th') {
      return Colors.red;
    } else {
      return Colors.grey;
    }
  }

  String get iconPath {
    if (isoCode == 'en') {
      return 'icons/flags/svg/us.svg';
    }
    return 'icons/flags/svg/$isoCode.svg';
  }
}

DanteLanguage languageFromIsoCode(String? isoCode) {
  return DanteLanguage.values.firstWhere(
    (lang) => lang.isoCode == isoCode,
    orElse: () => DanteLanguage.other,
  );
}
