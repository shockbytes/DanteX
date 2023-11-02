import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dantex/src/data/authentication/entity/dante_user.dart';
import 'package:dantex/src/providers/app_router.dart';
import 'package:dantex/src/providers/authentication.dart';
import 'package:dantex/src/ui/add/add_book_widget.dart';
import 'package:dantex/src/ui/core/dante_components.dart';
import 'package:dantex/src/ui/core/platform_components.dart';
import 'package:dantex/src/ui/search/dante_search_bar.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

enum AddBookAction { scan, query, manual }

class DanteAppBar extends ConsumerWidget implements PreferredSizeWidget {
  const DanteAppBar({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userProvider);
    return user.maybeWhen(
      data: (user) {
        return SafeArea(
          child: Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 16.0,
              vertical: 8.0,
            ),
            child: Row(
              children: [
                PopupMenuButton<AddBookAction>(
                  padding: const EdgeInsets.all(0),
                  icon: Icon(
                    Icons.add,
                    size: 32,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  onSelected: (AddBookAction action) async =>
                      _handleAddBookAction(context, action),
                  itemBuilder: (BuildContext context) =>
                      <PopupMenuEntry<AddBookAction>>[
                    PopupMenuItem<AddBookAction>(
                      value: AddBookAction.scan,
                      child: _AddActionItem(
                        text: 'add_book.scan'.tr(),
                        iconData: Icons.camera_alt_outlined,
                        color: Theme.of(context).colorScheme.secondary,
                      ),
                    ),
                    PopupMenuItem<AddBookAction>(
                      value: AddBookAction.query,
                      child: _AddActionItem(
                        text: 'add_book.query'.tr(),
                        iconData: Icons.search,
                        color: Theme.of(context).colorScheme.secondary,
                      ),
                    ),
                    PopupMenuItem<AddBookAction>(
                      value: AddBookAction.manual,
                      child: _AddActionItem(
                        text: 'add_book.manual'.tr(),
                        iconData: Icons.edit_outlined,
                        color: Theme.of(context).colorScheme.secondary,
                      ),
                    ),
                  ],
                ),
                const SizedBox(width: 12),
                const Expanded(
                  child: DanteSearchBar(),
                ),
                const SizedBox(width: 32),
                InkWell(
                  onTap: () => _openBottomSheet(context),
                  child: UserAvatar(user: user),
                ),
                const SizedBox(width: 16),
              ],
            ),
          ),
        );
      },
      orElse: () {
        return const SizedBox.shrink();
      },
    );
  }

  _handleAddBookAction(BuildContext context, AddBookAction action) async {
    switch (action) {
      case AddBookAction.scan:
        context.go(DanteRoute.scanBook.navigationUrl);
        break;
      case AddBookAction.query:
        await _handleQueryAction(context, action);
        break;
      case AddBookAction.manual:
        // TODO Support manually adding books
        break;
    }
  }

  _handleQueryAction(BuildContext context, AddBookAction action) async {
    final controller = TextEditingController();
    await showDanteInputDialog(
      context,
      title: 'query_search.title'.tr(),
      hint: 'query_search.hint'.tr(),
      textInputAction: TextInputAction.search,
      actions: [
        DanteDialogAction(
          name: 'cancel'.tr(),
          action: (BuildContext context) => Navigator.of(context).pop(),
        ),
        DanteDialogAction(
          name: 'search'.tr(),
          action: (BuildContext context) async {
            Navigator.of(context).pop();
            await openAddBookSheet(
              context,
              query: controller.text,
            );
          },
        ),
      ],
      controller: controller,
    );
  }

  _openBottomSheet(BuildContext context) async {
    await showModalBottomSheet(
      context: context,
      barrierColor: Colors.transparent,
      builder: (context) => Container(
        color: Colors.transparent,
        child: Container(
          decoration: BoxDecoration(
            color: Theme.of(context).bottomSheetTheme.backgroundColor,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(12),
              topRight: Radius.circular(12),
            ),
          ),
          height: 280,
          child: Column(
            children: [
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 12),
                child: UserTag(),
              ),
              const DanteDivider(),
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
                    text: 'Statistics',
                    icon: Icons.pie_chart_outline,
                    onItemClicked: () {},
                  ),
                  _MenuItem(
                    text: 'Timeline',
                    icon: Icons.linear_scale,
                    onItemClicked: () {},
                  ),
                  _MenuItem(
                    text: 'Wishlist',
                    icon: Icons.article,
                    onItemClicked: () {},
                  ),
                  _MenuItem(
                    text: 'Recommendations',
                    icon: Icons.whatshot_outlined,
                    onItemClicked: () {},
                  ),
                  _MenuItem(
                    text: 'Book keeping',
                    icon: Icons.all_inbox_outlined,
                    onItemClicked: () {},
                  ),
                  _MenuItem(
                    text: 'Settings',
                    icon: Icons.settings_outlined,
                    onItemClicked: () =>
                        context.go(DanteRoute.settings.navigationUrl),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _AddActionItem extends StatelessWidget {
  final String text;
  final IconData iconData;
  final Color color;

  const _AddActionItem({
    required this.text,
    required this.iconData,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          iconData,
          color: color,
        ),
        const SizedBox(width: 8),
        Text(
          text,
          style: TextStyle(
            color: color,
          ),
        ),
      ],
    );
  }
}

class _MenuItem extends StatelessWidget {
  final String text;
  final IconData icon;
  final VoidCallback onItemClicked;

  const _MenuItem({
    required this.text,
    required this.icon,
    required this.onItemClicked,
  });

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
            text,
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

class UserTag extends ConsumerWidget {
  const UserTag({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userProvider);

    return user.when(
      data: (user) {
        return Row(
          children: [
            IconButton(
              onPressed: () => context.go(DanteRoute.profile.navigationUrl),
              icon: UserAvatar(user: user),
            ),
            const SizedBox(width: 4),
            Expanded(
              child: _getUserHeading(user),
            ),
            DanteOutlinedButton(
              onPressed: () async => _handleLogout(context, ref, user),
              child: const Text(
                'Logout',
                textAlign: TextAlign.center,
              ),
            ),
          ],
        );
      },
      loading: () {
        return const CircularProgressIndicator.adaptive();
      },
      error: (error, stackTrace) {
        // Log error here.
        return const SizedBox.shrink();
      },
    );
  }

  Widget _getUserHeading(DanteUser? user) {
    final String? name = user?.displayName;
    final String? email = user?.email;
    if (user?.source == AuthenticationSource.anonymous) {
      return const Text('Anonymous Bookworm');
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        name != null ? Text(name) : const SizedBox.shrink(),
        email != null ? Text(email) : const SizedBox.shrink(),
      ],
    );
  }

  Future<void> _handleLogout(
    BuildContext context,
    WidgetRef ref,
    DanteUser? user,
  ) async {
    if (user?.source == AuthenticationSource.anonymous) {
      await showDialog<String>(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          title: Text('anonymous_logout.title'.tr()),
          content: Text('anonymous_logout.description'.tr()),
          actions: <Widget>[
            DanteOutlinedButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('cancel'.tr()),
            ),
            DanteOutlinedButton(
              onPressed: () async {
                Navigator.of(context).pop();
                await ref.watch(authenticationRepositoryProvider).logout();
              },
              child: Text('logout'.tr()),
            ),
          ],
        ),
      );
    } else {
      await ref.watch(authenticationRepositoryProvider).logout();
    }
  }
}

