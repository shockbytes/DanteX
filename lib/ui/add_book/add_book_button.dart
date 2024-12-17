import 'dart:async';

import 'package:dantex/providers/book.dart';
import 'package:dantex/ui/add_book/add_custom_book_screen.dart';
import 'package:dantex/ui/add_book/search_result_widget.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

enum AddBookAction { scan, query, manual }

const _invalidIsbn = '-1';

class AddBookButton extends ConsumerStatefulWidget {
  const AddBookButton({super.key});

  @override
  ConsumerState<AddBookButton> createState() => _AddBookButtonState();
}

class _AddBookButtonState extends ConsumerState<AddBookButton> {
  final _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<AddBookAction>(
      icon: Icon(
        Icons.add,
        size: 32,
        color: Theme.of(context).colorScheme.primary,
      ),
      onSelected: (action) async => _addBook(action),
      itemBuilder: (context) => [
        PopupMenuItem(
          value: AddBookAction.scan,
          child: Row(
            children: [
              Icon(
                Icons.camera_alt_outlined,
                color: Theme.of(context).colorScheme.secondary,
              ),
              const SizedBox(width: 8),
              Text(
                'add_book.scan',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.secondary,
                ),
              ).tr(),
            ],
          ),
        ),
        PopupMenuItem(
          value: AddBookAction.query,
          child: Row(
            children: [
              Icon(
                Icons.search,
                color: Theme.of(context).colorScheme.secondary,
              ),
              const SizedBox(width: 8),
              Text(
                'add_book.query',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.secondary,
                ),
              ).tr(),
            ],
          ),
        ),
        PopupMenuItem(
          value: AddBookAction.manual,
          child: Row(
            children: [
              Icon(
                Icons.edit_outlined,
                color: Theme.of(context).colorScheme.secondary,
              ),
              const SizedBox(width: 8),
              Text(
                'add_book.manual',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.secondary,
                ),
              ).tr(),
            ],
          ),
        ),
      ],
    );
  }

  Future<void> _addBook(AddBookAction action) async {
    switch (action) {
      case AddBookAction.scan:
        final searchIsbn = await ref.watch(scanIsbnProvider.future);
        if (searchIsbn == _invalidIsbn || !mounted) {
          return;
        }

        await showSearchResultBottomSheet(context, searchIsbn);

      case AddBookAction.query:
        final searchTerm = await showDialog<String>(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('add_book.title_search.title').tr(),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text('add_book.title_search.info').tr(),
                const SizedBox(height: 8),
                TextField(
                  decoration: InputDecoration(
                    hintText: 'add_book.title_search.hint'.tr(),
                  ),
                  controller: _searchController,
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(
                  _searchController.text,
                ),
                child: const Text('add_book.search').tr(),
              ),
            ],
          ),
        );

        _searchController.clear();

        if (!mounted || searchTerm == null) {
          return;
        }

        await showSearchResultBottomSheet(context, searchTerm);

      case AddBookAction.manual:
        await context.push(AddCustomBookScreen.routeLocation);
    }
  }
}
