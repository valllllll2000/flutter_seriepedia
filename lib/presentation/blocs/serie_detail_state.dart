part of 'serie_detail_bloc.dart';

class SerieDetailState extends Equatable {
  final Serie? serie;
  final bool isLoading;
  final bool isError;

  const SerieDetailState(
      {this.serie, this.isLoading = false, this.isError = false});

  @override
  List<Object?> get props => [serie, isLoading, isLoading];

  SerieDetailState copyWith({Serie? serie, bool? isLoading, bool? isError}) =>
      SerieDetailState(
          serie: serie ?? this.serie,
          isLoading: isLoading ?? this.isLoading,
          isError: isError ?? this.isError);
}
