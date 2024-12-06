import 'package:dantex/models/user.dart';
import 'package:dantex/providers/auth.dart';
import 'package:dantex/providers/firebase.dart';
import 'package:dantex/screens/book_management_screen.dart';
import 'package:dantex/widgets/shared/user_avatar.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class DanteBottomSheet extends ConsumerWidget {
  const DanteBottomSheet({super.key});

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
                  child: const Text('bottom_sheet_menu.sign_out').tr(),
                ),
              ],
            ),
            const SizedBox(height: 8),
            const Divider(),
            const SizedBox(height: 8),
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
                  onItemClicked: () async => context.push(
                    BookManagementScreen.routeLocation,
                  ),
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
      title: const Text('authentication.anonymous_sign_out.title').tr(),
      content: const Text('authentication.anonymous_sign_out.description').tr(),
      actions: <Widget>[
        OutlinedButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('authentication.dismiss').tr(),
        ),
        OutlinedButton(
          onPressed: () async => ref.read(firebaseAuthProvider).signOut(),
          child: const Text('authentication.sign_out').tr(),
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
            'authentication.anonymous_user',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).colorScheme.tertiary,
                ),
          ).tr();
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
      borderRadius: BorderRadius.circular(16),
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
            text,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Theme.of(context).colorScheme.onTertiaryContainer,
            ),
          ).tr(),
        ],
      ),
    );
  }
}
