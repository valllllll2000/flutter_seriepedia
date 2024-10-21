import 'package:cinemapedia/domain/datasources/TVDatasource.dart';
import 'package:cinemapedia/domain/entities/show.dart';
import 'package:cinemapedia/domain/repositories/tv_repository.dart';

class TVRepositoryImpl implements TVRepository {
  final TVDatasource datasource;

  TVRepositoryImpl({required this.datasource});

  @override
  Future<List<Show>> getPopularList() {
    return datasource.getPopularList();
  }
}
