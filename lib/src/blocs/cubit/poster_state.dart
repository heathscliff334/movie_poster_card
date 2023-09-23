part of 'poster_cubit.dart';

@immutable
sealed class PosterState {}

final class PosterInitial extends PosterState {}

final class PosterLoading extends PosterState {}

final class PosterError extends PosterState {
  final ErrorState error;
  PosterError(this.error);
}

final class PosterSuccess extends PosterState {
  final List<MovieData> data;
  PosterSuccess(this.data);
}
