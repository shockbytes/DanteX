import 'package:dantex/src/data/book/realm/realm_book.dart';
import 'package:realm/realm.dart';

class RealmHelper {
  void init() {
    print('reading books!');
    var config = Configuration.local(
      [
        RealmBook.schema,
        RealmBookLabel.schema,
        RealmPageRecord.schema,
      ],
      schemaVersion: 9,
    );
    var realm = Realm(config);
    realm.all<RealmBook>().forEach((RealmBook book) {
      print('----------');
      print(book.id);
      print(book.author);
      print(book.pageCount);
      print(book.subTitle);
      print(book.title);
      print('----------');
      print(book);
      print('----------');
    });
  }
}
