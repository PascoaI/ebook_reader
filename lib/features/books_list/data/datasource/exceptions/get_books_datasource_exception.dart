class GetBooksDataSourceException implements Exception {
  String statusCode;
  String cause;
  GetBooksDataSourceException(this.statusCode,this.cause);

  String toString() => 'GetBooksDataSourceException[$statusCode]: $cause';
}
