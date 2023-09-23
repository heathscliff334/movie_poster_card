import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_poster_list_test/src/blocs/cubit/poster_cubit.dart';
import 'package:flutter_poster_list_test/src/views/home/home_view.dart';

class AppWidget extends StatelessWidget {
  const AppWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        /// Registering Bloc / Cubit
        ///
        BlocProvider(create: (_) => PosterCubit()),
      ],
      child: MaterialApp(
        title: 'Poster App Demo',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(primarySwatch: Colors.blue, useMaterial3: true),
        home: HomeView(),
      ),
    );
  }
}
