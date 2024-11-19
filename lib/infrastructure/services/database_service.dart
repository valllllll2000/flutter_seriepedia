abstract class DatabaseService {
  final String path;

  DatabaseService({required this.path});

  Future<bool> isSerieFavorite(int serieId);

  Future<List<Map<String, dynamic>>> loadFavoriteSeries();

  Future<void> toggleFavorite(Map<String, dynamic> serie);
}
