import 'package:animate_do/animate_do.dart';
import 'package:cinemapedia/presentation/blocs/serie_detail_bloc.dart';
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
    return BlocProvider(
      create: (context) =>
          SerieDetailBloc()..add(LoadSerieDetailEvent(serieId)),
      child: const _MovieDetailContainer(),
    );
  }
}

class _MovieDetailContainer extends StatelessWidget {
  const _MovieDetailContainer();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: context.select((SerieDetailBloc bloc) {
          print("New data: $bloc ");
          print("isLoading ${bloc.state.isLoading}");
          print("isNull serie ${bloc.state.serie == null}");
          print("isError ${bloc.state.isError == true}");
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
  const _ErrorSerie({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text('Serie not found :('),
    );
  }
}

class _LoadingSerie extends StatelessWidget {
  const _LoadingSerie({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
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
                child: Image.network(
                  serie.posterPath,
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
      actions: [
        IconButton(
          onPressed: () async {
            //TODO
          },
          icon: const Icon(Icons.favorite_border), //TODO
        ),
      ],
      flexibleSpace: FlexibleSpaceBar(
        titlePadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        background: Stack(
          children: [
            SizedBox.expand(
              child: Image.network(
                serie.posterPath,
                fit: BoxFit.cover,
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress != null) {
                    return const SizedBox();
                  }
                  return FadeIn(child: child);
                },
              ),
            ),
            const CustomGradient(
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
              stops: [0.0, 0.2],
              colors: [Colors.black54, Colors.transparent],
            ),
            const CustomGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              stops: [0.8, 1.0],
              colors: [Colors.transparent, Colors.black87],
            ),
            const CustomGradient(
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