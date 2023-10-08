import 'dart:async';

import 'package:dantex/main.dart';
import 'package:dantex/src/bloc/auth/auth_bloc.dart';
import 'package:dantex/src/bloc/auth/logout_event.dart';
import 'package:dantex/src/data/authentication/entity/dante_user.dart';
import 'package:dantex/src/providers/bloc.dart';
import 'package:dantex/src/ui/add/add_book_widget.dart';
import 'package:dantex/src/ui/add/scan_book_page.dart';
import 'package:dantex/src/ui/core/dante_components.dart';
import 'package:dantex/src/ui/core/dante_search_bar.dart';
import 'package:dantex/src/ui/core/platform_components.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

enum AddBookAction { scan, query, manual }

class DanteAppBar extends ConsumerStatefulWidget implements PreferredSizeWidget {
  const DanteAppBar({Key? key}) : super(key: key);

  @override
  createState() => DanteAppBarState();

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class DanteAppBarState extends ConsumerState<DanteAppBar> {
  late StreamSubscription<LogoutEvent> _logoutSubscription;
  DanteUser? _user;
  late AuthBloc _bloc;

  @override
  void initState() {
    super.initState();
    _bloc = ref.read(authBlocProvider);
    _getUser();
    _logoutSubscription = _bloc.logoutEvents.listen(
      _logoutEventReceived,
    );
  }

  @override
  void dispose() {
    _logoutSubscription.cancel();
    super.dispose();
  }

  void _getUser() async {
    final currentUser = await _bloc.getAccount();
    setState(() {
      _user = currentUser;
    });
  }

  void _logoutEventReceived(LogoutEvent event) {
    if (event == LogoutEvent.logout) {
      context.pushReplacement(DanteRoute.login.navigationUrl);
    }
  }

  @override
  Widget build(BuildContext context) {
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
              onSelected: (AddBookAction action) async => _handleAddBookAction(context, action),
              itemBuilder: (BuildContext context) => <PopupMenuEntry<AddBookAction>>[
                PopupMenuItem<AddBookAction>(
                  value: AddBookAction.scan,
                  child: _AddActionItem(
                    text: AppLocalizations.of(context)!.add_scan,
                    iconData: Icons.camera_alt_outlined,
                    color: Theme.of(context).colorScheme.secondary,
                  ),
                ),
                PopupMenuItem<AddBookAction>(
                  value: AddBookAction.query,
                  child: _AddActionItem(
                    text: AppLocalizations.of(context)!.add_query,
                    iconData: Icons.search,
                    color: Theme.of(context).colorScheme.secondary,
                  ),
                ),
                PopupMenuItem<AddBookAction>(
                  value: AddBookAction.manual,
                  child: _AddActionItem(
                    text: AppLocalizations.of(context)!.add_manual,
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
              enableFeedback: true,
              onTap: () => _openBottomSheet(context),
              child: _getUserAvatar(),
            ),
            const SizedBox(width: 16),
          ],
        ),
      ),
    );
  }

  _handleAddBookAction(BuildContext context, AddBookAction action) async {
    switch (action) {
      case AddBookAction.scan:
        // TODO Replace with go_router
        Navigator.of(context).push(MaterialPageRoute(builder: (builder) => const ScanBookPage()));
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
    var controller = TextEditingController();
    await PlatformComponents.showPlatformInputDialog(
      context,
      title: AppLocalizations.of(context)!.query_search_title,
      maxLines: 1,
      hint: AppLocalizations.of(context)!.query_search_hint,
      textInputAction: TextInputAction.search,
      textInputType: TextInputType.text,
      actions: [
        PlatformDialogAction(
          name: AppLocalizations.of(context)!.cancel,
          action: (BuildContext context) => Navigator.of(context).pop(),
        ),
        PlatformDialogAction(
          name: AppLocalizations.of(context)!.search,
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
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: _buildUserTag(_user),
              ),
              DanteComponents.divider(context),
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
                    onItemClicked: () => context.go(DanteRoute.settings.navigationUrl),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildUserTag(DanteUser? user) {
    // TODO: fill out with user details
    return Row(
      children: [
        IconButton(
          onPressed: () => context.go(DanteRoute.profile.navigationUrl),
          icon: _getUserAvatar(),
        ),
        const SizedBox(width: 4),
        Expanded(
          child: _getUserHeading(),
        ),
        DanteComponents.outlinedButton(
          onPressed: () => _handleLogout(),
          child: const Text(
            'Logout',
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }

  void _handleLogout() async {
    if (_user?.source == AuthenticationSource.anonymous) {
      await PlatformComponents.showPlatformDialog(
        context,
        title: AppLocalizations.of(context)!.anonymous_logout_title,
        content: AppLocalizations.of(context)!.anonymous_logout_description,
        actions: [
          PlatformDialogAction(
            name: AppLocalizations.of(context)!.cancel,
            action: (context) => Navigator.of(context).pop(),
            isPrimary: false,
          ),
          PlatformDialogAction(
            name: AppLocalizations.of(context)!.logout,
            action: (context) {
              Navigator.of(context).pop();
              _bloc.logout();
            },
            isPrimary: true,
          ),
        ],
      );
    } else {
      _bloc.logout();
    }
  }

  Widget _getUserAvatar() {
    if (_user != null) {
      String? photoUrl = _user?.photoUrl;
      if (photoUrl != null) {
        return SizedBox(
          width: 32,
          height: 32,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20.0),
            child: Image.network(photoUrl),
          ),
        );
      }
    }
    return Icon(
      Icons.account_circle_outlined,
      size: 32,
      color: Theme.of(context).colorScheme.onSurface,
    );
  }

  Widget _getUserHeading() {
    if (_user == null) {
      return Text(
        'Anonymous Bookworm',
        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Theme.of(context).colorScheme.onSurface,
            ),
      );
    }

    String name = _user?.displayName ?? 'Anonymous Bookworm';
    String? email = _user?.email;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          name,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.onSurface,
              ),
        ),
        email != null
            ? Text(
                email,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
              )
            : const SizedBox.shrink(),
      ],
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
    Key? key,
    required this.text,
    required this.icon,
    required this.onItemClicked,
  }) : super(key: key);

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
