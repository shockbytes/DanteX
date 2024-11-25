import 'dart:async';
import 'dart:developer';

import 'package:dantex/widgets/search_result_bottom_sheet.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

enum AddBookAction { scan, query, manual }

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
                'add_book.scan'.tr(),
                style: TextStyle(
                  color: Theme.of(context).colorScheme.secondary,
                ),
              ),
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
                'add_book.query'.tr(),
                style: TextStyle(
                  color: Theme.of(context).colorScheme.secondary,
                ),
              ),
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
                'add_book.manual'.tr(),
                style: TextStyle(
                  color: Theme.of(context).colorScheme.secondary,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Future<void> _addBook(AddBookAction action) async {
    switch (action) {
      case AddBookAction.scan:
        log('Sca scan');
      case AddBookAction.query:
        final searchTerm = await showDialog<String>(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('query_search.title'.tr()),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('query_search.info'.tr()),
                const SizedBox(height: 8),
                TextField(
                  decoration: InputDecoration(
                    hintText: 'query_search.hint'.tr(),
                  ),
                  controller: _searchController,
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () =>
                    Navigator.of(context).pop(_searchController.text),
                child: Text('search.search'.tr()),
              ),
            ],
          ),
        );

        _searchController.clear();

        if (!mounted || searchTerm == null) {
          return;
        }

        await showModalBottomSheet<void>(
          showDragHandle: true,
          context: context,
          builder: (context) => AnimatedSize(
            duration: const Duration(milliseconds: 300),
            child: SearchResultBottomSheet(searchTerm: searchTerm),
          ),
        );

      case AddBookAction.manual:
        log('Manual scan');
    }
  }
}
