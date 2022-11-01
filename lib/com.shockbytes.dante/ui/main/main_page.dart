
import 'package:dantex/com.shockbytes.dante/data/book/entity/book_state.dart';
import 'package:dantex/com.shockbytes.dante/ui/core/dante_app_bar.dart';
import 'package:dantex/com.shockbytes.dante/ui/main/book_state_page.dart';
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
      appBar: DanteAppBar(),
      body: Center(
        child: BookStatePage(_resolveState()),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _barIndex,
        selectedItemColor: Colors.black,
        enableFeedback: true,
        onTap: (int index) {
          setState(() {
            _barIndex = index;
          });
        },
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.bookmark_outline),
            activeIcon: Icon(Icons.bookmark, color: Colors.green),
            label: AppLocalizations.of(context)!.tab_for_later,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.book_outlined),
            activeIcon: Icon(Icons.book, color: Colors.blue),
            label: AppLocalizations.of(context)!.tab_reading,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.check_outlined),
            activeIcon: Icon(Icons.check_outlined, color: Colors.deepOrange),
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
