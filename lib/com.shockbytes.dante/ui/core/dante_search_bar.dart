import 'package:dantex/com.shockbytes.dante/util/dante_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class DanteSearchBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: DanteColors.backgroundSearch,
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: Text(
              AppLocalizations.of(context)!.hint_search,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: DanteColors.textPrimary
              ),
            ),
          ),
        ],
      ),
    );
  }
}
