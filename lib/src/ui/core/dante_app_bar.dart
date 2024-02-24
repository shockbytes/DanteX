import 'dart:async';

import 'package:dantex/src/data/authentication/entity/dante_user.dart';
import 'package:dantex/src/providers/app_router.dart';
import 'package:dantex/src/providers/authentication.dart';
import 'package:dantex/src/ui/add/add_book_widget.dart';
import 'package:dantex/src/ui/core/dante_components.dart';
import 'package:dantex/src/ui/core/platform_components.dart';
import 'package:dantex/src/ui/core/user_avatar.dart';
import 'package:dantex/src/ui/search/dante_search_bar.dart';
import 'package:dantex/src/util/layout_utils.dart';
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
            child: LayoutBuilder(
              builder: (context, constraints) {
                if (isDesktop(constraints)) {
                  return _buildDesktopView(context);
                } else {
                  return _buildMobileView(context, user);
                }
              },
            ),
          ),
        );
      },
      orElse: () {
        return const SizedBox.shrink();
      },
    );
  }

  Widget _buildDesktopView(BuildContext context) {
    return Row(
      children: [
        const Spacer(),
        const SizedBox(
          width: 600,
          child: DanteSearchBar(),
        ),
        const Spacer(),
        TextButton(
          onPressed: () async {
            await _handleQueryAction(context);
          },
          child: _AddActionItem(
            text: 'add_book.query'.tr(),
            iconData: Icons.search,
            color: Theme.of(context).colorScheme.secondary,
          ),
        ),
        const SizedBox(width: 16),
        TextButton(
          onPressed: () {
            context.go(DanteRoute.manualAdd.navigationUrl);
          },
          child: _AddActionItem(
            text: 'add_book.manual'.tr(),
            iconData: Icons.edit_outlined,
            color: Theme.of(context).colorScheme.secondary,
          ),
        ),
      ],
    );
  }

  Widget _buildMobileView(BuildContext context, DanteUser? user) {
    return Row(
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
          child: UserAvatar(userImageUrl: user?.photoUrl),
        ),
        const SizedBox(width: 16),
      ],
    );
  }

  _handleAddBookAction(BuildContext context, AddBookAction action) async {
    switch (action) {
      case AddBookAction.scan:
        context.go(DanteRoute.scanBook.navigationUrl);
        break;
      case AddBookAction.query:
        await _handleQueryAction(context);
        break;
      case AddBookAction.manual:
        context.go(DanteRoute.manualAdd.navigationUrl);
        break;
    }
  }

  _handleQueryAction(BuildContext context) async {
    final controller = TextEditingController();
    await showDanteInputDialog(
      context,
      title: 'query_search.title'.tr(),
      hint: 'query_search.hint'.tr(),
      textInputAction: TextInputAction.search,
      actions: [
        DanteDialogAction(
          name: 'cancel'.tr(),
          action: (BuildContext context) {},
        ),
        DanteDialogAction(
          name: 'search.search'.tr(),
          action: (BuildContext context) async {
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
      builder: (context) => const DanteBottomSheet(),
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

class UserTag extends ConsumerWidget {
  final bool useMobileLayout;

  const UserTag({
    required this.useMobileLayout,
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userProvider);

    return user.when(
      data: (user) {
        if (useMobileLayout) {
          return _buildMobileView(context, user, ref);
        } else {
          return _buildDesktopView(context, user, ref);
        }
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

  Widget _buildDesktopView(
    BuildContext context,
    DanteUser? user,
    WidgetRef ref,
  ) {
    return Column(
      children: [
        IconButton(
          onPressed: () => context.go(DanteRoute.profile.navigationUrl),
          icon: UserAvatar(userImageUrl: user?.photoUrl),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4.0),
          child: _getUserHeading(context, user),
        ),
        TextButton(
          onPressed: () async => _handleLogout(context, ref, user),
          child: Text(
            'logout'.tr(),
            textAlign: TextAlign.center,
          ),
        ),
        const DanteDivider(),
      ],
    );
  }

  Widget _buildMobileView(
    BuildContext context,
    DanteUser? user,
    WidgetRef ref,
  ) {
    return Row(
      children: [
        IconButton(
          onPressed: () => context.go(DanteRoute.profile.navigationUrl),
          icon: UserAvatar(userImageUrl: user?.photoUrl),
        ),
        const SizedBox(width: 4),
        Expanded(
          child: _getUserHeading(context, user),
        ),
        DanteOutlinedButton(
          onPressed: () async => _handleLogout(context, ref, user),
          child: Text(
            'logout'.tr(),
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }

  Widget _getUserHeading(BuildContext context, DanteUser? user) {
    final String? name = user?.displayName;
    final String? email = user?.email;
    if (user?.source == AuthenticationSource.anonymous) {
      return Text(
        'anonymous-user'.tr(),
        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Theme.of(context).colorScheme.tertiary,
            ),
        textAlign: useMobileLayout ? TextAlign.start : TextAlign.center,
      );
    }
    return Column(
      crossAxisAlignment: useMobileLayout
          ? CrossAxisAlignment.start
          : CrossAxisAlignment.center,
      children: [
        name != null
            ? Text(
                name,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Theme.of(context).colorScheme.tertiary,
                    ),
                textAlign: TextAlign.center,
              )
            : const SizedBox.shrink(),
        email != null
            ? Text(
                email,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Theme.of(context).colorScheme.tertiary,
                    ),
                textAlign: TextAlign.center,
              )
            : const SizedBox.shrink(),
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

class DanteBottomSheet extends ConsumerWidget {
  const DanteBottomSheet({super.key});

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
                child: UserTag(useMobileLayout: true),
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
                    text: 'navigation.stats',
                    icon: Icons.pie_chart_outline,
                    onItemClicked: () => context.go(
                      DanteRoute.statistics.navigationUrl,
                    ),
                  ),
                  _MenuItem(
                    text: 'navigation.timeline',
                    icon: Icons.linear_scale,
                    onItemClicked: () => context.go(
                      DanteRoute.timeline.navigationUrl,
                    ),
                  ),
                  _MenuItem(
                    text: 'navigation.wishlist',
                    icon: Icons.article,
                    onItemClicked: () => context.go(
                      DanteRoute.wishlist.navigationUrl,
                    ),
                  ),
                  _MenuItem(
                    text: 'navigation.recommendations',
                    icon: Icons.whatshot_outlined,
                    onItemClicked: () => context.go(
                      DanteRoute.recommendations.navigationUrl,
                    ),
                  ),
                  _MenuItem(
                    text: 'navigation.book-keeping',
                    icon: Icons.all_inbox_outlined,
                    onItemClicked: () =>
                        context.go(DanteRoute.bookManagement.navigationUrl),
                  ),
                  _MenuItem(
                    text: 'navigation.settings',
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
