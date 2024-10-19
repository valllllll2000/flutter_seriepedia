import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:cinemapedia/presentation/providers/providers.dart';
import 'package:cinemapedia/presentation/widgets/widgets.dart';

class HomeView extends ConsumerStatefulWidget {
  const HomeView({super.key});

  @override
  HomeViewState createState() => HomeViewState();
}

class HomeViewState extends ConsumerState<HomeView> {
  @override
  void initState() {
    super.initState();
    ref.read(nowPlayingMoviesProvider.notifier).loadNextPage();
    ref.read(popularMoviesProvider.notifier).loadNextPage();
    ref.read(upComingMoviesProvider.notifier).loadNextPage();
    ref.read(topRatedMoviesProvider.notifier).loadNextPage();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final initialLoading = ref.watch(initialLoadingProvider);
    if (initialLoading) return const FullScreenLoader();
    final nowPlayingMovies = ref.watch(nowPlayingMoviesProvider);
    final slideShowMovies = ref.watch(moviesSlideShowProvider);
    final popularMovies = ref.watch(popularMoviesProvider);
    final upComingMovies = ref.watch(upComingMoviesProvider);
    final topRatedMovies = ref.watch(topRatedMoviesProvider);

    return CustomScrollView(
      slivers: [
        const SliverAppBar(
          floating: true,
          flexibleSpace: FlexibleSpaceBar(
            title: CustomAppbar(),
          ),
        ),
        SliverList(
            delegate: SliverChildBuilderDelegate((context, index) {
              return Column(
                children: [
                  MoviesSlideshow(movies: slideShowMovies),
                  MovieHorizontalListView(
                    movies: nowPlayingMovies,
                    title: 'Now in the cinemas',
                    subTitle: 'October 10',
                    loadNextPage: () =>
                        ref.read(nowPlayingMoviesProvider.notifier).loadNextPage(),
                  ),
                  MovieHorizontalListView(
                    movies: upComingMovies,
                    title: 'Coming soon',
                    subTitle: 'This month',
                    loadNextPage: () =>
                        ref.read(upComingMoviesProvider.notifier).loadNextPage(),
                  ),
                  MovieHorizontalListView(
                    movies: popularMovies,
                    title: 'Popular',
                    loadNextPage: () =>
                        ref.read(popularMoviesProvider.notifier).loadNextPage(),
                  ),
                  MovieHorizontalListView(
                    movies: topRatedMovies,
                    title: 'Favorites',
                    subTitle: 'Of all times',
                    loadNextPage: () =>
                        ref.read(topRatedMoviesProvider.notifier).loadNextPage(),
                  ),
                  const SizedBox(
                    height: 10,
                  )
                ],
              );
            }, childCount: 1))
      ],
    );
  }
}
