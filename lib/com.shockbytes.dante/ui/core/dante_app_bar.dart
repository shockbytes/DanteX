import 'package:dantex/com.shockbytes.dante/bloc/add/add_book_bloc.dart';
import 'package:dantex/com.shockbytes.dante/data/book/book_repository.dart';
import 'package:dantex/com.shockbytes.dante/ui/core/dante_search_bar.dart';
import 'package:dantex/com.shockbytes.dante/util/dante_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:get/get.dart';

enum AddBookAction { scan, query, manual }

class DanteAppBar extends StatelessWidget implements PreferredSizeWidget {
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
                color: DanteColors.accent,
              ),
              onSelected: (AddBookAction action) {

                // TODO Cleanup just for testing
                Get.find<AddBookBloc>().downloadBook('Im Westen nichts Neues').then(
                      (bookSuggestion) {
                        Get.find<BookRepository>().create(bookSuggestion.target);
                      },
                    );

                // TODO Run action
                print(action.name);
              },
              itemBuilder: (BuildContext context) => <PopupMenuEntry<AddBookAction>>[
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
            SizedBox(width: 12),
            Expanded(
              child: DanteSearchBar(),
            ),
            SizedBox(width: 32),
            InkWell(
              child: Icon(
                Icons.account_circle_outlined,
                color: DanteColors.textPrimary,
              ),
              enableFeedback: true,
              onTap: () => _openBottomSheet(context),
            ),
            SizedBox(width: 16),
          ],
        ),
      ),
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
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(12),
              topRight: Radius.circular(12),
            ),
            border: Border.all(color: DanteColors.textPrimary),
          ),
          height: 260,
          child: Column(
            children: [
              Text('Customer Header (TBD)'),
              GridView(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3, mainAxisSpacing: 32, childAspectRatio: 2),
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
                    onItemClicked: () {},
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
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
        SizedBox(width: 8),
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
      child: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon),
            SizedBox(height: 4),
            Text(
              text,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
