import 'package:flutter/material.dart';

class ListCard extends StatelessWidget {
  const ListCard({
    required this.leading,
    required this.body,
    required this.trailing,
    this.onTap,
    super.key,
    this.subActions,
  });

  final Widget leading;
  final Widget body;
  final Widget trailing;
  final Widget? subActions;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final subActions = this.subActions;

    return Card(
      child: InkWell(
        borderRadius: BorderRadius.circular(8),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          leading,
                          const SizedBox(width: 16),
                          Expanded(child: body),
                        ],
                      ),
                      if (subActions != null) ...[
                        const SizedBox(height: 8),
                        subActions,
                      ],
                    ],
                  ),
                ),
              ),
              trailing,
            ],
          ),
        ),
      ),
    );
  }
}
