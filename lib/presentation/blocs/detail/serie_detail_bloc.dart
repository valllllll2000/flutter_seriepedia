import 'package:cinemapedia/domain/repositories/serie_repository.dart';
import 'package:cinemapedia/infrastructure/datasources/series_moviedb_datasource.dart';
import 'package:cinemapedia/infrastructure/repositories/series_repository_impl.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../domain/entities/serie.dart';

part 'serie_detail_event.dart';

part 'serie_detail_state.dart';

class SerieDetailBloc extends Bloc<LoadSerieDetailEvent, SerieDetailState> {
  //TODO: inject this
  final SeriesRepository repository =
      SeriesRepositoryImpl(datasource: SeriesMovieDbDatasource());

  SerieDetailBloc() : super(const SerieDetailState()) {
    on<LoadSerieDetailEvent>((event, emit) async {
      try {
        emit(state.copyWith(isLoading: true));
        await Future.delayed(const Duration(milliseconds: 300));
        final serie = await repository.getSerie(event.serieId);
        emit(state.copyWith(
            isError: serie == null, isLoading: false, serie: serie));
      } catch (e) {
        if (kDebugMode) {
          print(e);
        }
        emit(state.copyWith(isError: true, isLoading: false));
      }
    });
  }
}
