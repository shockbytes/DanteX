import 'package:dantex/com.shockbytes.dante/data/authentication/authentication_repository.dart';
import 'package:dantex/com.shockbytes.dante/data/authentication/firebase_authentication_repository.dart';
import 'package:dantex/com.shockbytes.dante/data/book/book_repository.dart';
import 'package:dantex/com.shockbytes.dante/data/book/in_memory_book_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class RepositoryInjector {
  RepositoryInjector._();

  static setup() {
    _setupBookRepository();
    _setupAuthenticationRepository();
  }

  static _setupBookRepository() {
    Get.put<BookRepository>(
      InMemoryBookRepository(),
      permanent: true,
    );
  }
  static _setupAuthenticationRepository() {
    Get.put<AuthenticationRepository>(
      FirebaseAuthenticationRepository(
        FirebaseAuth.instance,
      ),
      permanent: true,
    );
  }

}
