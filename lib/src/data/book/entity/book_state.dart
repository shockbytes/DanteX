enum BookState {
  readLater,
  reading,
  read,
  wishlist,
}

extension BookStateExtension on BookState {
  static BookState fromString(
    String? name, {
    BookState defaultValue = BookState.readLater,
  }) {
    switch (name) {
      case 'READ_LATER':
        return BookState.readLater;
      case 'READING':
        return BookState.reading;
      case 'READ':
        return BookState.read;
      case 'WISHLIST':
        return BookState.wishlist;
      default:
        return defaultValue;
    }
  }
}
