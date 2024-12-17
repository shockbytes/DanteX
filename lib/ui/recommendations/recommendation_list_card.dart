import 'package:dantex/models/book_recommendation.dart';
import 'package:flutter/material.dart';

class RecommendationListCard extends StatelessWidget {
  const RecommendationListCard({required this.recommendation, super.key});

  final BookRecommendation recommendation;

  @override
  Widget build(BuildContext context) {
    return Text(recommendation.suggestion.title);
  }
}
