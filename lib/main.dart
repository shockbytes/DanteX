import 'package:dantex/com.shockbytes.dante/data/book/entity/book_state.dart';
import 'package:dantex/com.shockbytes.dante/ui/core/dante_app_bar.dart';
import 'package:dantex/com.shockbytes.dante/ui/main/book_state_page.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  runApp(const DanteXApp());
}

class DanteXApp extends StatelessWidget {
  const DanteXApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Dante',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.light,
        textTheme: GoogleFonts.nunitoTextTheme(),
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  int _barIndex = 0;
  BookState _state = BookState.READ;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: DanteAppBar(),
      body: Center(
        child: BookStatePage(_state),
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
            label: 'For later',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.book_outlined),
            activeIcon: Icon(Icons.book, color: Colors.blue),
            label: 'Read now',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.check_outlined),
            activeIcon: Icon(Icons.check_outlined, color: Colors.deepOrange),
            label: 'Read',
          ),
        ],
      ),
    );
  }
}
