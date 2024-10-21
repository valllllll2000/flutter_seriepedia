import '../entities/show.dart';

abstract class TVDatasource {
  Future<List<Show>> getPopularList();
}
