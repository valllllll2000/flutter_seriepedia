class Utils {
  static String imagePath(String path) {
    return path != ''
        ? 'https://image.tmdb.org/t/p/w500/$path'
        : 'https://freepng.com/uploads/images/202308/funny-bathroom-phrases-no-selfies-in-the-bathromm-vector-poster_1020x-3357.jpg';
  }

  static String? imagePathOrNull(String? path) {
    return path != null ? 'https://image.tmdb.org/t/p/w500/$path' : null;
  }
}
