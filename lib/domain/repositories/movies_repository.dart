import '../entities/movie.dart';

abstract class MoviesRepository {
  Future<List<Movie>> getNoyPlaying({int page = 1});
}
