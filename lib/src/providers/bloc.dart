import 'package:dantex/src/bloc/add/add_book_bloc.dart';
import 'package:dantex/src/bloc/auth/auth_bloc.dart';
import 'package:dantex/src/bloc/main/book_state_bloc.dart';
import 'package:dantex/src/providers/authentication.dart';
import 'package:dantex/src/providers/repository.dart';
import 'package:dantex/src/providers/service.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'bloc.g.dart';

@riverpod
AuthBloc authBloc(AuthBlocRef ref) => AuthBloc(
      ref.read(authenticationRepositoryProvider),
    );

@riverpod
BookStateBloc bookStateBloc(BookStateBlocRef ref) => BookStateBloc(
      ref.read(bookRepositoryProvider),
    );

@riverpod
AddBookBloc addBookBloc(AddBookBlocRef ref) => AddBookBloc(
      ref.read(bookDownloaderProvider),
      ref.read(bookRepositoryProvider),
    );
