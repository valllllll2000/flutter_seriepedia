import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../domain/entities/serie.dart';
import '../../../domain/repositories/serie_repository.dart';
import '../../../infrastructure/datasources/series_moviedb_datasource.dart';
import '../../../infrastructure/repositories/series_repository_impl.dart';

part 'search_series_event.dart';

part 'search_series_state.dart';

class SearchSeriesBloc extends Bloc<SearchSeriesEvent, SearchSeriesState> {
  int page = 1;

  //TODO: inject this
  final SeriesRepository repository =
      SeriesRepositoryImpl(datasource: SeriesMovieDbDatasource());

  SearchSeriesBloc() : super(const SearchSeriesState()) {
    on<MakeQuery>((event, emit) async {
      if (state.isLoading || event.query.length < 3) {
        return; //TODO: add debouncer
      }
      page = 1;
      emit(state.copyWith(isLoading: true, lastQuery: event.query));
      try {
        final series = await repository.getSearchList(page, event.query);
        emit(state.copyWith(isLoading: false, series: series));
      } catch (e) {
        if (kDebugMode) {
          print(e);
        }
        emit(state.copyWith(isLoading: false, isError: true));
      }
    });
  }
}
