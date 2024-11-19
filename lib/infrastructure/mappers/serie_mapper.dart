import '../../domain/entities/serie.dart';
import '../models/moviedb/series_response.dart';
import 'utils.dart';

class SerieMapper {
  static Serie fromResultToSerie(Result apiSerie) => Serie(
      id: apiSerie.id,
      originalLanguage: apiSerie.originalLanguage,
      originalName: apiSerie.originalName,
      overview: apiSerie.overview,
      popularity: apiSerie.popularity,
      voteAverage: apiSerie.voteAverage,
      posterPath: Utils.imagePath(apiSerie.posterPath),
      backdropPath: Utils.imagePath(apiSerie.backdropPath));

  //TODO: use different one for Serie detail
  static Serie fromJsonToSerie(Map<String, dynamic> json) => Serie(
      id: json['id'],
      originalLanguage: json['original_language'],
      originalName: json['original_name'],
      overview: json['overview'],
      popularity: json['popularity'],
      voteAverage: json['vote_average'] ?? 0,
      posterPath: Utils.imagePathOrNull(json['poster_path']),
      backdropPath: Utils.imagePathOrNull(json['backdrop_path']));

  static Serie fromMapToSerie(Map<String, dynamic> map) => Serie(
        id: map['id']?.toInt() ?? 0,
        originalLanguage: map['original_language'] ?? '',
        originalName: map['original_name'] ?? '',
        overview: map['overview'] ?? '',
        popularity: map['popularity']?.toDouble() ?? 0.0,
        voteAverage: map['vote_average']?.toDouble() ?? 0.0,
        posterPath: map['poster_path'],
        backdropPath: map['backdrop_path'],
      );
}
