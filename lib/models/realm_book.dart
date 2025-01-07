import 'package:realm/realm.dart';

part 'realm_book.realm.dart';

@RealmModel()
class _RealmBook {
  @PrimaryKey()
  late int id;
  late String? title = '';
  late String? subTitle = '';
  late String? author = '';
  late int pageCount = 0;
  late String? publishedDate = '';
  late int position = 0;
  late String? isbn = '';
  late String? thumbnailAddress = '';
  late String? googleBooksLink = '';
  late int startDate = 0;
  late int endDate = 0;
  late int ordinalState = 0;
  late int wishlistDate = 0;
  late String? language = 'NA';
  late int rating = 0;
  late int currentPage = 0;
  late String? notes = '';
  late String? summary = '';
  late List<_RealmBookLabel> labels = [];
}

@RealmModel()
class _RealmBookLabel {
  late int bookId = -1;
  late String? title = '';
  late String? hexColor = '';
}

@RealmModel()
class _RealmPageRecord {
  @PrimaryKey()
  late String? recordId = ''; // of type "bookId-timestamp"
  late int bookId = -1;
  late int fromPage = 0;
  late int toPage = 0;
  late int timestamp = 0;
}
