part of 'search_series_bloc.dart';

class SearchSeriesState extends Equatable {
  final bool isLoading;
  final bool isLastBatch;
  final bool isError;
  final List<Serie> series;
  final String lastQuery; //TODO: save to prefs or db

  const SearchSeriesState(
      {this.isLoading = false,
      this.isLastBatch = false,
      this.isError = false,
      this.series = const [],
      this.lastQuery = ''});

  SearchSeriesState copyWith(
          {bool? isLoading,
          bool? isLastBatch,
          bool? isError,
          List<Serie>? series,
          String? lastQuery}) =>
      SearchSeriesState(
          isLoading: isLoading ?? this.isLoading,
          isLastBatch: isLastBatch ?? this.isLastBatch,
          isError: isError ?? this.isError,
          series: series ?? this.series,
          lastQuery: lastQuery ?? this.lastQuery);

  @override
  List<Object> get props =>
      [isLoading, isLastBatch, isError, series, lastQuery];
}
