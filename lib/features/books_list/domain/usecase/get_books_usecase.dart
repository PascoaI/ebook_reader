import '../entities/book.dart';
import '../repositories/get_books_repository.dart';

abstract class GetBooksUseCase {
  call();
}

class GetBooksUseCaseImpl implements GetBooksUseCase {
  final GetBooksRepository repository;

  GetBooksUseCaseImpl(this.repository);

  @override
  Future<List<Book>> call() async => await repository();
}
