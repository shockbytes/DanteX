import 'package:dantex/models/book_state.dart';
import 'package:dantex/widgets/book_list/book_list.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class WishlistScreen extends StatelessWidget {
  const WishlistScreen({super.key});

  static String get routeName => 'wishlist';
  static String get routeLocation => '/$routeName';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('wishlist.title').tr(),
      ),
      body: const Padding(
        padding: EdgeInsets.symmetric(horizontal: 8),
        child: SafeArea(
          child: BookList(
            key: ValueKey('wishlist'),
            bookState: BookState.wishlist,
          ),
        ),
      ),
    );
  }
}
