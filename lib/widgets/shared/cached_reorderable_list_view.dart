import 'package:flutter/material.dart';

typedef ListItemWidgetBuilder<T> = Widget Function(
  BuildContext context,
  T item,
);

/// Helper class that wraps a [ReorderableListView] and caches the list to
/// prevent flickering when the list is reordered asynchronously.
class CachedReorderableListView<T> extends StatefulWidget {
  const CachedReorderableListView({
    required this.list,
    required this.itemBuilder,
    required this.onReorder,
    this.proxyDecorator,
    this.header,
    super.key,
  });

  final List<T> list;
  final ListItemWidgetBuilder<T> itemBuilder;
  final ReorderCallback onReorder;
  final ReorderItemProxyDecorator? proxyDecorator;
  final Widget? header;

  @override
  CachedReorderableListViewState<T> createState() =>
      CachedReorderableListViewState<T>();
}

class CachedReorderableListViewState<T>
    extends State<CachedReorderableListView<T>> {
  late List<T> list;

  @override
  void initState() {
    super.initState();
    list = [...widget.list];
  }

  @override
  void didUpdateWidget(covariant CachedReorderableListView<T> oldWidget) {
    if (widget.list != oldWidget.list) {
      list = [...widget.list];
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return ReorderableListView.builder(
      header: widget.header,
      itemCount: list.length,
      proxyDecorator: widget.proxyDecorator,
      itemBuilder: (context, index) => widget.itemBuilder(context, list[index]),
      onReorder: (oldIndex, newIndex) {
        setState(() {
          if (oldIndex < newIndex) {
            newIndex -= 1;
          }
          final item = list.removeAt(oldIndex);
          list.insert(newIndex, item);
        });
        widget.onReorder(oldIndex, newIndex);
      },
    );
  }
}
