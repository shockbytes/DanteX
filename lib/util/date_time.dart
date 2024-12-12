import 'package:easy_localization/easy_localization.dart';

final DateFormat _dfMonth = DateFormat('MMMM yyyy');
final DateFormat _dfMonthShort = DateFormat('MMM yy');

extension DateTimeX on DateTime {
  String formatWithMonthAndYear() {
    return _dfMonth.format(this);
  }

  String formatWithMonthAndYearShort() {
    return _dfMonthShort.format(this);
  }
}
