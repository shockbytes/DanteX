import 'package:easy_localization/easy_localization.dart';

final DateFormat _dfMonth = DateFormat('MMMM yyyy');
final DateFormat _dfMonthShort = DateFormat('MMM yy');
final DateFormat _dfYear = DateFormat('yyyy');
final DateFormat _dfYearMonthDay = DateFormat('yyyy-MM-dd');

extension DateTimeX on DateTime {
  String formatWithMonthAndYear() {
    return _dfMonth.format(this);
  }

  String formatWithMonthAndYearShort() {
    return _dfMonthShort.format(this);
  }

  String formatWithYear() {
    return _dfYear.format(this);
  }

  String formatWithYearMonthDay() {
    return _dfYearMonthDay.format(this);
  }
}
