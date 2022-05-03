import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:woo_test_app/blocs/filter_cubit.dart';
import 'package:woo_test_app/blocs/markets_bloc.dart';
import 'package:woo_test_app/blocs/sort_cubit.dart';
import 'package:woo_test_app/data/models/market.dart';
import 'package:woo_test_app/pages/widgets/sort.dart';

class MarketsTableView extends StatefulWidget {
  final Filter filter;
  const MarketsTableView({Key? key, required this.filter}) : super(key: key);

  @override
  State<MarketsTableView> createState() => _MarketsTableViewState();
}

class _MarketsTableViewState extends State<MarketsTableView>
    with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return BlocProvider(
      create: (context) => SortCubit(
        initialState: widget.filter.defaultSortState,
      ),
      child: BlocProvider(
        create: (context) => MarketsBloc(
          filter: widget.filter,
          searchCubit: context.read(),
          sortCubit: context.read(),
          marketsRepository: RepositoryProvider.of(context),
        ),
        child: const MarketsTable(),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}

class MarketsTable extends StatelessWidget {
  const MarketsTable({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: const [
        MarketsTableHeader(),
        Expanded(child: MarketsTableBody()),
      ],
    );
  }
}

class MarketsTableHeader extends StatelessWidget {
  const MarketsTableHeader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 48,
      child: Row(
        children: const [
          Expanded(
            child: SortOptionView(
              label: 'Symbol',
              sortOption: SortOption.symbol,
            ),
          ),
          VerticalDivider(width: 1),
          Expanded(
            child: SortOptionView(
              label: 'Last Price',
              sortOption: SortOption.lastPrice,
            ),
          ),
          VerticalDivider(width: 1),
          Expanded(
            child: SortOptionView(
              label: 'Volume',
              sortOption: SortOption.volume,
            ),
          ),
        ],
      ),
    );
  }
}

class MarketsTableBody extends StatelessWidget {
  const MarketsTableBody({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MarketsBloc, MarketsState>(
      builder: (context, state) {
        if (state.markets.isEmpty) {
          return const Center(
            child: Text('No elements'),
          );
        }
        return ListView.builder(
          itemCount: state.markets.length,
          itemBuilder: (context, index) {
            return MarketsTableRow(item: state.markets[index]);
          },
        );
      },
    );
  }
}

class MarketsTableRow extends StatelessWidget {
  final Market item;

  const MarketsTableRow({
    Key? key,
    required this.item,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: Text(item.symbol),
        trailing: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Text(_formatPrice(item.lastPrice)),
            Text(_formatVolume(item.volume)),
          ],
        ),
      ),
    );
  }

  String _formatPrice(double price) {
    return "\$$price"
        .replaceAll(
          RegExp(r"\.?0+$"),
          "",
        )
        .trim();
  }

  String _formatVolume(double volume) {
    const postfixes = ["K", "M", "B"];

    var i = -1;
    for (; i < postfixes.length - 1; ++i) {
      final newVolume = volume / 1000;
      if (newVolume < 1) {
        break;
      }
      volume = newVolume;
    }
    final postfix = postfixes[i];
    final formattedVolume = volume.toStringAsFixed(2).replaceAll(
          RegExp(r"\.?0+$"),
          "",
        );
    return "\$$formattedVolume$postfix";
  }
}
// <<< Widgets
