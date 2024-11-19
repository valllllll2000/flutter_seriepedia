import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../domain/entities/serie.dart';
import '../../../domain/repositories/serie_repository.dart';
import '../../../infrastructure/datasources/series_moviedb_datasource.dart';
import '../../../infrastructure/repositories/series_repository_impl.dart';

part 'series_list_event.dart';

part 'series_list_state.dart';

class SeriesListBloc extends Bloc<SeriesListEvent, SeriesListState> {
  int page = 1;

  //TODO: inject this
  final SeriesRepository repository =
      SeriesRepositoryImpl(datasource: SeriesMovieDbDatasource());

  SeriesListBloc() : super(const SeriesListState()) {
    on<LoadNextPageEvent>((event, emit) async {
      if (state.isLastBatch || state.isLoading) return;

      emit(state.copyWith(isLoading: true));
      try {
        final List<Serie> series = await repository.getPopularList(page);
        series.forEach(printIfNeeded);
        if (series.isNotEmpty) {
          page++;
          emit(state.copyWith(
              isError: false,
              isLoading: false,
              series: {...state.series, ...series}));
        } else {
          emit(state.copyWith(
              isError: false, isLoading: false, isLastBatch: true));
        }
      } catch (e) {
        print(e);
        emit(state.copyWith(isError: true, isLoading: false));
      }
    });

    add(LoadNextPageEvent());
  }

  void printIfNeeded(Serie element) {
    if (element.originalName.toLowerCase().contains('midsomer')) {
      print('page: $page, element: $element');
    }
  }
}
