class PageRecord {
  final String bookId;
  final int fromPage;
  final int toPage;
  final int timestamp;

  PageRecord({
    required this.bookId,
    required this.fromPage,
    required this.toPage,
    required this.timestamp,
  });

  DateTime get dateTime => DateTime.fromMillisecondsSinceEpoch(timestamp);

  int get diffPages => toPage - fromPage;
}
