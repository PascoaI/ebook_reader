import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';

import '../features/books_list/data/datasource/get_books_data_source.dart';
import '../features/books_list/data/repositories/get_books_repository_impl.dart';
import '../features/books_list/domain/repositories/get_books_repository.dart';
import '../features/books_list/domain/usecase/get_books_usecase.dart';
import '../features/books_list/presenter/bloc/book_list_bloc.dart';

GetIt _l = GetIt.instance;

void setupDependenceInjection() {
  setup();
  setupBooks();
}

void setup() async {
  _l.registerFactory<Dio>(() => Dio());
}

void setupBooks() async {
  _l.registerFactory<GetBooksDataSource>(
      () => GetBooksDataSource(_l<Dio>()));

  _l.registerFactory<GetBooksRepository>(
      () => GetBooksRepositoryImpl(_l<GetBooksDataSource>()));

  _l.registerFactory<GetBooksUseCase>(
      () => GetBooksUseCaseImpl(_l<GetBooksRepository>()));

  _l.registerFactory<BookListBloc>(
      () => BookListBloc(_l<GetBooksUseCase>()));
}
