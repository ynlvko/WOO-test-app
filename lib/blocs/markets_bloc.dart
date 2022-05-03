import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:woo_test_app/blocs/filter_cubit.dart';
import 'package:woo_test_app/blocs/search_cubit.dart';
import 'package:woo_test_app/blocs/sort_cubit.dart';
import 'package:woo_test_app/data/models/market.dart';
import 'package:woo_test_app/data/repositories/markets_repository.dart';
import 'package:collection/collection.dart';
import 'package:woo_test_app/data/specs/market_specifications.dart';

abstract class MarketsEvent {
  const MarketsEvent();
}

class FilterMarketsEvent extends MarketsEvent {
  final String searchQuery;
  final SortState sortState;

  FilterMarketsEvent({
    required this.searchQuery,
    required this.sortState,
  });

  @override
  String toString() {
    return "FilterMarketsEvent { searchQuery=$searchQuery, sortState=$sortState }";
  }
}

class MarketsState {
  final List<Market> markets;
  final String searchQuery;
  final SortState sortState;

  const MarketsState({
    required this.markets,
    required this.searchQuery,
    required this.sortState,
  });

  MarketsState.empty()
      : markets = [],
        searchQuery = "",
        sortState = const SortState.empty();

  @override
  String toString() {
    return "MarketsState { markets=${markets.length}, searchQuery=$searchQuery, sortState=$sortState }";
  }
}

class MarketsBloc extends Bloc<MarketsEvent, MarketsState> {
  final Filter filter;
  final SearchCubit searchCubit;
  final SortCubit sortCubit;
  final MarketsRepository marketsRepository;

  late final StreamSubscription _searchStreamSubscription;
  late final StreamSubscription _sortStreamSubscription;

  MarketsBloc({
    required this.filter,
    required this.searchCubit,
    required this.sortCubit,
    required this.marketsRepository,
  }) : super(
          MarketsState.empty(),
        ) {
    on<FilterMarketsEvent>(_onFilterEvent);
    _setupSearchSubscription();
    _setupSortSubscription();
    add(
      FilterMarketsEvent(
        searchQuery: searchCubit.state,
        sortState: sortCubit.state,
      ),
    );
  }

  @override
  Future<void> close() {
    _searchStreamSubscription.cancel();
    _sortStreamSubscription.cancel();
    return super.close();
  }

  Future<void> _onFilterEvent(
    FilterMarketsEvent event,
    Emitter<MarketsState> emit,
  ) async {
    emit(
      MarketsState(
        markets: await _filterMarkets(
          filter,
          event.searchQuery,
          event.sortState,
        ),
        searchQuery: event.searchQuery,
        sortState: event.sortState,
      ),
    );
  }

  void _setupSearchSubscription() {
    _searchStreamSubscription = searchCubit.stream.listen(
      (searchQuery) => add(
        FilterMarketsEvent(
          searchQuery: searchQuery,
          sortState: state.sortState,
        ),
      ),
    );
  }

  void _setupSortSubscription() {
    _sortStreamSubscription = sortCubit.stream.listen(
      (sortState) => add(
        FilterMarketsEvent(
          searchQuery: state.searchQuery,
          sortState: sortState,
        ),
      ),
    );
  }

  Future<List<Market>> _filterMarkets(
    Filter filter,
    String searchQuery,
    SortState sortState,
  ) async {
    final filteredMarkets = await marketsRepository.getMarkets(
      [
        FilterMarketSpecification(filter: filter),
        SearchMarketSpecification(searchQuery: searchQuery),
      ],
    );
    final sortedMarkets = _sortMarkets(filteredMarkets, sortState);
    return sortedMarkets.toList();
  }

  Iterable<Market> _sortMarkets(Iterable<Market> markets, SortState sortState) {
    if (sortState.sortOption == null) {
      return markets;
    }
    return markets.sortedByCompare(
      sortState.sortOption!.sortKey,
      sortState.sortType.compare,
    );
  }
}
