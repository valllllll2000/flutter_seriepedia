import '../entities/serie.dart';

abstract class SeriesDatasource {
  Future<List<Serie>> getPopularList({int page});
  Future<Serie?> getSerie(String serieId);
}
