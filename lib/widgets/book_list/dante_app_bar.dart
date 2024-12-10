import 'package:dantex/providers/book.dart';
import 'package:dantex/widgets/add_book/add_book_button.dart';
import 'package:dantex/widgets/book_list/dante_bottom_sheet.dart';
import 'package:dantex/widgets/shared/user_avatar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DanteAppBar extends ConsumerWidget implements PreferredSizeWidget {
  const DanteAppBar({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AppBar(
      leading: const AddBookButton(),
      title: TextField(
        decoration: InputDecoration(
          hintText: 'Search',
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        onChanged: (value) => ref.read(searchTermProvider.notifier).set(value),
      ),
      actions: [
        IconButton(
          key: const ValueKey('user_avatar_button'),
          onPressed: () async => showModalBottomSheet(
            context: context,
            builder: (_) => const DanteBottomSheet(
              key: ValueKey('dante_bottom_sheet'),
            ),
          ),
          icon: const UserAvatar(),
        ),
      ],
    );
  }
}
