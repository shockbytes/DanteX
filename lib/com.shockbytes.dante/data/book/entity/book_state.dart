enum BookState {
  READ_LATER,
  READING,
  READ,
  WISHLIST,
}

extension BookStateExtension on BookState {
  // TODO
  String fromString(
    String? name, {
    BookState defaultValue = BookState.READ_LATER,
  }) {
    return '';
  }
}
