import '../entities/serie.dart';

abstract class SeriesDatasource {
  Future<List<Serie>> getPopularList({int page});
}
