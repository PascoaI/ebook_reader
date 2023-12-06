import 'dart:convert';


import 'package:dio/dio.dart';
import 'package:ebook_reader/base/data_source.dart';
import 'package:ebook_reader/features/books_list/data/datasource/exceptions/get_books_datasource_exception.dart';
import 'package:ebook_reader/features/books_list/data/datasource/get_books_data_source.dart';
import 'package:ebook_reader/features/books_list/data/model/book_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class HttpClientAdapterMock extends Mock implements HttpClientAdapter {}

class RequestOptionsFake extends Fake implements RequestOptions {}

void main() {
  Dio dio;
  late HttpClientAdapter adapterMock;
  var response;
  late DataSource dataSource;

  setUpAll(() {
    registerFallbackValue(RequestOptionsFake());
    dio = Dio();
    adapterMock = HttpClientAdapterMock();
    dio.httpClientAdapter = adapterMock;
    dataSource = GetBooksDataSource(dio);

    response = {
      [
        {
          'id': 1,
          'title': 'A',
          'author': 'B',
          'cover_url': 'C',
          'download_url': 'D'
        }
      ]
    };
  });

  test('Response status shoud be 200', () async {
    when(() => adapterMock.fetch(any(), any(), any())).thenAnswer(
        (_) async => ResponseBody.fromString(json.encode(response), 200));

    var list = await dataSource((json) =>BookModel.fromJson(json))!;
    expect(list[0].title, 'B');
  });

  test('status code 500 should throws BadRequestException', () async {
    when(() => adapterMock.fetch(any(), any(), any())).thenAnswer(
        (_) async => ResponseBody.fromString(json.encode(response), 500));
    try {
      await dataSource((json) => BookModel.fromJson(json))!;
    } catch (_) {
      expect(_, isA<GetBooksDataSourceException>());
    }
  });
}
