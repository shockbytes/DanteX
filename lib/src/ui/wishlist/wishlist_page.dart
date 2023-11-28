import 'package:dantex/src/data/book/entity/book_state.dart';
import 'package:dantex/src/ui/core/themed_app_bar.dart';
import 'package:dantex/src/ui/main/book_state_page.dart';
import 'package:dantex/src/util/layout_utils.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class WishlistPage extends StatelessWidget {
  const WishlistPage({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Scaffold(
          appBar: ThemedAppBar(
            title: isDesktop(constraints)
                ? null
                : Text('navigation.wishlist'.tr())
          ),
          body: const Center(
            child: BookStatePage(BookState.wishlist),
          ),
        );
      },
    );
  }
}
