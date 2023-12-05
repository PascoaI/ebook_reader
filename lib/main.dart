import 'package:flutter/material.dart';
import 'di/injection.dart';
import 'features/books_list/presenter/ui/book_list.dart';


void main() {
  setupDependenceInjection();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
        title: 'eBook Reader',
        theme: ThemeData(
          primarySwatch: Colors.grey,
        ),
        home: const BookList(key: Key('LIST-PAGE')));
  }
}
