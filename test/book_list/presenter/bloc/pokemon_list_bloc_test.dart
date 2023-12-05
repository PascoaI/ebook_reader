import 'package:ebook_reader/features/books_list/domain/entities/book.dart';
import 'package:ebook_reader/features/books_list/domain/usecase/get_books_usecase.dart';
import 'package:ebook_reader/features/books_list/presenter/bloc/book_list_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

class GetBooksUseCaseMock extends Mock implements GetBooksUseCase {}

void main() async {
  late GetBooksUseCase useCase;
  late BookListBloc bloc;
  setUp(() {
    useCase = GetBooksUseCaseMock();
    bloc = BookListBloc(useCase);
  });

  group('book List Bloc', () {
    test('onLoadBooks should return list of books', () async {
      List<Book> list = [
        Book(1, '', '', '', '')
      ];

      when(useCase()).thenAnswer((_) async => list);

      expectLater(bloc.books.length, 0);

      bloc.onLoadBooks();

      expectLater(bloc.stream, emits(true));

      bloc.stream.listen((e) {
        expect(e, true);
        expect(bloc.books.length, 1);
      });
    });
  });

  tearDown(() {
    bloc.dispose();
  });
}
