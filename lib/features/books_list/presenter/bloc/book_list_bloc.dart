import 'dart:async';

import '../../domain/usecase/get_books_usecase.dart';

class BookListBloc {
  final GetBooksUseCase usecase;
  BookListBloc(this.usecase);

  var _controller = StreamController.broadcast();
  Stream get stream => _controller.stream;

  var books = [];

  onLoadBooks() async {
    var list = await usecase();
    books.addAll(list);

    _controller.sink.add(true);
  }


  dispose() {
    _controller.close();
  }
}
