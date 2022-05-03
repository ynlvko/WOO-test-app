import 'package:woo_test_app/blocs/filter_cubit.dart';
import 'package:woo_test_app/data/models/market.dart';
import 'package:woo_test_app/data/specs/specification.dart';

class FilterMarketSpecification implements Specification<Market> {
  final Filter filter;

  const FilterMarketSpecification({required this.filter});

  @override
  bool isSatisfiedBy(Market target) => filter.apply(target);
}

class SearchMarketSpecification implements Specification<Market> {
  final String searchQuery;

  const SearchMarketSpecification({required this.searchQuery});

  @override
  bool isSatisfiedBy(Market target) =>
      target.symbol.toLowerCase().contains(searchQuery.toLowerCase());
}

extension PredicateExtension on Filter {
  bool apply(Market market) {
    switch (this) {
      case Filter.all:
        return true;
      case Filter.spot:
        return market.type == MarketType.spot;
      case Filter.futures:
        return market.type == MarketType.futures;
    }
  }
}
