import 'package:dantex/models/book_state.dart';
import 'package:dantex/theme/dante_colors.dart';
import 'package:dantex/widgets/book_list/book_list.dart';
import 'package:dantex/widgets/book_list/dante_app_bar.dart';
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
        selectedItemColor: selectedItemColor,
        // selectedIconTheme: IconThemeData(color: selectedItemColor),
        enableFeedback: true,
        items: [
          BottomNavigationBarItem(
            icon: const Icon(Icons.bookmark_outline),
            activeIcon: const Icon(Icons.bookmark),
            label: 'book_state.for_later'.tr(),
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.book_outlined),
            activeIcon: const Icon(Icons.book),
            label: 'book_state.reading'.tr(),
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.done_outline),
            activeIcon: const Icon(Icons.done_outline),
            label: 'book_state.read'.tr(),
          ),
        ],
      ),
    );
  }

  Color get selectedItemColor {
    final danteColors = Theme.of(context).extension<DanteColors>();
    if (danteColors == null) {
      return Theme.of(context).colorScheme.primary;
    }
    if (_selectedIndex == 0) {
      return danteColors.forLaterColor!;
    } else if (_selectedIndex == 1) {
      return danteColors.readingColor!;
    } else {
      return danteColors.readColor!;
    }
  }
}
