import 'package:cinemapedia/domain/entities/actor.dart';

import '../models/moviedb/credits_response.dart';

class ActorMapper {
  static Actor castToEntity(Cast cast) => Actor(
      id: cast.id,
      name: cast.name,
      profilePath: cast.profilePath != null
          ? 'https://image.tmdb.org/t/p/w500${cast.profilePath!}'
          : 'https://freepng.com/uploads/images/202308/funny-bathroom-phrases-no-selfies-in-the-bathromm-vector-poster_1020x-3357.jpg',
      character: cast.character);
}
