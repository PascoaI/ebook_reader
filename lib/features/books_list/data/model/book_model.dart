import '../../../../base/base_model.dart';
import '../../domain/entities/book.dart';

class BookModel extends Book implements BaseModel {
  BookModel(id, title, author, cover_url, download_url)
      : super(id, title, author, cover_url, download_url);

  factory BookModel.fromJson(Map json) {
    BookModel model = BookModel(
        json['id'] ?? '',
        json['title'] ?? '',
        json['author'] ?? '',
        json['cover_url'] ?? '',
        json['download_url'] ?? '');

    return model;
  }

  @override
  toMap() {
    var map = Map<String, dynamic>();

    map['id'] = id;
    map['title'] = title;
    map['author'] = author;
    map['cover_url'] = cover_url;
    map['download_url'] = download_url;

    return map;
  }
}