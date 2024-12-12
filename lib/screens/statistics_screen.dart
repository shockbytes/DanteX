import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class StatisticsScreen extends StatelessWidget {
  const StatisticsScreen({super.key});

  static String routeName = 'statistics';
  static String routeLocation = '/$routeName';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('statistics.title').tr(),
      ),
      body: Center(
        child: const Text('statistics.body').tr(),
      ),
    );
  }
}
