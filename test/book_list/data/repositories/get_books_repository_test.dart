import 'package:ebook_reader/base/data_source.dart';
import 'package:ebook_reader/features/books_list/data/repositories/get_books_repository_impl.dart';
import 'package:ebook_reader/features/books_list/domain/entities/book.dart';
import 'package:ebook_reader/features/books_list/domain/repositories/get_books_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

class DataSourceMock extends Mock implements DataSource {}

main() {
  GetBooksRepository? getBooksRepository;
  DataSource? dataSourceMock;
  setUp(() {
    dataSourceMock = DataSourceMock();
    getBooksRepository = GetBooksRepositoryImpl(dataSourceMock!);
  });

  group('Get books Repository', () {
    test('Use case should return a list of books', () async {
      List<Book> list = [
        Book(1, '', '' , '', '')
      ];

      when(dataSourceMock!(any)).thenAnswer(((_) async => list));

      expectLater(await getBooksRepository!(), list);
      expectLater(await getBooksRepository!(), isA<List<Book>>());
    });
  });
}