class UserAvatar extends ConsumerWidget {
  final DanteUser? user;

  const UserAvatar({
    required this.user,
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final String? photoUrl = user?.photoUrl;
    if (photoUrl != null) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(20.0),
        child: CachedNetworkImage(
          imageUrl: photoUrl,
          width: 40,
          height: 40,
        ),
      );
    }
    return Icon(
      Icons.account_circle_outlined,
      size: 32,
      color: Theme.of(context).colorScheme.onSurface,
    );
  }
}

class BottomSheet extends ConsumerWidget {
  const BottomSheet({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      color: Colors.transparent,
      child: Container(
        color: Colors.transparent,
        child: Container(
          decoration: BoxDecoration(
            color: Theme.of(context).bottomSheetTheme.backgroundColor,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(12),
              topRight: Radius.circular(12),
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 12),
                child: UserTag(),
              ),
              const DanteDivider(),
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
                    text: 'Statistics',
                    icon: Icons.pie_chart_outline,
                    onItemClicked: () {},
                  ),
                  _MenuItem(
                    text: 'Timeline',
                    icon: Icons.linear_scale,
                    onItemClicked: () {},
                  ),
                  _MenuItem(
                    text: 'Wishlist',
                    icon: Icons.article,
                    onItemClicked: () {},
                  ),
                  _MenuItem(
                    text: 'Recommendations',
                    icon: Icons.whatshot_outlined,
                    onItemClicked: () {},
                  ),
                  _MenuItem(
                    text: 'Book keeping',
                    icon: Icons.all_inbox_outlined,
                    onItemClicked: () {},
                  ),
                  _MenuItem(
                    text: 'Settings',
                    icon: Icons.settings_outlined,
                    onItemClicked: () =>
                        context.go(DanteRoute.settings.navigationUrl),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
