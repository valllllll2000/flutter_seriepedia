class Serie {
  final int id;
  final String originalLanguage;
  final String originalName;
  final String overview;
  final double popularity;
  final double voteAverage;
  final String? posterPath;
  final String? backdropPath;

  Serie(
      {required this.id,
      required this.originalLanguage,
      required this.originalName,
      required this.overview,
      required this.popularity,
      required this.voteAverage,
      required this.posterPath,
      required this.backdropPath});

  @override
  String toString() {
    return """
    Serie{
    id: $id, 
    originalLanguage: $originalLanguage, 
    originalName: $originalName, 
    overview: $overview, 
    popularity: $popularity, 
    voteAverage: $voteAverage, 
    posterPath: $posterPath, 
    backdropPath: $backdropPath
    }
    """;
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'original_language': originalLanguage,
      'original_name': originalName,
      'overview': overview,
      'popularity': popularity,
      'vote_average': voteAverage,
      'poster_path': posterPath,
      'backdrop_path': backdropPath,
    };
  }
}
