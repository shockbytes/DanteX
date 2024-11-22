import 'package:dantex/data/book/book.dart';
import 'package:dantex/data/book/book_state.dart';
import 'package:dantex/providers/book.dart';
import 'package:dantex/providers/logger.dart';
import 'package:dantex/ui/book/book_list_card.dart';
import 'package:dantex/ui/core/cached_reorderable_list_view.dart';
import 'package:dantex/ui/home/dante_app_bar.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  static String get routeName => 'home';
  static String get routeLocation => '/';

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 1;
  final PageController _pageController = PageController(initialPage: 1);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const DanteAppBar(),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: PageView(
          controller: _pageController,
          onPageChanged: (value) => setState(() => _selectedIndex = value),
          children: const [
            _BookList(
              key: ValueKey('read_later_list'),
              bookState: BookState.readLater,
            ),
            _BookList(
              key: ValueKey('reading_list'),
              bookState: BookState.reading,
            ),
            _BookList(
              key: ValueKey('read_list'),
              bookState: BookState.read,
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        onTap: (index) async => _pageController.animateToPage(
          index,
          duration: const Duration(milliseconds: 400),
          curve: Curves.easeInOut,
        ),
        currentIndex: _selectedIndex,
        selectedItemColor: Theme.of(context).colorScheme.primary,
        enableFeedback: true,
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

class _BookList extends ConsumerWidget {
  const _BookList({required this.bookState, super.key});

  final BookState bookState;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final booksForState = ref.watch(booksForStateProvider(bookState));

    return Center(
      child: booksForState.when(
        data: (books) {
          if (books.isEmpty) {
            return const Text('No books found');
          }
          return CachedReorderableListView(
            onReorder: (oldIndex, newIndex) async {
              final updatedBooks = List<Book>.from(books);
              final movedBook = updatedBooks.removeAt(oldIndex);
              // If we're moving the book down the list, we need to adjust the
              // index to account for the book being removed.
              if (oldIndex < newIndex) {
                newIndex -= 1;
              }
              updatedBooks.insert(newIndex, movedBook);
              await ref
                  .read(bookRepositoryProvider)
                  .updatePositions(updatedBooks);
            },
            list: books,
            itemBuilder: (context, book) => Padding(
              key: ValueKey('book_list_card_${book.id}'),
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: BookListCard(
                book: book,
              ),
            ),
          );
        },
        error: (e, s) {
          ref.read(loggerProvider).e(
                'Error loading books',
                error: e,
                stackTrace: s,
              );
          return const SizedBox.shrink();
        },
        loading: CircularProgressIndicator.new,
      ),
    );
  }
}
