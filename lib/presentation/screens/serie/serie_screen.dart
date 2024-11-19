import 'package:animate_do/animate_do.dart';
import 'package:cinemapedia/presentation/blocs/detail/serie_detail_bloc.dart';
import 'package:cinemapedia/presentation/blocs/favorites/favorites_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/entities/serie.dart';
import '../../widgets/shared/custom_gradient.dart';

class SerieScreen extends StatelessWidget {
  static const String name = 'serie-screen';

  final String serieId;

  const SerieScreen({super.key, required this.serieId});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<SerieDetailBloc>(
          create: (context) =>
              SerieDetailBloc()..add(LoadSerieDetailEvent(serieId)),
        ),
      ],
      child: const _MovieDetailContainer(),
    );
  }
}

class _MovieDetailContainer extends StatelessWidget {
  const _MovieDetailContainer();

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: context.select((SerieDetailBloc bloc) {
      return bloc.state.isLoading
          ? const _LoadingSerie()
          : bloc.state.serie == null || bloc.state.isError == true
              ? const _ErrorSerie()
              : _SerieWidget(bloc.state.serie!);
    }));
  }
}

class _SerieWidget extends StatelessWidget {
  final Serie serie;

  const _SerieWidget(this.serie);

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(physics: const ClampingScrollPhysics(), slivers: [
      _CustomSliverAppBar(serie),
      SliverList(
          delegate: SliverChildBuilderDelegate(
              (context, index) => _MovieDetails(serie: serie),
              childCount: 1)),
    ]);
  }
}

class _ErrorSerie extends StatelessWidget {
  const _ErrorSerie();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text('Serie not found :('),
    );
  }
}

class _LoadingSerie extends StatelessWidget {
  const _LoadingSerie();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: CircularProgressIndicator(
        strokeWidth: 2,
      ),
    );
  }
}

class _MovieDetails extends StatelessWidget {
  final Serie serie;

  const _MovieDetails({required this.serie});

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
                child: serie.backdropPath != null
                    ? Image.network(
                        serie.backdropPath!,
                        width: size.width * 0.3,
                      )
                    : Image.asset('assets/notfound.jpg',
                        width: size.width * 0.3),
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
                      serie.originalName,
                      style: textStyle.titleLarge,
                    ),
                    Text(serie.overview)
                  ],
                ),
              )
            ],
          ),
        ),
        const SizedBox(
          height: 50,
        )
      ],
    );
  }
}

class _CustomSliverAppBar extends StatelessWidget {
  final Serie serie;

  const _CustomSliverAppBar(this.serie);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return SliverAppBar(
      backgroundColor: Colors.black,
      expandedHeight: size.height * 0.7,
      foregroundColor: Colors.white,
      shadowColor: Colors.red,
      actions: [_FavoriteWidget(serie: serie)],
      flexibleSpace: FlexibleSpaceBar(
        titlePadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        background: Stack(
          children: [
            SizedBox.expand(child: _BigImage(serie)),
            const CustomGradient(
              begin: Alignment.topRight,
              end: Alignment.centerLeft,
              stops: [0.0, 0.3],
              colors: [
                Colors.green,
                Colors.transparent,
              ],
            ),
            const CustomGradient(
              begin: Alignment.topLeft,
              stops: [0.0, 0.3],
              colors: [Colors.green, Colors.transparent],
            ),
          ],
        ),
      ),
    );
  }
}

class _FavoriteWidget extends StatelessWidget {
  const _FavoriteWidget({
    required this.serie,
  });

  final Serie serie;

  @override
  Widget build(BuildContext context) {
    return context.select((FavoritesBloc bloc) {
      return IconButton(
        onPressed: () {
          context.read<FavoritesBloc>().add(UpdateFavorite(serie: serie));
        },
        icon: bloc.isFavorite(serie)
            ? const Icon(
                Icons.favorite_rounded,
                color: Colors.red,
              )
            : const Icon(Icons.favorite_border),
      );
    });
  }
}

class _BigImage extends StatelessWidget {
  final Serie serie;

  const _BigImage(this.serie);

  @override
  Widget build(BuildContext context) {
    final posterUrl = serie.posterPath ?? serie.backdropPath;
    return posterUrl != null
        ? Image.network(
            posterUrl,
            fit: BoxFit.cover,
            loadingBuilder: (context, child, loadingProgress) {
              if (loadingProgress != null) {
                return const SizedBox();
              }
              return FadeIn(child: child);
            },
          )
        : Image.asset('assets/notfound.jpg');
  }
}
