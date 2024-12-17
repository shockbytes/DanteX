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
        // If we haven't matched one of the above, we have a legacy book state.
        return convertLegacyBookState(this, defaultValue: defaultValue);
    }
  }
}

BookState convertLegacyBookState(
  String legacyState, {
  BookState defaultValue = BookState.readLater,
}) {
  switch (legacyState) {
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
