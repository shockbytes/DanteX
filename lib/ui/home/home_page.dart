import 'package:dantex/data/book/book_state.dart';
import 'package:dantex/providers/book.dart';
import 'package:dantex/providers/logger.dart';
import 'package:dantex/ui/home/dante_app_bar.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  static String get routeName => 'home';
  static String get routeLocation => '/';

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  int _barIndex = 1;

  @override
  Widget build(BuildContext context) {
    final booksForState =
        ref.watch(booksForStateProvider(BookState.values[_barIndex]));
    return Scaffold(
      appBar: const DanteAppBar(),
      body: booksForState.when(
        data: (books) {
          if (books.isEmpty) {
            return const Center(
              child: Text('No books found'),
            );
          }
          return Center(
            child: ListView.builder(
              itemCount: books.length,
              itemBuilder: (context, index) => ListTile(
                title: Text(books[index].title),
                subtitle: Text(books[index].state.toString()),
              ),
            ),
          );
        },
        error: (e, s) {
          ref
              .read(loggerProvider)
              .e('Error loading books', error: e, stackTrace: s);
          return const SizedBox.shrink();
        },
        loading: () => const Center(
          child: CircularProgressIndicator(),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _barIndex,
        selectedItemColor: Theme.of(context).colorScheme.primary,
        enableFeedback: true,
        onTap: (index) {
          setState(() {
            _barIndex = index;
          });
        },
        items: [
          BottomNavigationBarItem(
            icon: const Icon(Icons.bookmark_outline),
            activeIcon: Icon(
              Icons.bookmark,
              color: Theme.of(context).colorScheme.primary,
            ),
            label: 'tabs.for_later'.tr(),
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.book_outlined),
            activeIcon: Icon(
              Icons.book,
              color: Theme.of(context).colorScheme.primary,
            ),
            label: 'tabs.reading'.tr(),
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.check_outlined),
            activeIcon: Icon(
              Icons.check_outlined,
              color: Theme.of(context).colorScheme.primary,
            ),
            label: 'tabs.read'.tr(),
          ),
        ],
      ),
    );
  }
}
