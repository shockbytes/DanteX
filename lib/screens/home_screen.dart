import 'package:dantex/models/book_state.dart';
import 'package:dantex/widgets/book_list.dart';
import 'package:dantex/widgets/dante_app_bar.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  static String get routeName => 'home';
  static String get routeLocation => '/';

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
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
            BookList(
              key: ValueKey('read_later_list'),
              bookState: BookState.readLater,
            ),
            BookList(
              key: ValueKey('reading_list'),
              bookState: BookState.reading,
            ),
            BookList(
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
