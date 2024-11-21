import '../entities/serie.dart';

abstract class SeriesRepository {
  Future<List<Serie>> getPopularList(int page);
  Future<List<Serie>> getSearchList(int page, String query);
  Future<Serie?> getSerie(String serieId);
}