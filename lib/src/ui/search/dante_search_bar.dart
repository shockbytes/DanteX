import 'package:dantex/src/providers/app_router.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class DanteSearchBar extends StatelessWidget {
  const DanteSearchBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      clipBehavior: Clip.hardEdge,
      color: Theme.of(context).colorScheme.tertiaryContainer,
      child: InkWell(
        onTap: () => context.go(DanteRoute.search.navigationUrl),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(width: 4),
            Icon(
              Icons.search_outlined,
              color: Theme.of(context).colorScheme.onTertiaryContainer,
            ),
            const SizedBox(width: 4),
            Expanded(
              child: Center(
                child: Text(
                  'search.hint'.tr(),
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onTertiaryContainer,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
