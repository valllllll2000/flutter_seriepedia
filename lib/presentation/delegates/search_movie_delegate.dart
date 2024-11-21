import 'dart:async';

import 'package:animate_do/animate_do.dart';
import 'package:cinemapedia/config/helpers/human_formats.dart';
import 'package:cinemapedia/main.dart';
import 'package:cinemapedia/presentation/blocs/search/search_series_bloc.dart';
import 'package:cinemapedia/presentation/widgets/poster_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/serie.dart';

typedef SearchSeriesCallback = Future<List<Serie>> Function(String query);

class SearchMovieDelegate extends SearchDelegate<Serie?> {
 // final SearchSeriesCallback searchSeries;
 // List<Serie> initialSeries;
  StreamController<List<Serie>> debounceSeries = StreamController.broadcast();
  StreamController<bool> isLoadingStream = StreamController.broadcast();
  Timer? _debounceTimer;

  SearchMovieDelegate(
      /*{required this.searchSeries, required this.initialSeries}*/);

  void clearStreams() {
    debounceSeries.close();
  }

/*  void _onQueryChanged(String query) {
    isLoadingStream.add(true);
    if (_debounceTimer?.isActive ?? false) _debounceTimer!.cancel();
    _debounceTimer = Timer(const Duration(milliseconds: 500), () async {
      //final series = await searchSeries(query);
      //initialSeries = series;
      debounceSeries.add(series);
      isLoadingStream.add(false);
    });
  }*/

  @override
  String get searchFieldLabel => 'Search series';

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
    return buildResultsAndSuggestions(context);
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    context.read<SearchSeriesBloc>().add(MakeQuery(query));
    return buildResultsAndSuggestions(context);
  }

  Widget buildResultsAndSuggestions(BuildContext context) {
    final series =
        context.select((SearchSeriesBloc bloc) => bloc.state.series);
    return StreamBuilder(
        stream: debounceSeries.stream,
        initialData: series,
        builder: (context, snapshot) {
          final series = snapshot.data ?? [];
          return ListView.builder(
              itemCount: series.length,
              itemBuilder: (context, index) => _SerieItem(
                    serie: series[index],
                    onSerieSelected: (context, movie) {
                      clearStreams();
                      close(context, movie);
                    },
                  ));
        });
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
