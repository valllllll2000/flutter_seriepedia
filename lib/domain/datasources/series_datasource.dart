import '../entities/serie.dart';

abstract class SeriesDatasource {
  Future<List<Serie>> getPopularList({int page});
  Future<Serie?> getSerie(String serieId);

  Future<List<Serie>> getSearchList(int page, String query);
}
