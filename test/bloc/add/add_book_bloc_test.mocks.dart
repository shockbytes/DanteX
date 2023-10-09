// Mocks generated by Mockito 5.4.2 from annotations
// in dantex/test/bloc/add/add_book_bloc_test.dart.
// Do not manually edit this file.

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'dart:async' as _i7;

import 'package:dantex/src/core/book_core.dart' as _i9;
import 'package:dantex/src/data/book/book_repository.dart' as _i8;
import 'package:dantex/src/data/book/entity/book.dart' as _i2;
import 'package:dantex/src/data/book/entity/book_label.dart' as _i5;
import 'package:dantex/src/data/book/entity/book_state.dart' as _i4;
import 'package:dantex/src/data/bookdownload/book_downloader.dart' as _i6;
import 'package:dantex/src/data/bookdownload/entity/book_suggestion.dart'
    as _i3;
import 'package:mockito/mockito.dart' as _i1;

// ignore_for_file: type=lint
// ignore_for_file: avoid_redundant_argument_values
// ignore_for_file: avoid_setters_without_getters
// ignore_for_file: comment_references
// ignore_for_file: implementation_imports
// ignore_for_file: invalid_use_of_visible_for_testing_member
// ignore_for_file: prefer_const_constructors
// ignore_for_file: unnecessary_parenthesis
// ignore_for_file: camel_case_types
// ignore_for_file: subtype_of_sealed_class

