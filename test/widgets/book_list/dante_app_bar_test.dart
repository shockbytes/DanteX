import 'package:dantex/widgets/book_list/dante_app_bar.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:patrol_finders/patrol_finders.dart';

void main() {
  EasyLocalization.logger.enableBuildModes = [];

  group('Given a DanteAppBar', () {
    group('When the user avatar is tapped', () {
      patrolWidgetTest('Then the DanteBottomSheet is shown', ($) async {
        await $.pumpWidget(
          const ProviderScope(
            child: MaterialApp(
              home: DanteAppBar(),
            ),
          ),
        );
        await $(#user_avatar_button).tap();
        expect($(#dante_bottom_sheet), findsOneWidget);
      });
    });
  });
}
