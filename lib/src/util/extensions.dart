import 'dart:ui';

import 'package:easy_localization/easy_localization.dart';

extension HexColor on String {
  /// String is in the format "aabbcc" or "ffaabbcc" with an optional leading "#".
  Color toColor() {
    final buffer = StringBuffer();
    if (length == 6 || length == 7) buffer.write('ff');
    buffer.write(replaceFirst('#', ''));
    return Color(int.parse(buffer.toString(), radix: 16));
  }
}

final DateFormat _dfMonth = DateFormat('MMMM yyyy');

extension DateTimeX on DateTime {
  String formatWithMonthAndYear() {
    return _dfMonth.format(this);
  }
}
