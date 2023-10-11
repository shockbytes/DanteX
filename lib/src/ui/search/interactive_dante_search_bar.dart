import 'package:flutter/material.dart';

class InteractiveDanteSearchBar extends StatelessWidget {
  final Function(String query) onQueryChanged;

  const InteractiveDanteSearchBar({
    Key? key,
    required this.onQueryChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
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
          icon: Icon(
            Icons.search_outlined,
            color: Theme.of(context).colorScheme.onTertiaryContainer,
          ),
          hintText: 'Search', // TODO Translate
          border: InputBorder.none,
        ),
      ),
    );
  }
}
