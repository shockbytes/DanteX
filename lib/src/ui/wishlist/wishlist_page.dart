import 'package:dantex/src/data/book/entity/book_state.dart';
import 'package:dantex/src/ui/core/themed_app_bar.dart';
import 'package:dantex/src/ui/main/book_state_page.dart';
import 'package:flutter/material.dart';

class WishlistPage extends StatelessWidget {
  const WishlistPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      // TODO Show app bar only on mobile devices
      appBar: ThemedAppBar(
        title: Text('Wishlist'),
      ),
      body: Center(
        child: BookStatePage(BookState.wishlist),
      ),
    );
  }
}
