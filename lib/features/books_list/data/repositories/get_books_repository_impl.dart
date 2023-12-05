
import '../../../../base/data_source.dart';
import '../../domain/entities/book.dart';
import '../../domain/repositories/get_books_repository.dart';
import '../model/book_model.dart';

class GetBooksRepositoryImpl implements GetBooksRepository {
  final DataSource _dataSource;

  GetBooksRepositoryImpl(this._dataSource);

  @override
  Future<List<Book>> call() async {
    return await _dataSource((json) => BookModel.fromJson(json));
  }
}
