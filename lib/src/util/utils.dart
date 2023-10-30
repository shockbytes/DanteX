double computePercentage(int current, int max) {
  // TODO: Check this logic here.
  if (max == 0) {
    return 0.0;
  }
  if (current > max) {
    return 1.0;
  }

  return current / max;
}

String doublePercentageToString(double percentage) {
  return '${(percentage * 100).toInt()}%';
}

extension StringExtensions on String {
  String removeBrackets() {
    return replaceAll('(', '').replaceAll(')', '');
  }
}

String? encodeQueryParameters(Map<String, String> params) {
  return params.entries
      .map(
        (MapEntry<String, String> e) =>
            '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value)}',
      )
      .join('&');
}
