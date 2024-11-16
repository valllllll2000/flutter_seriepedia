import '../../domain/entities/serie.dart';
import '../models/moviedb/series_shows_response.dart';
import 'utils.dart';

class SerieMapper {
 static Serie fromResultToSerie(Result apiSerie) =>
      Serie(
          id: apiSerie.id,
          originalLanguage: apiSerie.originalLanguage,
          originalName: apiSerie.originalName,
          overview: apiSerie.overview,
          popularity: apiSerie.popularity,
          posterPath: Utils.imagePath(apiSerie.posterPath),
          backdropPath: Utils.imagePath(apiSerie.backdropPath));

 //TODO: use different one for Serie detail
 static Serie fromJsonToSerie(Map<String, dynamic> json) =>
     Serie(
         id: json['id'],
         originalLanguage: json['original_language'],
         originalName: json['original_name'],
         overview: json['overview'],
         popularity: json['popularity'],
         posterPath: Utils.imagePath(json['poster_path']),
         backdropPath: Utils.imagePath(json['backdrop_path']));
}