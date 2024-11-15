import 'package:cinemapedia/domain/datasources/TVDatasource.dart';
import 'package:cinemapedia/domain/entities/serie.dart';
import 'package:cinemapedia/infrastructure/mappers/serie_mapper.dart';
import 'package:cinemapedia/infrastructure/models/moviedb/series_shows_response.dart';
import 'package:dio/dio.dart';

import '../../config/constants/environment.dart';

class SeriesMovieDbDatasource implements SeriesDatasource {
  final dio = Dio(BaseOptions(
      baseUrl: 'https://api.themoviedb.org/3',
      queryParameters: {
        'api_key': Environment.theMovieDbKey,
        'language': 'en-US'
      }));

  @override
  Future<List<Serie>> getPopularList({int page = 1}) async {
    final response = await dio.get('/tv/popular', queryParameters: {'page': page});
    final tvResponse = SeriesResponse.fromJson(response.data);
    List<Serie> shows = tvResponse.results
        .map((e) => SerieMapper.toSerie(e))
        .toList();
    return shows;
  }


}
