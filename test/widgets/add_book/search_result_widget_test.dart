import 'package:dantex/providers/client.dart';
import 'package:dantex/widgets/add_book/search_result_widget.dart';
import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http_mock_adapter/http_mock_adapter.dart';
import 'package:patrol_finders/patrol_finders.dart';

import '../../test_utilities.dart';

void main() {
  // Disable EasyLocalization logs for tests
  EasyLocalization.logger.enableBuildModes = [];
  final mockGoogleBooksClient = Dio(BaseOptions());
  final dioAdapter = DioAdapter(dio: mockGoogleBooksClient);
  const path = '/volumes';

  group('Given a SearchResultWidget', () {
    group('When the search result is empty', () {
      patrolWidgetTest('Then the NoResultsWidget is displayed', ($) async {
        dioAdapter.onGet(
          path,
          (server) => server.reply(
            200,
            null,
          ),
        );
        await $.pumpWidget(
          ProviderScope(
            overrides: [
              googleBooksClientProvider
                  .overrideWithValue(mockGoogleBooksClient),
            ],
            child: const MaterialApp(
              home: SearchResultWidget(searchTerm: 'test'),
            ),
          ),
        );

        expect($(#search_loading), findsOneWidget);
        await $.pumpAndSettle();
        expect($(#no_search_results), findsOneWidget);
      });
    });
    group('When the search result is not empty', () {
      patrolWidgetTest('Then the AddBookWidget is displayed', ($) async {
        dioAdapter.onGet(
          path,
          (server) => server.reply(
            200,
            getMockGoogleBookResponse().toJson(),
          ),
        );
        await $.pumpWidget(
          ProviderScope(
            overrides: [
              googleBooksClientProvider
                  .overrideWithValue(mockGoogleBooksClient),
            ],
            child: const MaterialApp(
              home: SearchResultWidget(searchTerm: 'test'),
            ),
          ),
        );

        expect($(#search_loading), findsOneWidget);
        await $.pumpAndTrySettle();
        expect($(#add_book_widget), findsOneWidget);
      });
    });
  });
}
