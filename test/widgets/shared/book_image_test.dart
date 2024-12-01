import 'package:cached_network_image/cached_network_image.dart';
import 'package:dantex/widgets/shared/book_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:patrol_finders/patrol_finders.dart';

void main() {
  group('Given a BookImage widget', () {
    group('When the imageUrl is null', () {
      patrolWidgetTest('Then the placeholder widget is shown', ($) async {
        await $.pumpWidget(
          const MaterialApp(
            home: BookImage(null, size: 48),
          ),
        );

        expect($(#book_image_placeholder), findsOneWidget);
        expect($(CachedNetworkImage), findsNothing);
      });
    });
    group('When the imageUrl is not null', () {
      patrolWidgetTest('Then the image is shown', ($) async {
        await $.pumpWidget(
          const MaterialApp(
            home: BookImage('https://example.com/image', size: 48),
          ),
        );

        expect($(#book_image_placeholder), findsNothing);
        expect($(CachedNetworkImage), findsOneWidget);
      });
    });
  });
}
