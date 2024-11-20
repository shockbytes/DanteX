import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:native_dio_adapter/native_dio_adapter.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'client.g.dart';

@riverpod
Dio googleBooksClient(Ref ref) {
  final dioClient = Dio(
    BaseOptions(baseUrl: 'https://www.googleapis.com/books/v1'),
  )..httpClientAdapter = NativeAdapter();

  return dioClient;
}
