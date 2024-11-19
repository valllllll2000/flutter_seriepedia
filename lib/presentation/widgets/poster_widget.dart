import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';

import '../../domain/entities/serie.dart';

class PosterWidget extends StatelessWidget {
  const PosterWidget({
    super.key,
    required this.serie,
  });

  final Serie serie;

  @override
  Widget build(BuildContext context) {
    if (serie.posterPath != null) {
      return Image.network(serie.posterPath!,
          loadingBuilder: (context, child, loadingProgress) =>
              FadeIn(child: child));
    } else if (serie.backdropPath != null) {
      return Image.network(serie.backdropPath!,
          loadingBuilder: (context, child, loadingProgress) =>
              FadeIn(child: child));
    } else {
      return Image.asset('assets/notfound.jpg');
    }
  }
}
