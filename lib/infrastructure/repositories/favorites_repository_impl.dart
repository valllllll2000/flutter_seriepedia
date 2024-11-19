import 'package:cinemapedia/domain/datasources/favorites_datasource.dart';
import 'package:cinemapedia/domain/entities/serie.dart';

import '../../domain/repositories/favorites_repository.dart';

class FavoritesRepositoryImpl extends FavoritesRepository {
  final FavoritesDatasource datasource;

  FavoritesRepositoryImpl(this.datasource);

  @override
  Future<bool> isSerieFavorite(int serieId) {
    return datasource.isSerieFavorite(serieId);
  }

  @override
  Future<Set<Serie>> loadFavoriteSeries() {
    return datasource.loadFavoriteSeries();
  }

  @override
  Future<void> toggleFavorite(Serie serie) {
    return datasource.toggleFavorite(serie);
  }
}
