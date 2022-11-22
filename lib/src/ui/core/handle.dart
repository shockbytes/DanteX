import 'package:dantex/src/util/dante_colors.dart';
import 'package:flutter/widgets.dart';

class Handle extends StatelessWidget {
  const Handle({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          margin: const EdgeInsets.symmetric(vertical: 8.0),
          width: 60,
          height: 4,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(2.0),
            color: DanteColors.textSecondary,
          ),
        )
      ],
    );
  }
}
