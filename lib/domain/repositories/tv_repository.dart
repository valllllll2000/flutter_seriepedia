import '../entities/show.dart';

abstract class TVRepository {
  Future<List<Show>> getPopularList();
}