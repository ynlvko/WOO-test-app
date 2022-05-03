import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:woo_test_app/blocs/filter_cubit.dart';
import 'package:woo_test_app/data/models/market.dart';

enum SortOption { symbol, lastPrice, volume }

extension SortKeyMarketExtension on SortOption {
  Comparable Function(Market market) get sortKey {
    switch (this) {
      case SortOption.symbol:
        return (Market market) =>
            "${market.base}${market.quote}${describeEnum(market.type)}";
      case SortOption.lastPrice:
        return (Market market) => market.lastPrice;
      case SortOption.volume:
        return (Market market) => market.volume;
    }
  }
}

enum SortType { defalt, asc, desc }

extension CompareMarketExtension on SortType {
  int Function(Comparable a, Comparable b) get compare {
    switch (this) {
      case SortType.defalt:
        return (a, b) => 0;
      case SortType.asc:
        return (a, b) => a.compareTo(b);
      case SortType.desc:
        return (a, b) => b.compareTo(a);
    }
  }
}

extension DefaultSortExtension on Filter {
  SortState get defaultSortState {
    switch (this) {
      case Filter.all:
        return const SortState(
            sortOption: SortOption.symbol, sortType: SortType.asc);
      case Filter.spot:
      case Filter.futures:
        return const SortState(
          sortOption: SortOption.volume,
          sortType: SortType.desc,
        );
    }
  }
}

class SortCubit extends Cubit<SortState> {
  SortCubit({required SortState initialState}) : super(initialState);

  void onSortOptionPressed({required SortOption sortOption}) {
    final newState = SortState(
      sortOption: _calculateSortOption(sortOption),
      sortType: _calculateSortType(sortOption),
    );
    return emit(newState);
  }

  SortOption? _calculateSortOption(SortOption sortOption) {
    if (sortOption != state.sortOption) {
      return sortOption;
    }
    final isLastSortType = state.sortType.index == SortType.values.length - 1;
    return isLastSortType ? null : sortOption;
  }

  SortType _calculateSortType(SortOption sortOption) {
    if (sortOption != state.sortOption) {
      return SortType.asc;
    }
    final nextIndex = (state.sortType.index + 1) % SortType.values.length;
    return SortType.values[nextIndex];
  }
}

class SortState {
  final SortOption? sortOption;
  final SortType sortType;

  const SortState({
    required this.sortOption,
    required this.sortType,
  });

  const SortState.empty()
      : sortOption = null,
        sortType = SortType.defalt;

  @override
  String toString() {
    return "SortState { $sortOption, $sortType }";
  }
}
