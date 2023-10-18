import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class DanteSearchBar extends StatelessWidget {
  const DanteSearchBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.tertiaryContainer,
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: Text(
              'search_hint'.tr(),
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Theme.of(context).colorScheme.onTertiaryContainer,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
