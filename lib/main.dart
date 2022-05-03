import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:woo_test_app/config/app_bloc_observer.dart';
import 'package:woo_test_app/data/repositories/markets_repository.dart';
import 'package:woo_test_app/pages/home_page.dart';
import 'package:woo_test_app/config/themes.dart';

void main() {
  BlocOverrides.runZoned(
    () => runApp(const App()),
    blocObserver: AppBlocObserver(),
  );
}

class App extends StatelessWidget {
  const App();

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider<MarketsRepository>(
      create: (context) => DefaultMarketsRepository(),
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: defaultThemeData,
        home: const HomeView(),
      ),
    );
  }
}
