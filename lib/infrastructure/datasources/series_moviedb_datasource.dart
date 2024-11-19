import 'package:cinemapedia/domain/datasources/series_datasource.dart';
import 'package:cinemapedia/domain/entities/serie.dart';
import 'package:cinemapedia/infrastructure/mappers/serie_mapper.dart';
import 'package:cinemapedia/infrastructure/models/moviedb/series_response.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

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
    final response =
        await dio.get('/tv/popular', queryParameters: {'page': page});
    final tvResponse = SeriesResponse.fromJson(response.data);
    List<Serie> shows = tvResponse.results
        .map((e) => SerieMapper.fromResultToSerie(e))
        .toList();
    return shows;
  }

  @override
  Future<Serie?> getSerie(String serieId) async {
    try {
      final response = await dio.get('/tv/$serieId');
      return SerieMapper.fromJsonToSerie(response.data);
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      return null;
    }
  }
}
