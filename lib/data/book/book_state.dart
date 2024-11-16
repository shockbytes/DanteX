enum BookState {
  readLater,
  reading,
  read,
  wishlist,
}

extension BookStateExtension on String {
  BookState toBookState({
    BookState defaultValue = BookState.readLater,
  }) {
    switch (this) {
      case 'readLater':
        return BookState.readLater;
      case 'reading':
        return BookState.reading;
      case 'read':
        return BookState.read;
      case 'wishlist':
        return BookState.wishlist;
      default:
        return defaultValue;
    }
  }
}
