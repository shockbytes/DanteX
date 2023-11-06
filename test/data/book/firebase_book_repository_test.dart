import 'package:dantex/src/data/book/entity/book.dart';
import 'package:dantex/src/data/book/entity/book_state.dart';
import 'package:dantex/src/data/book/firebase_book_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'firebase_book_repository_test.mocks.dart';

@GenerateMocks([
  FirebaseAuth,
  FirebaseDatabase,
  User,
  DatabaseReference,
])
void main() {
  test('Create book returns void on success', () async {
    final fbAuth = MockFirebaseAuth();
    final fbDb = MockFirebaseDatabase();
    final user = MockUser();
    final oldDbRef = MockDatabaseReference();
    final newDbRef = MockDatabaseReference();

    final fbAuthRepo = FirebaseBookRepository(fbAuth, fbDb);
    final book = Book(
      id: 'id',
      title: 'title',
      subTitle: 'subTitle',
      author: 'author',
      state: BookState.reading,
      pageCount: 1,
      currentPage: 1,
      publishedDate: DateTime.now().toIso8601String(),
      position: 1,
      isbn: 'isbn',
      thumbnailAddress: 'thumbnailAddress',
      startDate: DateTime.now(),
      endDate: null,
      forLaterDate: DateTime.now().subtract(const Duration(days: 1)),
      language: 'language',
      rating: 1,
      notes: 'notes',
      summary: 'summary',
      labels: [],
    );

    when(user.uid).thenReturn('userId');
    when(fbAuth.currentUser).thenReturn(user);
    when(fbDb.ref('users/userId/books')).thenReturn(oldDbRef);
    when(oldDbRef.push()).thenReturn(newDbRef);
    when(newDbRef.key).thenReturn('bookKey');

    await fbAuthRepo.create(book);
    verify(fbAuth.currentUser).called(1);
    verify(fbDb.ref('users/userId/books')).called(1);
    verify(oldDbRef.push()).called(1);
    verify(newDbRef.key).called(1);
    verify(newDbRef.set(book.copyWith(id: 'bookKey').toJson())).called(1);
  });

  test('Delete book returns void on success', () async {
    final fbAuth = MockFirebaseAuth();
    final fbDb = MockFirebaseDatabase();
    final user = MockUser();
    final oldDbRef = MockDatabaseReference();
    final newDbRef = MockDatabaseReference();

    final fbAuthRepo = FirebaseBookRepository(fbAuth, fbDb);

    when(user.uid).thenReturn('userId');
    when(fbAuth.currentUser).thenReturn(user);
    when(fbDb.ref('users/userId/books')).thenReturn(oldDbRef);
    when(oldDbRef.child('bookId')).thenReturn(newDbRef);
    when(newDbRef.remove()).thenAnswer((_) async {});

    await fbAuthRepo.delete('bookId');
    verify(fbAuth.currentUser).called(1);
    verify(fbDb.ref('users/userId/books')).called(1);
    verify(oldDbRef.child('bookId')).called(1);
    verify(newDbRef.remove()).called(1);
  });
}
