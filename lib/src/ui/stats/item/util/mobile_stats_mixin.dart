import 'package:flutter/cupertino.dart';

mixin MobileStatsMixin {
  Widget resolveTopLevelWidget({
    required Widget child,
    required bool isMobile,
    double mobileHeight = 200,
  }) {
    return isMobile
        ? SizedBox(
            height: mobileHeight,
            child: child,
          )
        : Expanded(
            child: child,
          );
  }
}
