import 'package:cinemapedia/domain/datasources/TVDatasource.dart';
import 'package:cinemapedia/domain/entities/serie.dart';
import 'package:cinemapedia/domain/repositories/serie_repository.dart';

class TVRepositoryImpl implements TVRepository {
  final SeriesDatasource datasource;

  TVRepositoryImpl({required this.datasource});

  @override
  Future<List<Serie>> getPopularList(int page) {
    return datasource.getPopularList(page: page);
  }
}
