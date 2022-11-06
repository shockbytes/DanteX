double computePercentage(int current, int max) {
  if (current > max) {
    return 1.0;
  }

  return current / max;
}

String doublePercentageToString(double percentage) {
  return (percentage * 100).toInt().toString() + "%";
}
