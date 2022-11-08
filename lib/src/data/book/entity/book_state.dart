enum BookState {
  READ_LATER,
  READING,
  READ,
  WISHLIST,
}

extension BookStateExtension on BookState {

  static BookState fromString(
    String? name, {
    BookState defaultValue = BookState.READ_LATER,
  }) {

    switch (name) {
      case 'READ_LATER':
        return BookState.READ_LATER;
      case 'READING':
        return BookState.READING;
      case 'READ':
        return BookState.READ;
      case 'WISHLIST':
        return BookState.WISHLIST;
      default:
        return defaultValue;
    }
  }
}
