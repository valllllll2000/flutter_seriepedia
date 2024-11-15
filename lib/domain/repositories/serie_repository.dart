import '../entities/serie.dart';

abstract class TVRepository {
  Future<List<Serie>> getPopularList(int page);
}