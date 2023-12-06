class GetBooksDataSourceException implements Exception {
  String statusCode;
  String cause;
  GetBooksDataSourceException(this.statusCode,this.cause);

  @override
  String toString() => 'GetBooksDataSourceException[$statusCode]: $cause';
}
