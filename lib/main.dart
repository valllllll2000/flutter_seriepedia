import 'package:cinemapedia/config/router/app_router.dart';
import 'package:cinemapedia/presentation/blocs/app_bloc_observer.dart';
import 'package:cinemapedia/presentation/blocs/favorites/favorites_bloc.dart';
import 'package:cinemapedia/presentation/blocs/list/series_list_bloc.dart';
import 'package:cinemapedia/presentation/blocs/search/search_series_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';

import 'config/theme/app_theme.dart';

Future main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  await dotenv.load(fileName: ".env");
  Bloc.observer = const AppBlocObserver();
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => FavoritesBloc(),
        ),
        BlocProvider(
          create: (context) => SeriesListBloc(),
        ),
        BlocProvider(
          create: (context) => SearchSeriesBloc(),
        ),
      ],
      child: MaterialApp.router(
        routerConfig: appRouter,
        debugShowCheckedModeBanner: false,
        theme: AppTheme().getTheme(),
      ),
    );
  }
}
