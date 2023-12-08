import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../data/model/book_model.dart';
import '../../domain/entities/book.dart';
import '../bloc/book_list_bloc.dart';
import 'book_viewer.dart';


enum MenuItem { SAIR }

class BookList extends StatefulWidget {
  const BookList({Key? key}) : super(key: key);
  @override
  _BookListState createState() => _BookListState();
}

class _BookListState extends State<BookList> {
  var _bloc = GetIt.instance<BookListBloc>();
  late SharedPreferences _prefs;

  @override
  void initState() {
    _bloc.onLoadBooks();
    _initSharedPreferences();
    loadFavorites();
    super.initState();
  }

  Future<void> _initSharedPreferences() async {
    _prefs = await SharedPreferences.getInstance();
  }

  List<Book> favorites = [];

  Future<void> saveFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    final favoritesJson = jsonEncode(favorites);
    prefs.setString('favorites', favoritesJson);
  }

  Future<void> loadFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    final favoritesJson = prefs.getString('favorites');

    if (favoritesJson != null) {
      favorites = (jsonDecode(favoritesJson) as List<dynamic>)
          .map((item) => BookModel.fromJson(item))
          .toList();
    }
  }

  void _toggleFavorite(int bookId) {
    bool isFavorite = _prefs.getBool(bookId.toString()) ?? false;
    _prefs.setBool(bookId.toString(), !isFavorite);

    if (isFavorite) {
      favorites.removeWhere((book) => book.id == bookId);
    } else {
      favorites.add(_bloc.books.firstWhere((book) => book.id == bookId));
    }

    saveFavorites();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Estante de Ebooks'),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Livros'),
              Tab(text: 'Favoritos'),
            ],
          ),
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
        body: TabBarView(
          children: [
            _buildBooksGrid(), // Conteúdo para a aba 'Livros'
            _buildFavoritesGrid(), // Conteúdo para a aba 'Favoritos'
          ],
        ),
      ),
    );
  }

  Widget _buildBooksGrid() {
    return StreamBuilder(
      stream: _bloc.stream,
      builder: (context, snapshot) {
        return GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2
            , // 2 livros por linha
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
    );
  }

  Widget _buildFavoritesGrid() {
    List favorites = _bloc.books.where((book) {
      return _prefs.getBool(book.id.toString()) ?? false;
    }).toList();

    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 8.0,
        mainAxisSpacing: 8.0,
      ),
      itemCount: favorites.length,
      itemBuilder: (context, index) {
        Book _book = favorites[index];
        return _buildBooksItem(_book);
      },
    );
  }

  Widget _buildBooksItem(Book book) {

    bool isFavorite = _prefs.getBool(book.id.toString()) ?? false;
    return Card(
      child: Container(
        width: 100,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Stack(
              children: [
                ElevatedButton(
                  onPressed: () async {
                    await _downloadAndOpenBook(book.download_url, book.title);
                    print(book.download_url);
                    },
                  child: Container(
                    height: 120,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: NetworkImage(book.cover_url),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: 0.0,
                  right: 0.0,
                  child: InkWell(
                    onTap: () {
                      _toggleFavorite(book.id);
                    },
                    child: Icon(
                      isFavorite ? Icons.bookmark : Icons.bookmark_border,
                      color: Colors.orange,
                      size: 35.0,
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                book.title,
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
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
              style: const TextStyle(
                fontSize: 10.0,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _downloadAndOpenBook(String download_url, String title) async {
    try {
      if (!context.mounted) return;
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => BookViewerScreen(download_url, title),
        ),
      );
    } catch (e) {
      // Handle errors
      print('Erro ao baixar e abrir o livro: $e');
    }
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
