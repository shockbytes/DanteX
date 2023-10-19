import 'package:dantex/src/data/book/entity/book_state.dart';
import 'package:dantex/src/ui/core/dante_app_bar.dart';
import 'package:dantex/src/ui/main/book_state_page.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _barIndex = 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const DanteAppBar(),
      body: Center(
        child: BookStatePage(_resolveState()),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _barIndex,
        selectedItemColor: Theme.of(context).colorScheme.primary,
        enableFeedback: true,
        onTap: (int index) {
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

  BookState _resolveState() {
    return BookState.values[_barIndex];
  }
}
