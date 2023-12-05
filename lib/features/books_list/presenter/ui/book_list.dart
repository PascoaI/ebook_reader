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
            return ListView.builder(
                itemCount: _bloc.books.length,
                itemBuilder: (context, position) {
                  Book _book = _bloc.books.elementAt(position);

                  // return _buildBooksItem(_book, position);
                });
          }),
    );
  }

  Widget _buildBooksItem(Book book, int position) {
  return Padding(
      padding: const EdgeInsets.all(8.0),
        child: Card(
        shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
    )
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
