import 'package:dantex/src/data/book/entity/book_state.dart';
import 'package:dantex/src/ui/core/dante_app_bar.dart';
import 'package:dantex/src/ui/main/book_state_page.dart';
import 'package:dantex/src/util/dante_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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
        selectedItemColor: _barIndex == 0
            ? DanteColors.tabForLater
            : _barIndex == 1
                ? DanteColors.tabReading
                : DanteColors.tabRead,
        enableFeedback: true,
        onTap: (int index) {
          setState(() {
            _barIndex = index;
          });
        },
        items: [
          BottomNavigationBarItem(
            icon: const Icon(Icons.bookmark_outline),
            activeIcon: const Icon(
              Icons.bookmark,
              color: DanteColors.tabForLater,
            ),
            label: AppLocalizations.of(context)!.tab_for_later,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.book_outlined),
            activeIcon: const Icon(
              Icons.book,
              color: DanteColors.tabReading,
            ),
            label: AppLocalizations.of(context)!.tab_reading,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.check_outlined),
            activeIcon: const Icon(
              Icons.check_outlined,
              color: DanteColors.tabRead,
            ),
            label: AppLocalizations.of(context)!.tab_read,
          ),
        ],
      ),
    );
  }

  BookState _resolveState() {
    return BookState.values[_barIndex];
  }
}
