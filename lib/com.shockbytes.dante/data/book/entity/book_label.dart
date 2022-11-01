class BookLabel {
  final String bookId;
  final String title;

  /**
   * This private field is required to ensure backwards compatibility with already
   * existing backups. Callers use now [labelHexColor] of type [HexColor] instead
   * of working with the raw string.
   */
  final String hexColor;

  BookLabel({
    required this.bookId,
    required this.title,
    required this.hexColor,
  });
}