class _FakeBook_0 extends _i1.SmartFake implements _i2.Book {
  _FakeBook_0(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

class _FakeBookSuggestion_1 extends _i1.SmartFake
    implements _i3.BookSuggestion {
  _FakeBookSuggestion_1(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

/// A class which mocks [Book].
///
/// See the documentation for Mockito's code generation for more information.
class MockBook extends _i1.Mock implements _i2.Book {
  MockBook() {
    _i1.throwOnMissingStub(this);
  }

  @override
  String get id => (super.noSuchMethod(
        Invocation.getter(#id),
        returnValue: '',
      ) as String);

  @override
  String get title => (super.noSuchMethod(
        Invocation.getter(#title),
        returnValue: '',
      ) as String);

  @override
  String get subTitle => (super.noSuchMethod(
        Invocation.getter(#subTitle),
        returnValue: '',
      ) as String);

  @override
  String get author => (super.noSuchMethod(
        Invocation.getter(#author),
        returnValue: '',
      ) as String);

  @override
  _i4.BookState get state => (super.noSuchMethod(
        Invocation.getter(#state),
        returnValue: _i4.BookState.READ_LATER,
      ) as _i4.BookState);

  @override
  int get pageCount => (super.noSuchMethod(
        Invocation.getter(#pageCount),
        returnValue: 0,
      ) as int);

  @override
  int get currentPage => (super.noSuchMethod(
        Invocation.getter(#currentPage),
        returnValue: 0,
      ) as int);

  @override
  String get publishedDate => (super.noSuchMethod(
        Invocation.getter(#publishedDate),
        returnValue: '',
      ) as String);

  @override
  int get position => (super.noSuchMethod(
        Invocation.getter(#position),
        returnValue: 0,
      ) as int);

  @override
  String get isbn => (super.noSuchMethod(
        Invocation.getter(#isbn),
        returnValue: '',
      ) as String);

  @override
  int get startDate => (super.noSuchMethod(
        Invocation.getter(#startDate),
        returnValue: 0,
      ) as int);

  @override
  int get endDate => (super.noSuchMethod(
        Invocation.getter(#endDate),
        returnValue: 0,
      ) as int);

  @override
  int get wishlistDate => (super.noSuchMethod(
        Invocation.getter(#wishlistDate),
        returnValue: 0,
      ) as int);

  @override
  String get language => (super.noSuchMethod(
        Invocation.getter(#language),
        returnValue: '',
      ) as String);

  @override
  int get rating => (super.noSuchMethod(
        Invocation.getter(#rating),
        returnValue: 0,
      ) as int);

  @override
  List<_i5.BookLabel> get labels => (super.noSuchMethod(
        Invocation.getter(#labels),
        returnValue: <_i5.BookLabel>[],
      ) as List<_i5.BookLabel>);

  @override
  Map<String, dynamic> toMap() => (super.noSuchMethod(
        Invocation.method(
          #toMap,
          [],
        ),
        returnValue: <String, dynamic>{},
      ) as Map<String, dynamic>);

  @override
  _i2.Book copyWith({
    String? newId,
    int? newCurrentPage,
    _i4.BookState? newState,
  }) =>
      (super.noSuchMethod(
        Invocation.method(
          #copyWith,
          [],
          {
            #newId: newId,
            #newCurrentPage: newCurrentPage,
            #newState: newState,
          },
        ),
        returnValue: _FakeBook_0(
          this,
          Invocation.method(
            #copyWith,
            [],
            {
              #newId: newId,
              #newCurrentPage: newCurrentPage,
              #newState: newState,
            },
          ),
        ),
      ) as _i2.Book);
}

/// A class which mocks [BookDownloader].
///
/// See the documentation for Mockito's code generation for more information.
class MockBookDownloader extends _i1.Mock implements _i6.BookDownloader {
  MockBookDownloader() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i7.Future<_i3.BookSuggestion> downloadBook(String? query) =>
      (super.noSuchMethod(
        Invocation.method(
          #downloadBook,
          [query],
        ),
        returnValue: _i7.Future<_i3.BookSuggestion>.value(_FakeBookSuggestion_1(
          this,
          Invocation.method(
            #downloadBook,
            [query],
          ),
        )),
      ) as _i7.Future<_i3.BookSuggestion>);
}

/// A class which mocks [BookRepository].
///
/// See the documentation for Mockito's code generation for more information.
class MockBookRepository extends _i1.Mock implements _i8.BookRepository {
  MockBookRepository() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i7.Stream<List<_i2.Book>> getBooksForState(_i4.BookState? state) =>
      (super.noSuchMethod(
        Invocation.method(
          #getBooksForState,
          [state],
        ),
        returnValue: _i7.Stream<List<_i2.Book>>.empty(),
      ) as _i7.Stream<List<_i2.Book>>);

  @override
  _i7.Stream<List<_i2.Book>> listenAllBooks() => (super.noSuchMethod(
        Invocation.method(
          #getAllBooks,
          [],
        ),
        returnValue: _i7.Stream<List<_i2.Book>>.empty(),
      ) as _i7.Stream<List<_i2.Book>>);

  @override
  _i7.Future<_i2.Book> getBook(String? id) => (super.noSuchMethod(
        Invocation.method(
          #getBook,
          [id],
        ),
        returnValue: _i7.Future<_i2.Book>.value(_FakeBook_0(
          this,
          Invocation.method(
            #getBook,
            [id],
          ),
        )),
      ) as _i7.Future<_i2.Book>);

  @override
  _i7.Future<void> create(_i2.Book? book) => (super.noSuchMethod(
        Invocation.method(
          #create,
          [book],
        ),
        returnValue: _i7.Future<void>.value(),
        returnValueForMissingStub: _i7.Future<void>.value(),
      ) as _i7.Future<void>);

  @override
  _i7.Future<void> update(_i2.Book? book) => (super.noSuchMethod(
        Invocation.method(
          #update,
          [book],
        ),
        returnValue: _i7.Future<void>.value(),
        returnValueForMissingStub: _i7.Future<void>.value(),
      ) as _i7.Future<void>);

  @override
  _i7.Future<void> delete(String? id) => (super.noSuchMethod(
        Invocation.method(
          #delete,
          [id],
        ),
        returnValue: _i7.Future<void>.value(),
        returnValueForMissingStub: _i7.Future<void>.value(),
      ) as _i7.Future<void>);

  @override
  _i7.Future<void> updateCurrentPage(
    String? bookId,
    int? currentPage,
  ) =>
      (super.noSuchMethod(
        Invocation.method(
          #updateCurrentPage,
          [
            bookId,
            currentPage,
          ],
        ),
        returnValue: _i7.Future<void>.value(),
        returnValueForMissingStub: _i7.Future<void>.value(),
      ) as _i7.Future<void>);

  @override
  _i7.Stream<List<_i2.Book>> search(_i9.SearchCriteria? criteria) =>
      (super.noSuchMethod(
        Invocation.method(
          #search,
          [criteria],
        ),
        returnValue: _i7.Stream<List<_i2.Book>>.empty(),
      ) as _i7.Stream<List<_i2.Book>>);
}
