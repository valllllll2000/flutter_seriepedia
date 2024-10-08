import '../entities/movie.dart';

abstract class MovieDataSource {
  Future<List<Movie>> getNoyPlaying({int page = 1});
}
