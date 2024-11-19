import 'dart:async';

import 'package:animate_do/animate_do.dart';
import 'package:cinemapedia/config/helpers/human_formats.dart';
import 'package:cinemapedia/presentation/widgets/poster_widget.dart';
import 'package:flutter/material.dart';

import '../../domain/entities/serie.dart';

typedef SearchMoviesCallback = Future<List<Serie>> Function(String query);

class SearchMovieDelegate extends SearchDelegate<Serie?> {
  final SearchMoviesCallback searchMovies;
  List<Serie> initialMovies;
  StreamController<List<Serie>> debounceMovies = StreamController.broadcast();
  StreamController<bool> isLoadingStream = StreamController.broadcast();
  Timer? _debounceTimer;

  SearchMovieDelegate(
      {required this.searchMovies, required this.initialMovies});

  void clearStreams() {
    debounceMovies.close();
  }

  void _onQueryChanged(String query) {
    isLoadingStream.add(true);
    if (_debounceTimer?.isActive ?? false) _debounceTimer!.cancel();
    _debounceTimer = Timer(const Duration(milliseconds: 500), () async {
      final movies = await searchMovies(query);
      initialMovies = movies;
      debounceMovies.add(movies);
      isLoadingStream.add(false);
    });
  }

  @override
  String get searchFieldLabel => 'Search movies';

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      StreamBuilder(
          stream: isLoadingStream.stream,
          builder: (context, snapshot) {
            final bool isLoading = snapshot.data ?? false;
            if (isLoading) {
              return SpinPerfect(
                  duration: const Duration(milliseconds: 20),
                  spins: 10,
                  infinite: true,
                  child: IconButton(
                      onPressed: () => query = '',
                      icon: const Icon(Icons.refresh_rounded)));
            } else {
              return FadeIn(
                  animate: query.isNotEmpty,
                  duration: const Duration(milliseconds: 200),
                  child: IconButton(
                      onPressed: () => query = '',
                      icon: const Icon(Icons.clear)));
            }
          })
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
        onPressed: () {
          clearStreams();
          close(context, null);
        },
        icon: const Icon(Icons.arrow_back_ios_new_rounded));
  }

  @override
  Widget buildResults(BuildContext context) {
    return buildResultsAndSuggestions();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    _onQueryChanged(query);
    return buildResultsAndSuggestions();
  }

  Widget buildResultsAndSuggestions() {
    return StreamBuilder(
        stream: debounceMovies.stream,
        initialData: initialMovies,
        builder: (context, snapshot) {
          final movies = snapshot.data ?? [];
          return ListView.builder(
              itemCount: movies.length,
              itemBuilder: (context, index) => _MovieItem(
                    serie: movies[index],
                    onMovieSelected: (context, movie) {
                      clearStreams();
                      close(context, movie);
                    },
                  ));
        });
  }
}

class _MovieItem extends StatelessWidget {
  final Serie serie;
  final Function onMovieSelected;

  const _MovieItem({required this.serie, required this.onMovieSelected});

  @override
  Widget build(BuildContext context) {
    final textStyles = Theme.of(context).textTheme;
    final size = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: () {
        onMovieSelected(context, serie);
      },
      child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          child: Row(
            children: [
              SizedBox(
                width: size.width * 0.2,
                child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: PosterWidget(serie: serie)),
              ),
              const SizedBox(
                width: 10,
              ),
              SizedBox(
                width: size.width * 0.7,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      serie.originalName,
                      style: textStyles.titleMedium,
                    ),
                    (serie.overview.length > 100)
                        ? Text('${serie.overview.substring(0, 100)}...')
                        : Text(serie.overview),
                    Row(
                      children: [
                        Icon(
                          Icons.star_half_rounded,
                          color: Colors.yellow.shade800,
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                        Text(
                          HumanFormats.number(serie.voteAverage, 1),
                          style: textStyles.bodyMedium!
                              .copyWith(color: Colors.yellow.shade900),
                        ),
                      ],
                    )
                  ],
                ),
              )
            ],
          )),
    );
  }
}
