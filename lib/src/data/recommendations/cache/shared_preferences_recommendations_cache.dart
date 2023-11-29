import 'dart:convert';

import 'package:dantex/src/data/recommendations/book_recommendation.dart';
import 'package:dantex/src/data/recommendations/cache/recommendations_cache.dart';
import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesRecommendationsCache extends RecommendationsCache {
  final SharedPreferences _sp;
  final Duration _ttl;
  final Logger _logger;

  final String _lastFetchedCacheKey = 'recommendations_cache_last_fetched';
  final String _contentCacheKey = 'recommendations_cache';

  SharedPreferencesRecommendationsCache(
    this._sp,
    this._logger, {
    required Duration ttl,
  }) : _ttl = ttl;

  @override
  Future<List<BookRecommendation>?> get() async {
    if (_isDataOutdated()) {
      _logger.d('Data is already outdated!');
      return null;
    }

    return _get();
  }

  List<BookRecommendation>? _get() {
    final String? data = _sp.getString(_contentCacheKey);
    if (data == null) {
      return null;
    }

    return jsonDecode(data);
  }

  @override
  Future<void> put(List<BookRecommendation> content) {
    return _put(content).then(
      (value) => _saveFetchDate(),
    );
  }

  Future<void> _put(List<BookRecommendation> content) async {
    await _sp.setString(_contentCacheKey, jsonEncode(content));
  }

  bool _isDataOutdated() {
    final DateTime? lastFetched = _getLastFetchedDateTime();
    // Date is "outdated", when never fetched => This indicates that data should
    // be loaded from API.
    if (lastFetched == null) {
      _logger.d('No value for lastFetched.');
      return false;
    }

    return lastFetched.add(_ttl).isBefore(DateTime.now());
  }

  DateTime? _getLastFetchedDateTime() {
    final String? fetchedDate = _sp.getString(_lastFetchedCacheKey);
    return DateTime.tryParse(fetchedDate ?? '');
  }

  Future<void> _saveFetchDate() async {
    final DateTime now = DateTime.now();
    await _sp.setString(_lastFetchedCacheKey, now.toIso8601String());
  }

  @override
  DateTime cacheValidUntil() {
    final DateTime lastFetched = _getLastFetchedDateTime() ?? DateTime.now();
    return lastFetched.add(_ttl);
  }
}
