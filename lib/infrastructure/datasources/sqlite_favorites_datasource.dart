import 'package:cinemapedia/domain/datasources/favorites_datasource.dart';
import 'package:cinemapedia/domain/entities/serie.dart';
import 'package:cinemapedia/infrastructure/mappers/serie_mapper.dart';
import 'package:cinemapedia/infrastructure/services/database_service.dart';

class SqliteFavoritesDatasource extends FavoritesDatasource {
  final DatabaseService databaseService;

  SqliteFavoritesDatasource(this.databaseService);

  @override
  Future<bool> isSerieFavorite(int serieId) {
    return databaseService.isSerieFavorite(serieId);
  }

  @override
  Future<Set<Serie>> loadFavoriteSeries() async {
    final seriesMap = await databaseService.loadFavoriteSeries();
    return seriesMap.map((map) => SerieMapper.fromMapToSerie(map)).toSet();
  }

  @override
  Future<void> toggleFavorite(Serie serie) {
    return databaseService.toggleFavorite(serie.toMap());
  }
}
