import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../config/helpers/human_formats.dart';
import '../../../domain/entities/serie.dart';
import '../../providers/series/popular_shows_provider.dart';

class SeriesView extends ConsumerStatefulWidget {
  const SeriesView({super.key});

  @override
  SeriesViewState createState() => SeriesViewState();
}

class SeriesViewState extends ConsumerState<SeriesView> {
  final scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    ref.read(popularShowsProvider.notifier).loadPopularShows();
    scrollController.addListener(() {
      if (scrollController.position.pixels >=
          scrollController.position.maxScrollExtent - 200) {
        ref.read(popularShowsProvider.notifier).loadPopularShows();
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
    final List<Serie> series = ref.watch(popularShowsProvider);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: CustomScrollView(controller: scrollController, slivers: <Widget>[
        SliverAppBar(
          pinned: false,
          title: const Text('Popular TV Shows'),
          actions: [
            IconButton(onPressed: () {}, icon: const Icon(Icons.search))
          ],
        ),
        SliverGrid(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            crossAxisSpacing: 8,
            childAspectRatio: 0.5,
          ),
          delegate: SliverChildBuilderDelegate((context, index) {
            final show = series[index];
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
