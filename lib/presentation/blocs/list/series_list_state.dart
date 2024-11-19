part of 'series_list_bloc.dart';

class SeriesListState extends Equatable {
  final bool isLoading;
  final bool isLastBatch;
  final bool isError;
  final Set<Serie> series;

  const SeriesListState(
      {this.isLoading = false,
      this.isLastBatch = false,
      this.isError = false,
      this.series = const {}});

  SeriesListState copyWith({bool? isLoading, bool? isLastBatch, bool? isError,
          Set<Serie>? series}) =>
      SeriesListState(
          isLoading: isLoading ?? this.isLoading,
          isLastBatch: isLastBatch ?? this.isLastBatch,
          isError: isError ?? this.isError,
          series: series ?? this.series);

  @override
  List<Object> get props => [isLoading, isLastBatch, isError, series];
}
