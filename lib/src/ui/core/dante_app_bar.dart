import 'package:dantex/src/ui/core/dante_search_bar.dart';
import 'package:flutter/material.dart';

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
            Icon(
              Icons.add,
              color: Colors.black,
            ),
            SizedBox(width: 32),
            Expanded(
              child: DanteSearchBar(),
            ),
            SizedBox(width: 32),
            InkWell(
              child: Icon(
                Icons.account_circle_outlined,
                color: Colors.black,
              ),
              enableFeedback: true,
              onTap: () => _openBottomSheet(context),
            ),
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
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(12),
              topRight: Radius.circular(12),
            ),
            border: Border.all(color: Colors.black),
          ),
          height: 260,
          child: Column(
            children: [
              Text('Customer Header (TBD)'),
              GridView(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    mainAxisSpacing: 32,
                    childAspectRatio: 2),
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
