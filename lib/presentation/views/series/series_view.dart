import 'package:cinemapedia/presentation/blocs/list/series_list_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:go_router/go_router.dart';

import '../../../config/helpers/human_formats.dart';
import '../../../domain/entities/serie.dart';
import '../../delegates/search_movie_delegate.dart';

class SeriesView extends StatefulWidget {
  const SeriesView({super.key});

  @override
  SeriesViewState createState() => SeriesViewState();
}

class SeriesViewState extends State<SeriesView> {
  final scrollController = ScrollController();

  @override
  void initState() {
    super.initState();

    scrollController.addListener(() {
      if (scrollController.position.pixels >=
          scrollController.position.maxScrollExtent - 200) {
        context.read<SeriesListBloc>().add(LoadNextPageEvent());
      }
    });
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    FlutterNativeSplash.remove();
    final textThemes = Theme.of(context).textTheme;
    final Set<Serie> series =
        context.select((SeriesListBloc bloc) => bloc.state.series);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: CustomScrollView(controller: scrollController, slivers: <Widget>[
        SliverAppBar(
          pinned: false,
          title: const Text('Popular TV Shows'),
          actions: [
            IconButton(
                onPressed: () {
                  showSearch<Serie?>(
                    query: "",
                    context: context,
                    delegate: SearchMovieDelegate(),
                  ).then((serie) {
                    if (serie == null) return;
                    if (mounted) {
                      context.push('/home/0/serie/${serie.id}');
                    }
                  });
                },
                icon: const Icon(Icons.search)),
            IconButton(onPressed: () {}, icon: const Icon(Icons.filter_list)),
          ],
        ),
        SliverGrid(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            crossAxisSpacing: 8,
            childAspectRatio: 0.5,
          ),
          delegate: SliverChildBuilderDelegate((context, index) {
            final show = series.elementAt(index);
            return GestureDetector(
              onTap: () => context.push('/home/0/serie/${show.id}'),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: show.posterPath != null
                        ? Image.network(
                            show.posterPath!,
                            fit: BoxFit.scaleDown,
                          )
                        : Image.asset('/assets/not-found'),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                    show.originalName,
                    maxLines: 1,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  SizedBox(
                    width: 150,
                    child: Row(
                      children: [
                        Icon(
                          Icons.star_half_outlined,
                          color: Colors.yellow.shade800,
                        ),
                        const SizedBox(
                          width: 3,
                        ),
                        Text(
                          HumanFormats.number(show.voteAverage, 1),
                          style: textThemes.bodyMedium
                              ?.copyWith(color: Colors.yellow.shade800),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        const Spacer(),

                        //Popularity
                        Text(
                          HumanFormats.number(show.popularity),
                          style: textThemes.bodySmall,
                        )
                      ],
                    ),
                  )
                ],
              ),
            );
          }, childCount: series.length),
        ),
      ]),
    );
  }
}
