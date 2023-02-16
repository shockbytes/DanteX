import 'dart:async';

import 'package:dantex/src/bloc/auth/auth_bloc.dart';
import 'package:dantex/src/bloc/auth/logout_event.dart';
import 'package:dantex/src/core/injection/dependency_injector.dart';
import 'package:dantex/src/data/authentication/entity/dante_user.dart';
import 'package:dantex/src/ui/add/add_book_sheet.dart';
import 'package:dantex/src/ui/core/dante_components.dart';
import 'package:dantex/src/ui/core/dante_search_bar.dart';
import 'package:dantex/src/ui/core/platform_components.dart';
import 'package:dantex/src/ui/login/login_page.dart';
import 'package:dantex/src/ui/profile/profile_page.dart';
import 'package:dantex/src/ui/settings/settings_page.dart';
import 'package:dantex/src/util/dante_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:get/get.dart';

enum AddBookAction { scan, query, manual }

class DanteAppBar extends StatefulWidget implements PreferredSizeWidget {
  const DanteAppBar({Key? key}) : super(key: key);

  @override
  createState() => DanteAppBarState();

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class DanteAppBarState extends State<DanteAppBar> {
  final AuthBloc _bloc = DependencyInjector.get<AuthBloc>();

  late StreamSubscription<LogoutEvent> _logoutSubscription;
  late DanteUser? user;

  @override
  void initState() {
    super.initState();
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
      user = currentUser;
    });
  }

  void _logoutEventReceived(LogoutEvent event) {
    if (event == LogoutEvent.logout) {
      // Navigate to login and remove everything from navigation stack.
      Get.offAll(() => const LoginPage());
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
              icon: const Icon(
                Icons.add,
                color: DanteColors.accent,
              ),
              onSelected: (AddBookAction action) async =>
                  _handleAddBookAction(context, action),
              itemBuilder: (BuildContext context) =>
                  <PopupMenuEntry<AddBookAction>>[
                PopupMenuItem<AddBookAction>(
                  value: AddBookAction.scan,
                  child: _AddActionItem(
                    text: AppLocalizations.of(context)!.add_scan,
                    iconData: Icons.camera_alt_outlined,
                    color: DanteColors.tabForLater,
                  ),
                ),
                PopupMenuItem<AddBookAction>(
                  value: AddBookAction.query,
                  child: _AddActionItem(
                    text: AppLocalizations.of(context)!.add_query,
                    iconData: Icons.search,
                    color: DanteColors.tabReading,
                  ),
                ),
                PopupMenuItem<AddBookAction>(
                  value: AddBookAction.manual,
                  child: _AddActionItem(
                    text: AppLocalizations.of(context)!.add_manual,
                    iconData: Icons.edit_outlined,
                    color: DanteColors.tabRead,
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
              child: _getUserAvatar(),
              enableFeedback: true,
              onTap: () => _openBottomSheet(context),
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
        // TODO Support book code scanning
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
          action: (BuildContext context) => Get.back(),
        ),
        PlatformDialogAction(
          name: AppLocalizations.of(context)!.search,
          action: (BuildContext context) async {
            Get.back();
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
            color: DanteColors.textPrimaryLight,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(12),
              topRight: Radius.circular(12),
            ),
            border: Border.all(color: DanteColors.textPrimary),
          ),
          height: 280,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: _buildUserTag(user),
              ),
              DanteComponents.divider(),
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
                    onItemClicked: () {
                      Get.to(
                        () => const SettingsPage(),
                        transition: Transition.downToUp,
                      );
                    },
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
          onPressed: () {
            Get.to(
              () => const ProfilePage(),
              transition: Transition.downToUp,
            );
          },
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
    if (user?.source == AuthenticationSource.anonymous) {
      showDialog<String>(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          title: Text(AppLocalizations.of(context)!.anonymous_logout_title),
          content:
              Text(AppLocalizations.of(context)!.anonymous_logout_description),
          actions: <Widget>[
            DanteComponents.outlinedButton(
              onPressed: () => Get.back(),
              child: Text(AppLocalizations.of(context)!.cancel),
            ),
            DanteComponents.outlinedButton(
              onPressed: () {
                Get.back();
                _bloc.logout();
              },
              child: Text(AppLocalizations.of(context)!.logout),
            ),
          ],
        ),
      );
    } else {
      _bloc.logout();
    }
  }

  Widget _getUserAvatar() {
    if (user != null) {
      String? photoUrl = user?.photoUrl;
      if (photoUrl != null) {
        return ClipRRect(
          borderRadius: BorderRadius.circular(20.0),
          child: Image.network(photoUrl),
        );
      }
    }
    return const Icon(
      Icons.account_circle_outlined,
      color: DanteColors.textPrimary,
    );
  }

  Widget _getUserHeading() {
    if (user != null) {
      String? name = user?.displayName;
      String? email = user?.email;
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          name != null ? Text(name) : const SizedBox.shrink(),
          email != null ? Text(email) : const SizedBox.shrink(),
        ],
      );
    }
    return const Text('Anonymous Bookworm');
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
          Icon(icon),
          const SizedBox(height: 4),
          Text(
            text,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
