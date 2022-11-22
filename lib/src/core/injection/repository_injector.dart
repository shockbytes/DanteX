import 'package:dantex/src/core/injection/dependency_injector.dart';
import 'package:dantex/src/data/authentication/authentication_repository.dart';
import 'package:dantex/src/data/authentication/firebase_authentication_repository.dart';
import 'package:dantex/src/data/book/book_repository.dart';
import 'package:dantex/src/data/book/firebase_book_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:get/get.dart';

class RepositoryInjector {
  RepositoryInjector._();

  static setup() {
    _setupBookRepository();
    _setupAuthenticationRepository();
  }

  static _setupBookRepository() {
    Get.put<BookRepository>(
      FirebaseBookRepository(
        DependencyInjector.get<FirebaseAuth>(),
        DependencyInjector.get<FirebaseDatabase>(),
      ),
      permanent: true,
    );
  }

  static _setupAuthenticationRepository() {
    Get.put<AuthenticationRepository>(
      FirebaseAuthenticationRepository(DependencyInjector.get<FirebaseAuth>()),
      permanent: true,
    );
  }
}
