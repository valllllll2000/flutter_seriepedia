import 'package:animate_do/animate_do.dart';
import 'package:cinemapedia/presentation/providers/providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../domain/entities/actor.dart';
import '../../../domain/entities/movie.dart';
import '../../providers/storage/favorite_movies_provider.dart';

class SerieScreen extends ConsumerStatefulWidget {
  static const String name = 'serie-screen';

  final String serieId;

  const SerieScreen({super.key, required this.serieId});

  @override
  SerieScreenState createState() => SerieScreenState();
}

class SerieScreenState extends ConsumerState<SerieScreen> {
  @override
  void initState() {
    super.initState();
    ref.read(movieInfoProvider.notifier).loadMovie(widget.serieId);
    ref.read(actorsByMovieProvider.notifier).loadActors(widget.serieId);
  }

  @override
  Widget build(BuildContext context) {
    final Movie? movie = ref.watch(movieInfoProvider)[widget.serieId];

    if (movie == null) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(
            strokeWidth: 2,
          ),
        ),
      );
    }
    return Scaffold(
      body: CustomScrollView(physics: const ClampingScrollPhysics(), slivers: [
        _CustomSliverAppBar(movie),
        SliverList(
            delegate: SliverChildBuilderDelegate(
                (context, index) => _MovieDetails(movie: movie),
                childCount: 1)),
      ]),
    );
  }
}

class _MovieDetails extends StatelessWidget {
  final Movie movie;

  const _MovieDetails({required this.movie});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final textStyle = Theme.of(context).textTheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(8),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Image.network(
                  movie.posterPath,
                  width: size.width * 0.3,
                ),
              ),
              const SizedBox(
                width: 10,
              ),
              SizedBox(
                width: (size.width - 40) * 0.7,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      movie.title,
                      style: textStyle.titleLarge,
                    ),
                    Text(movie.overview)
                  ],
                ),
              )
            ],
          ),
        ),

        //genre
        Padding(
          padding: const EdgeInsets.all(8),
          child: Wrap(
            children: [
              ...movie.genreIds.map((gender) => Container(
                  padding: const EdgeInsets.only(right: 30),
                  child: Chip(
                    label: Text(gender),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20)),
                  )))
            ],
          ),
        ),

        _ActorsByMovie(movie.id.toString()),

        const SizedBox(
          height: 50,
        )
      ],
    );
  }
}

class _ActorsByMovie extends ConsumerWidget {
  final String movieId;

  const _ActorsByMovie(this.movieId);

  @override
  Widget build(BuildContext context, ref) {
    final provider = ref.watch(actorsByMovieProvider);
    if (provider[movieId] == null) {
      return const CircularProgressIndicator(
        strokeWidth: 2,
      );
    }
    final List<Actor> actors = provider[movieId.toString()]!;
    return SizedBox(
      height: 300,
      child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: actors.length,
          itemBuilder: (context, index) {
            final actor = actors[index];
            return Container(
              padding: const EdgeInsets.all(8),
              width: 135,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  FadeInRight(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(30),
                      child: Image.network(actor.profilePath,
                          height: 180, width: 135, fit: BoxFit.cover),
                    ),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Text(
                    actor.name,
                    maxLines: 2,
                  ),
                  Text(
                    actor.character ?? '',
                    maxLines: 2,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        overflow: TextOverflow.ellipsis),
                  )
                ],
              ),
            );
          }),
    );
  }
}

final _isFavoriteProvider = FutureProvider.family.autoDispose((ref, int movieId) {
  final localStorageRepository = ref.watch(localStorageRepositoryProvider);
  return localStorageRepository.isMovieFavorite(movieId);
});

class _CustomSliverAppBar extends ConsumerWidget {
  final Movie movie;

  const _CustomSliverAppBar(this.movie);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isFavoriteFuture = ref.watch(_isFavoriteProvider(movie.id));
    final size = MediaQuery.of(context).size;
    return SliverAppBar(
      backgroundColor: Colors.black,
      expandedHeight: size.height * 0.7,
      foregroundColor: Colors.white,
      shadowColor: Colors.red,
      actions: [
        IconButton(
            onPressed: () async {
              await ref.read(favoriteMoviesProvider.notifier).toggleFavorite(movie);
              ref.invalidate(_isFavoriteProvider(movie.id));
            },
            icon: isFavoriteFuture.when(
              loading: () => const Icon(Icons.favorite_border),
              data: (isFavorite) => isFavorite
                  ? const Icon(Icons.favorite_rounded, color: Colors.red,)
                  : const Icon(Icons.favorite_border),
              error: (_, __) => const Icon(Icons.favorite_border),
            )),
      ],
      flexibleSpace: FlexibleSpaceBar(
        titlePadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        background: Stack(
          children: [
            SizedBox.expand(
              child: Image.network(
                movie.posterPath,
                fit: BoxFit.cover,
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress != null) {
                    return const SizedBox();
                  }
                  return FadeIn(child: child);
                },
              ),
            ),
            const _CustomGradient(
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
              stops: [0.0, 0.2],
              colors: [Colors.black54, Colors.transparent],
            ),
            const _CustomGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              stops: [0.8, 1.0],
              colors: [Colors.transparent, Colors.black87],
            ),
            const _CustomGradient(
              begin: Alignment.topLeft,
              stops: [0.0, 0.3],
              colors: [Colors.black87, Colors.transparent],
            ),
          ],
        ),
      ),
    );
  }
}

class _CustomGradient extends StatelessWidget {
  final AlignmentGeometry begin;
  final AlignmentGeometry end;
  final List<double> stops;
  final List<Color> colors;

  const _CustomGradient(
      {this.begin = Alignment.centerLeft,
      this.end = Alignment.centerRight,
      required this.stops,
      required this.colors});

  @override
  Widget build(BuildContext context) {
    return SizedBox.expand(
        child: DecoratedBox(
            decoration: BoxDecoration(
                gradient: LinearGradient(
                    begin: begin, end: end, stops: stops, colors: colors))));
  }
}
