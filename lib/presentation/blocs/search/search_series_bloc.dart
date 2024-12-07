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
    on<MakeQuery>(_downloadSearchResults);
    on<LoadNextPage>(_loadMoreItems);
  }

  void _downloadSearchResults(
      MakeQuery event, Emitter<SearchSeriesState> emit) async {
    var query = event.query;
    if (state.isLoading ||
        query.isEmpty ||
        query == state.lastQuery ||
        query.length < 2) {
      print('Make query: will skip query $query');
      return;
    }
    print('Make query: will make query $query');
    page = 1;
    emit(state.copyWith(isLoading: true, lastQuery: query));
    try {
      //delay to simulate slower internet
      await Future.delayed(const Duration(milliseconds: 300));
      final series = await repository.getSearchList(page, query);
      emit(state.copyWith(isLoading: false, series: {...series}));
      print('Make query: results returned: ${series.length}');
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      emit(state.copyWith(isLoading: false, isError: true, series: {}));
    }
  }

  Future<void> downloadAndEmitResults(
      Emitter<SearchSeriesState> emit, String query) async {
    emit(state.copyWith(isLoading: true, lastQuery: query));
    try {
      //delay to simulate slower internet
      await Future.delayed(const Duration(milliseconds: 300));
      final series = await repository.getSearchList(page, query);
      emit(state.copyWith(isLoading: false, series: {...series}));
      print('Make query: results returned: ${series.length}');
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      emit(state.copyWith(isLoading: false, isError: true, series: {}));
    }
  }

  Future<void> _loadMoreItems(
      LoadNextPage event, Emitter<SearchSeriesState> emit) async {
    var query = state.lastQuery;
    if (state.isLoading ||
        query.isEmpty ||
        query.length < 2 ||
        state.isLastBatch) {
      print('Make query: will skip load more query $query');
      return;
    }
    page++;
    emit(state.copyWith(isLoading: true, lastQuery: query));
    try {
      //delay to simulate slower internet
      await Future.delayed(const Duration(milliseconds: 300));
      final series = await repository.getSearchList(page, query);
      if (series.isNotEmpty) {
        emit(state
            .copyWith(isLoading: false, series: {...state.series, ...series}));
      } else {
        emit(state.copyWith(isLoading: false, isLastBatch: true));
      }
      print('Make query: results returned: ${series.length}');
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      emit(state.copyWith(isLoading: false, isError: true, series: {}));
    }
  }
}
