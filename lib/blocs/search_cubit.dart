import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:woo_test_app/blocs/filter_cubit.dart';

class SearchCubit extends Cubit<String> {
  late final StreamSubscription _filterStreamSubscription;

  SearchCubit({required FilterCubit filterCubit}) : super("") {
    _filterStreamSubscription = filterCubit.stream.distinct().listen(
      (event) {
        setQuery("");
      },
    );
  }

  @override
  Future<void> close() {
    _filterStreamSubscription.cancel();
    return super.close();
  }

  void setQuery(String query) => emit(query);
}
