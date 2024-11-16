import 'package:dantex/data/auth/user.dart';
import 'package:dantex/providers/auth.dart';
import 'package:dantex/providers/firebase.dart';
import 'package:dantex/ui/core/user_avatar.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DanteAppBar extends ConsumerWidget implements PreferredSizeWidget {
  const DanteAppBar({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: AppBar(
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
              builder: (_) => const _BottomSheetMenu(
                key: ValueKey('bottom_sheet_menu'),
              ),
            ),
            icon: const UserAvatar(),
          ),
        ],
      ),
    );
  }
}

class _BottomSheetMenu extends ConsumerWidget {
  const _BottomSheetMenu({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.only(left: 16, right: 16, top: 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                const UserAvatar(),
                const SizedBox(width: 8),
                const Expanded(child: _UserTag(key: ValueKey('user_tag'))),
                OutlinedButton(
                  onPressed: () async {
                    final user = ref.read(userProvider).value;
                    if (user?.source == AuthenticationSource.anonymous) {
                      await showDialog<bool>(
                        context: context,
                        builder: (_) => const _AnonymousSignOutDialog(
                          key: ValueKey('anonymous_sign_out_dialog'),
                        ),
                      );
                    } else {
                      await ref.read(firebaseAuthProvider).signOut();
                    }
                  },
                  child: Text('logout'.tr()),
                ),
              ],
            ),
            const Divider(),
            GridView(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                mainAxisSpacing: 32,
                childAspectRatio: 2,
              ),
              children: [
                _MenuItem(
                  text: 'navigation.stats',
                  icon: Icons.pie_chart_outline_outlined,
                  onItemClicked: () {},
                ),
                _MenuItem(
                  text: 'navigation.timeline',
                  icon: Icons.linear_scale_outlined,
                  onItemClicked: () {},
                ),
                _MenuItem(
                  text: 'navigation.wishlist',
                  icon: Icons.article_outlined,
                  onItemClicked: () {},
                ),
                _MenuItem(
                  text: 'navigation.recommendations',
                  icon: Icons.whatshot_outlined,
                  onItemClicked: () {},
                ),
                _MenuItem(
                  text: 'navigation.book-keeping',
                  icon: Icons.all_inbox_outlined,
                  onItemClicked: () {},
                ),
                _MenuItem(
                  text: 'navigation.settings',
                  icon: Icons.settings_outlined,
                  onItemClicked: () {},
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _AnonymousSignOutDialog extends ConsumerWidget {
  const _AnonymousSignOutDialog({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AlertDialog(
      title: Text('anonymous_logout.title'.tr()),
      content: Text('anonymous_logout.description'.tr()),
      actions: <Widget>[
        OutlinedButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text('cancel'.tr()),
        ),
        OutlinedButton(
          onPressed: () async => ref.read(firebaseAuthProvider).signOut(),
          child: Text('logout'.tr()),
        ),
      ],
    );
  }
}

class _UserTag extends ConsumerWidget {
  const _UserTag({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userProvider);

    return user.maybeWhen(
      data: (user) {
        if (user == null) {
          return const SizedBox.shrink();
        }

        if (user.source == AuthenticationSource.anonymous) {
          return Text(
            'anonymous-user'.tr(),
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).colorScheme.tertiary,
                ),
          );
        }

        final name = user.displayName;
        final email = user.email;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (name != null)
              Text(
                name,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Theme.of(context).colorScheme.tertiary,
                    ),
                textAlign: TextAlign.center,
              ),
            if (email != null)
              Text(
                email,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Theme.of(context).colorScheme.tertiary,
                    ),
                textAlign: TextAlign.center,
              ),
          ],
        );
      },
      orElse: () => const SizedBox.shrink(),
    );
  }
}

class _MenuItem extends StatelessWidget {
  const _MenuItem({
    required this.text,
    required this.icon,
    required this.onItemClicked,
  });
  final String text;
  final IconData icon;
  final VoidCallback onItemClicked;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onItemClicked,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            color: Theme.of(context).colorScheme.onTertiaryContainer,
          ),
          const SizedBox(height: 4),
          Text(
            text.tr(),
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Theme.of(context).colorScheme.onTertiaryContainer,
            ),
          ),
        ],
      ),
    );
  }
}
