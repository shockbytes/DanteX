
import 'package:dantex/com.shockbytes.dante/data/book/entity/book_label.dart';

abstract class BookLabelRepository {

  Stream<List<BookLabel>> getBookLabels();

  Future<void> createBookLabel(BookLabel label);

  Future<void> deleteBookLabel(BookLabel label);
}