import '../../domain/entities/serie.dart';
import '../models/moviedb/series_shows_response.dart';
import 'utils.dart';

class SerieMapper {
 static Serie toSerie(Result apiSerie) =>
      Serie(
          id: apiSerie.id,
          originalLanguage: apiSerie.originalLanguage,
          originalName: apiSerie.originalName,
          overview: apiSerie.overview,
          popularity: apiSerie.popularity,
          posterPath: Utils.imagePath(apiSerie.posterPath),
          backdropPath: Utils.imagePath(apiSerie.backdropPath));
}