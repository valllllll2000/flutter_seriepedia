import '../entities/serie.dart';

abstract class FavoritesDatasource {

  Future<void> toggleFavorite(Serie serie);

  Future<bool> isSerieFavorite(int serieId);

  Future<Set<Serie>> loadFavoriteSeries();
}
