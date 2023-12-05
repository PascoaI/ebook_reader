import 'package:ebook_reader/features/books_list/data/model/book_model.dart';
import 'package:flutter_test/flutter_test.dart';

main() {
  var response;

  BookModel? bookModel;

  setUpAll(() {
    response = {
      'id': 1,
      'title': 'A',
      'author': 'B',
      'cover_url': 'C',
      'download_url': 'D'
    };

    bookModel = BookModel.fromJson(response);
  });

  group('Book json parse', () {
    test('BookModel should be instance of BookModel', () {
      expect(bookModel, isA<BookModel>());
    });

    test('id should be 1', () {
      expect(bookModel!.id, 1);
    });

    test('title should be A', () {
      expect(bookModel!.title, 'A');
    });

    test('author should be B', () {
      expect(bookModel!.author, 'B');
    });

    test('score should be C', () {
      expect(bookModel!.cover_url, 'C');
    });

    test('score should be C', () {
      expect(bookModel!.download_url, 'D');
    });

  });
}
