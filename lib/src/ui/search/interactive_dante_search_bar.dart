import 'package:flutter/material.dart';

class InteractiveDanteSearchBar extends StatelessWidget {
  final Function(String query) onQueryChanged;

  const InteractiveDanteSearchBar({
    required this.onQueryChanged,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      margin: EdgeInsets.zero,
      clipBehavior: Clip.hardEdge,
      color: Theme.of(context).colorScheme.tertiaryContainer,
      child: TextField(
        style: TextStyle(
          color: Theme.of(context).colorScheme.onTertiaryContainer,
        ),
        onChanged: (String? query) {
          if (query != null) {
            onQueryChanged(query);
          }
        },
        decoration: InputDecoration(
          icon: Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: Icon(
              Icons.search_outlined,
              color: Theme.of(context).colorScheme.onTertiaryContainer,
            ),
          ),
          hintText: 'Search', // TODO Translate
          border: InputBorder.none,
        ),
      ),
    );
  }
}