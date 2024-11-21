import 'package:cinemapedia/domain/datasources/series_datasource.dart';
import 'package:cinemapedia/domain/entities/serie.dart';
import 'package:cinemapedia/domain/repositories/serie_repository.dart';

class SeriesRepositoryImpl implements SeriesRepository {
  final SeriesDatasource datasource;

  SeriesRepositoryImpl({required this.datasource});

  @override
  Future<List<Serie>> getPopularList(int page) {
    return datasource.getPopularList(page: page);
  }

  @override
  Future<Serie?> getSerie(String serieId) {
    return datasource.getSerie(serieId);
  }

  @override
  Future<List<Serie>> getSearchList(int page, String query) {
    return datasource.getSearchList(page, query);
  }
}
