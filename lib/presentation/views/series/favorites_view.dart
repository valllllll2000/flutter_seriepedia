import 'package:cinemapedia/presentation/widgets/series_masonry.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../blocs/favorites/favorites_bloc.dart';

class FavoritesView extends StatelessWidget {
  const FavoritesView({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: _FavoritesContent(),
    );
  }
}

class _FavoritesContent extends StatelessWidget {
  const _FavoritesContent();

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: context.select((FavoritesBloc bloc) {
      return bloc.state.favorites.isEmpty
          ? const _NoFavoritesView()
          : SeriesMasonry(
              series: bloc.state.favorites);
    }));
  }
}

class _NoFavoritesView extends StatelessWidget {
  const _NoFavoritesView();

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(
            Icons.favorite_outline_sharp,
            size: 60,
            color: colors.primary,
          ),
          Text(
            'Oh no!',
            style: TextStyle(fontSize: 30, color: colors.primary),
          ),
          const Text(
            'You have no favorite tv show',
            style: TextStyle(fontSize: 20, color: Colors.black45),
          ),
          const SizedBox(
            height: 20,
          ),
          FilledButton.tonal(
              onPressed: () {
                context.go('/home/0');
              },
              child: const Text('Start searching'))
        ],
      ),
    );
  }
}
