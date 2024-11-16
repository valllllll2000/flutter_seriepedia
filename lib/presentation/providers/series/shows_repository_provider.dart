import 'package:cinemapedia/infrastructure/repositories/series_repository_impl.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../infrastructure/datasources/series_moviedb_datasource.dart';

final showsRepositoryProvider = Provider((ref) {
  return SeriesRepositoryImpl(datasource: SeriesMovieDbDatasource());
});