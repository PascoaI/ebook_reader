import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:get_it/get_it.dart';

import '../../domain/entities/book.dart';
import '../bloc/book_list_bloc.dart';
enum MenuItem { SAIR }

class BookList extends StatefulWidget {
  const BookList({Key? key}) : super(key: key);
  @override
  _BookListState createState() => _BookListState();
}

class _BookListState extends State<BookList> {
  var _bloc = GetIt.instance<BookListBloc>();

  @override
  void initState() {
    _bloc.onLoadBooks();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Books List'),
        actions: <Widget>[
          PopupMenuButton<MenuItem>(
            onSelected: onSelectedItem,
            itemBuilder: (BuildContext context) => <PopupMenuItem<MenuItem>>[
              const PopupMenuItem<MenuItem>(
                value: MenuItem.SAIR,
                child: Text('Sair'),
              ),
            ],
          )
        ],
      ),
      body: StreamBuilder(
        stream: _bloc.stream,
        builder: (context, snapshot) {
          return GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2, // livros por linha
              crossAxisSpacing: 8.0,
              mainAxisSpacing: 8.0,
            ),
            itemCount: _bloc.books.length,
            itemBuilder: (context, position) {
              Book _book = _bloc.books.elementAt(position);

              return _buildBooksItem(_book);
            },
          );
        },
      ),
    );
  }

  Widget _buildBooksItem(Book book) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Container(
        width: 100,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              height: 120,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: NetworkImage(book.cover_url),
                  fit: BoxFit.cover,
                ),
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                book.title,
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 12.0,
                ),
              ),
            ),
            Text(
              book.author,
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 10.0,
              ),
            ),
          ],
        ),
      ),
    );
  }



  void onSelectedItem(MenuItem value) async {
    switch (value) {
      case MenuItem.SAIR:
        {
          SystemNavigator.pop();
          break;
        }
    }
  }
}
