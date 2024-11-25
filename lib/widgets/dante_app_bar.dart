import 'package:dantex/widgets/add_book_button.dart';
import 'package:dantex/widgets/dante_bottom_sheet.dart';
import 'package:dantex/widgets/user_avatar.dart';
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
      ),
      actions: [
        IconButton(
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
