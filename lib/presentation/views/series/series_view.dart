import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:go_router/go_router.dart';

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
    final List<Serie> shows = ref.watch(popularShowsProvider);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: MasonryGridView.count(
        controller: scrollController,
        crossAxisCount: 3,
        itemCount: shows.length,
        mainAxisSpacing: 10,
        crossAxisSpacing: 10,
        itemBuilder: (context, index) {
          final show = shows[index];
          return GestureDetector(
            onTap: () => context.push('/home/0/tv/${show.id}'),
            child: Column(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.network(show.posterPath),
                ),
                const SizedBox(
                  height: 10,
                ),
                Text(show.originalName)
              ],
            ),
          );
        },
      ),
    );
  }
}
