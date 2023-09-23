import 'package:bloc/bloc.dart';
import 'package:flutter_poster_list_test/src/data/fake_data.dart';
import 'package:flutter_poster_list_test/src/models/common/error_state_model.dart';
import 'package:flutter_poster_list_test/src/models/poster/movie_model.dart';
import 'package:meta/meta.dart';

part 'poster_state.dart';

class PosterCubit extends Cubit<PosterState> {
  PosterCubit() : super(PosterInitial());

  Future<void> fetchFakeData() async {
    emit(PosterLoading());
    try {
      /// Call Delay Function
      ///
      /// Simulate an API call by waiting for a few seconds (only for demo).
      await Future.delayed(const Duration(seconds: 1));

      /// Access the fake data from the imported file.
      ///
      final List<Map<String, dynamic>> fakeMovies = fakeApiResponse['data'];

      /// Return data using emit()
      ///
      final List<MovieData> movies =
          fakeMovies.map((data) => MovieData.fromJson(data)).toList();

      emit(PosterSuccess(movies));
    } catch (e) {
      /// Catch error and pass to [ErrorState] model
      ///
      ErrorState error = ErrorState(title: "Error", message: e.toString());
      emit(PosterError(error));
    }
  }
}
