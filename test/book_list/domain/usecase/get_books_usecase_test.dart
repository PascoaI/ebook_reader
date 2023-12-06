import 'package:ebook_reader/features/books_list/domain/entities/book.dart';
import 'package:ebook_reader/features/books_list/domain/repositories/get_books_repository.dart';
import 'package:ebook_reader/features/books_list/domain/usecase/get_books_usecase.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

class GetBooksRepositoryMock extends Mock
    implements GetBooksRepository {}

main() {
  GetBooksRepository? repoMock;
  GetBooksUseCase? getBooksUseCase;
  setUp(() {
    repoMock = GetBooksRepositoryMock();
    getBooksUseCase = GetBooksUseCaseImpl(repoMock!);
  });

  group('Get Books UseCase', () {
    test('Use case should return a list of Books', () async {
      List<Book> list = [
        Book(1, '', '', '', '')
      ];

      when(repoMock!()).thenAnswer((_) async => list);

      expectLater(await getBooksUseCase!(), list);
      expectLater(await getBooksUseCase!(), isA<List<Book>>());
    });
  });
}
