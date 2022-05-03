import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:woo_test_app/blocs/filter_cubit.dart';
import 'package:woo_test_app/blocs/search_cubit.dart';
import 'package:woo_test_app/pages/widgets/markets.dart';
import 'package:woo_test_app/pages/widgets/search.dart';

class HomeView extends StatelessWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => FilterCubit(),
      child: BlocProvider(
        create: (context) => SearchCubit(filterCubit: context.read()),
        child: const HomePage(),
      ),
    );
  }
}

class HomePage extends HookWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final tabController = _setupTabController(context);
    return Scaffold(
      appBar: AppBar(
        title: TabBar(
          controller: tabController,
          tabs: Filter.values.map((e) => Tab(text: e.asString)).toList(),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Search(),
          Expanded(
            child: TabBarView(
              controller: tabController,
              children: Filter.values
                  .map((e) => MarketsTableView(filter: e))
                  .toList(),
            ),
          ),
        ],
      ),
    );
  }

  TabController _setupTabController(BuildContext context) {
    final tabController = useTabController(initialLength: 3);

    useEffect(() {
      tabController.addListener(() {
        context
            .read<FilterCubit>()
            .setFilter(Filter.values[tabController.index]);
      });
      return tabController.dispose;
    }, [tabController]);

    return tabController;
  }
}

extension StringExtension on Filter {
  String get asString {
    switch (this) {
      case Filter.all:
        return "All";
      case Filter.spot:
        return "Spot";
      case Filter.futures:
        return "Futures";
    }
  }
}
