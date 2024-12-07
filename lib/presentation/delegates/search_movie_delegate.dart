import 'dart:async';

import 'package:animate_do/animate_do.dart';
import 'package:cinemapedia/config/helpers/human_formats.dart';
import 'package:cinemapedia/presentation/blocs/search/search_series_bloc.dart';
import 'package:cinemapedia/presentation/widgets/poster_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/serie.dart';

typedef SearchSeriesCallback = Future<List<Serie>> Function(String query);

class SearchMovieDelegate extends SearchDelegate<Serie?> {
  SearchMovieDelegate();

  @override
  String get searchFieldLabel => 'Search: type at least 2 letters';

  void _makeQuery(BuildContext context) {
    context.read<SearchSeriesBloc>().add(MakeQuery(query));
  }

  @override
  List<Widget>? buildActions(BuildContext context) {
    final isLoading =
        context.select((SearchSeriesBloc bloc) => bloc.state.isLoading);
    return [
      _BuildActions(isLoading, query, () {
        query = '';
      })
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
        onPressed: () {
          close(context, null);
        },
        icon: const Icon(Icons.arrow_back_ios_new_rounded));
  }

  @override
  Widget buildResults(BuildContext context) {
    _makeQuery(context);
    return buildResultsAndSuggestions(context);
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    _makeQuery(context);
    return buildResultsAndSuggestions(context);
  }

  Widget buildResultsAndSuggestions(BuildContext context) {
    return _SeriesListWidget(onSerieSelected: (context, movie) {
      close(context, movie);
    });
  }
}

class _SeriesListWidget extends StatefulWidget {
  final Function onSerieSelected;

  const _SeriesListWidget({required this.onSerieSelected});

  @override
  State<_SeriesListWidget> createState() => _SeriesListWidgetState();
}

class _SeriesListWidgetState extends State<_SeriesListWidget> {
  final scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    final series = context.select((SearchSeriesBloc bloc) => bloc.state.series);
    return ListView.builder(
        controller: scrollController,
        itemCount: series.length,
        itemBuilder: (context, index) => _SerieItem(
              serie: series.elementAt(index),
              onSerieSelected: widget.onSerieSelected,
            ));
  }

  @override
  void initState() {
    super.initState();
    scrollController.addListener(() {
      if (scrollController.position.pixels >
          scrollController.position.maxScrollExtent - 200) {
        context.read<SearchSeriesBloc>().add(LoadNextPage());
      }
    });
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }
}

class _SerieItem extends StatelessWidget {
  final Serie serie;
  final Function onSerieSelected;

  const _SerieItem({required this.serie, required this.onSerieSelected});

  @override
  Widget build(BuildContext context) {
    final textStyles = Theme.of(context).textTheme;
    final size = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: () {
        onSerieSelected(context, serie);
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

class _BuildActions extends StatelessWidget {
  final bool isLoading;
  final String query;
  final VoidCallback? onPressed;

  const _BuildActions(this.isLoading, this.query, this.onPressed);

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return SpinPerfect(
          duration: const Duration(milliseconds: 20),
          spins: 10,
          infinite: true,
          child: IconButton(
              onPressed: onPressed, icon: const Icon(Icons.refresh_rounded)));
    } else {
      return FadeIn(
          animate: query.isNotEmpty,
          duration: const Duration(milliseconds: 200),
          child:
              IconButton(onPressed: onPressed, icon: const Icon(Icons.clear)));
    }
  }
}
