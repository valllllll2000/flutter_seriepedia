class Show {
  final int id;
  final String originalLanguage;
  final String originalName;
  final String overview;
  final double popularity;
  final String posterPath;
  final String backdropPath;

  Show(
      {required this.id,
      required this.originalLanguage,
      required this.originalName,
      required this.overview,
      required this.popularity,
      required this.posterPath,
      required this.backdropPath});
}
