import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class BookManagementPage extends StatefulWidget {
  const BookManagementPage({super.key});

  static String get routeName => 'management';
  static String get routeLocation => '/management';

  @override
  State<BookManagementPage> createState() => _BookManagementPageState();
}

class _BookManagementPageState extends State<BookManagementPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.surfaceContainerHighest,
        leading: BackButton(
          onPressed: () => context.pop(),
        ),
      ),
      body: const Text('Book Management Page'),
    );
  }
}
