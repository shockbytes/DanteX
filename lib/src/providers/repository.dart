import 'package:dantex/src/data/book/book_repository.dart';
import 'package:dantex/src/data/book/firebase_book_repository.dart';
import 'package:dantex/src/providers/authentication.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'repository.g.dart';

@riverpod
BookRepository bookRepository(BookRepositoryRef ref) => FirebaseBookRepository(
      ref.read(firebaseAuthProvider),
      ref.read(firebaseDatabaseProvider),
    );
