import 'package:dantex/ui/recommendations/recommendations_list.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class RecommendationsScreen extends StatelessWidget {
  const RecommendationsScreen({super.key});

  static String get routeName => 'recommendations';
  static String get routeLocation => '/$routeName';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('recommendations.title').tr(),
      ),
      body: const RecommendationsList(),
    );
  }
}
