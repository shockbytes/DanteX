import 'dart:async';

import 'package:dantex/src/data/book/entity/book.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:share_plus/share_plus.dart';

class ShareHelper {
  ShareHelper._();

  static void shareBook(BuildContext context, Book book) {
    unawaited(
      Share.share(
        _createBookShareText(book),
        sharePositionOrigin: _resolvePositionOrigin(context),
      ),
    );
  }

  static String _createBookShareText(Book book) {
    return 'share-book'.tr(
      namedArgs: {
        'author': book.author,
        'title': book.title,
      },
    );
  }

  // See https://pub.dev/packages/share_plus#known-issues
  static Rect? _resolvePositionOrigin(BuildContext context) {
    final RenderBox? box = context.findRenderObject() as RenderBox?;
    if (box == null) {
      return null;
    }
    return box.localToGlobal(Offset.zero) & box.size;
  }
}
