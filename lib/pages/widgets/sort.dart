import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:woo_test_app/blocs/sort_cubit.dart';

class SortOptionView extends StatelessWidget {
  final String label;
  final SortOption sortOption;

  const SortOptionView({
    Key? key,
    required this.label,
    required this.sortOption,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SortCubit, SortState>(
      builder: (context, state) {
        return SortOptionWidget(
          label: label,
          sortType: state.sortOption == sortOption ? state.sortType : null,
          onPressed: () => context
              .read<SortCubit>()
              .onSortOptionPressed(sortOption: sortOption),
        );
      },
    );
  }
}

class SortOptionWidget extends StatelessWidget {
  final String label;
  final SortType? sortType;
  final VoidCallback onPressed;

  const SortOptionWidget({
    Key? key,
    required this.label,
    required this.sortType,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: sortType == null || sortType == SortType.defalt
              ? Colors.blueGrey
              : Colors.amber,
        ),
        child: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(label),
              if (sortType == SortType.asc)
                const Icon(Icons.arrow_downward, size: 14)
              else if (sortType == SortType.desc)
                const Icon(Icons.arrow_upward, size: 14)
            ],
          ),
        ),
      ),
    );
  }
}
