import 'package:cinemapedia/infrastructure/repositories/tv_repository_impl.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../infrastructure/datasources/tv_imdb_datasource.dart';

final showsRepositoryProvider = Provider((ref) {
  return TVRepositoryImpl(datasource: TVIMDBDatasource());
});