import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:go_router/go_router.dart';

import '../../domain/entities/serie.dart';

class SeriesMasonry extends StatefulWidget {
  final List<Serie> series;
  final VoidCallback? loadNextPage;

  const SeriesMasonry({super.key, required this.series, this.loadNextPage});

  @override
  State<SeriesMasonry> createState() => _SeriesMasonryState();
}

class _SeriesMasonryState extends State<SeriesMasonry> {
  final scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    scrollController.addListener(() {
      if (widget.loadNextPage == null) return;

      if ((scrollController.position.pixels + 100) >=
          scrollController.position.maxScrollExtent) {
        widget.loadNextPage!();
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
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: MasonryGridView.count(
          controller: scrollController,
          scrollDirection: Axis.vertical,
          crossAxisCount: 3,
          mainAxisSpacing: 10,
          crossAxisSpacing: 10,
          itemCount: widget.series.length,
          itemBuilder: (context, index) {
            if (index == 1) {
              return Column(
                children: [
                  const SizedBox(
                    height: 40,
                  ),
                  _MoviePosterLink(serie: widget.series[index])
                ],
              );
            }
            return _MoviePosterLink(serie: widget.series[index]);
          }),
    );
  }
}

class _MoviePosterLink extends StatelessWidget {
  final Serie serie;

  const _MoviePosterLink({
    required this.serie,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => context.push('/home/0/serie/${serie.id}'),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: FadeInUp(child: _PosterWidget(serie: serie)),
      ),
    );
  }
}

class _PosterWidget extends StatelessWidget {
  const _PosterWidget({
    required this.serie,
  });

  final Serie serie;

  @override
  Widget build(BuildContext context) {
    if (serie.posterPath != null) {
      return Image.network(serie.posterPath!);
    } else {
      return Image.asset('/assets/not-found');
    }
  }
}
