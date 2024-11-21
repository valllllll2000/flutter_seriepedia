class Serie {
  final int id;
  final bool adult;
  final String originalLanguage;
  final String originalName;
  final String overview;
  final double popularity;
  final double voteAverage;
  final String? posterPath;
  final String? backdropPath;
  final int year;

  Serie({
    required this.id,
    required this.adult,
    required this.originalLanguage,
    required this.originalName,
    required this.overview,
    required this.popularity,
    required this.voteAverage,
    required this.posterPath,
    required this.backdropPath,
    required this.year,
  });

  @override
  String toString() {
    return """
    Serie{
    id: $id, 
    adult: $adult
    originalLanguage: $originalLanguage, 
    originalName: $originalName, 
    overview: $overview, 
    popularity: $popularity, 
    voteAverage: $voteAverage, 
    posterPath: $posterPath, 
    backdropPath: $backdropPath,
    year: $year
    }
    """;
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'adult': adult,
      'original_language': originalLanguage,
      'original_name': originalName,
      'overview': overview,
      'popularity': popularity,
      'vote_average': voteAverage,
      'poster_path': posterPath,
      'backdrop_path': backdropPath,
      'year': year
    };
  }
}
