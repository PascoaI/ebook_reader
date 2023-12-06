import 'dart:convert';
import 'package:dio/dio.dart';
import '../../../../base/Endpoint.dart';
import '../../../../base/data_source.dart';
import '../model/book_model.dart';
import 'exceptions/get_books_datasource_exception.dart';
class GetBooksDataSource implements DataSource {

  final Dio _dio;
  GetBooksDataSource(this._dio);

  @override
  Future call(FromJson? fromJson) async {
    String url = EndPoint.URL;

    try {
      var response = await _dio.get<String>(url);
      List<dynamic> _jsonList = json.decode(response.data!) as List;

      var list = List<BookModel>.from(
          _jsonList.map((i) => fromJson!(i)).toList());

      return list;
    } on DioError catch (e) {
      throw GetBooksDataSourceException('', e.message);
    }
  }
}