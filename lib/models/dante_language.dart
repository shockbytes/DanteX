import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'dante_language.freezed.dart';
part 'dante_language.g.dart';

@freezed
class DanteLanguage with _$DanteLanguage {
  const factory DanteLanguage({
    required String isoCode,
    required String name,
  }) = _DanteLanguage;

  factory DanteLanguage.fromJson(Map<String, dynamic> json) =>
      _$DanteLanguageFromJson(json);

  const DanteLanguage._();

  static const other = DanteLanguage(isoCode: 'other', name: 'Other');
  static const english = DanteLanguage(isoCode: 'en', name: 'English');
  static const german = DanteLanguage(isoCode: 'de', name: 'German');
  static const italian = DanteLanguage(isoCode: 'it', name: 'Italian');
  static const french = DanteLanguage(isoCode: 'fr', name: 'French');
  static const spanish = DanteLanguage(isoCode: 'es', name: 'Spanish');
  static const portuguese = DanteLanguage(isoCode: 'pt', name: 'Portuguese');
  static const dutch = DanteLanguage(isoCode: 'nl', name: 'Dutch');
  static const chinese = DanteLanguage(isoCode: 'zh', name: 'Chinese');
  static const russian = DanteLanguage(isoCode: 'ru', name: 'Russian');
  static const swedish = DanteLanguage(isoCode: 'sv', name: 'Swedish');
  static const norwegian = DanteLanguage(isoCode: 'no', name: 'Norwegian');
  static const polish = DanteLanguage(isoCode: 'pl', name: 'Polish');
  static const romanian = DanteLanguage(isoCode: 'ro', name: 'Romanian');
  static const croatian = DanteLanguage(isoCode: 'hr', name: 'Croatian');
  static const hungarian = DanteLanguage(isoCode: 'hu', name: 'Hungarian');
  static const indonesian = DanteLanguage(isoCode: 'id', name: 'Indonesian');
  static const thai = DanteLanguage(isoCode: 'th', name: 'Thai');

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
  if (isoCode == null) {
    return DanteLanguage.other;
  }

  switch (isoCode) {
    case 'en':
      return DanteLanguage.english;
    case 'de':
      return DanteLanguage.german;
    case 'it':
      return DanteLanguage.italian;
    case 'fr':
      return DanteLanguage.french;
    case 'es':
      return DanteLanguage.spanish;
    case 'pt':
      return DanteLanguage.portuguese;
    case 'nl':
      return DanteLanguage.dutch;
    case 'zh':
      return DanteLanguage.chinese;
    case 'ru':
      return DanteLanguage.russian;
    case 'sv':
      return DanteLanguage.swedish;
    case 'no':
      return DanteLanguage.norwegian;
    case 'pl':
      return DanteLanguage.polish;
    case 'ro':
      return DanteLanguage.romanian;
    case 'hr':
      return DanteLanguage.croatian;
    case 'hu':
      return DanteLanguage.hungarian;
    case 'id':
      return DanteLanguage.indonesian;
    case 'th':
      return DanteLanguage.thai;
    default:
      return DanteLanguage.other;
  }
}
