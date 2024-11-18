import 'package:dantex/ui/core/user_avatar.dart';
import 'package:dantex/ui/home/dante_bottom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DanteAppBar extends ConsumerWidget implements PreferredSizeWidget {
  const DanteAppBar({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AppBar(
      leading: IconButton(
        onPressed: () {},
        icon: Icon(
          Icons.add,
          size: 40,
          color: Theme.of(context).colorScheme.primary,
        ),
      ),
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
