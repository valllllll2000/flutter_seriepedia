import '../entities/serie.dart';

abstract class SeriesRepository {
  Future<List<Serie>> getPopularList(int page);
  Future<Serie?> getSerie(String serieId);
}