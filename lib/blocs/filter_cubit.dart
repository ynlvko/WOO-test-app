import 'package:bloc/bloc.dart';

enum Filter { all, spot, futures }

class FilterCubit extends Cubit<Filter> {
  FilterCubit() : super(Filter.all);

  void setFilter(Filter filter) {
    emit(filter);
  }
}
