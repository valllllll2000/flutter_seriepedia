import 'package:cinemapedia/domain/datasources/TVDatasource.dart';
import 'package:cinemapedia/domain/entities/show.dart';
import 'package:cinemapedia/infrastructure/models/moviedb/tv_shows_response.dart';
import 'package:dio/dio.dart';

import '../../config/constants/environment.dart';
import '../mappers/Utils.dart';

class TVIMDBDatasource implements TVDatasource {
  final dio = Dio(BaseOptions(
      baseUrl: 'https://api.themoviedb.org/3',
      queryParameters: {
        'api_key': Environment.theMovieDbKey,
        'language': 'en-US'
      }));

  @override
  Future<List<Show>> getPopularList() async {
    final response = await dio.get('/tv/popular', queryParameters: {'page': 1});
    final tvResponse = TvShowsResponse.fromJson(response.data);
    List<Show> shows = tvResponse.results
        .map((tv) => Show(
            id: tv.id,
            originalLanguage: tv.originalLanguage,
            originalName: tv.originalName,
            overview: tv.overview,
            popularity: tv.popularity,
            posterPath: Utils.imagePath(tv.posterPath),
            backdropPath: Utils.imagePath(tv.backdropPath)))
        .toList();
    return shows;
  }
}
