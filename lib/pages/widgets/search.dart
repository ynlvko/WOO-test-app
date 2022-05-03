import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:woo_test_app/blocs/search_cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class Search extends HookWidget {
  const Search({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final textController = _setupTextController(context);
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SizedBox(
        child: TextField(
          controller: textController,
          decoration: const InputDecoration(hintText: 'Search'),
        ),
      ),
    );
  }

  TextEditingController _setupTextController(BuildContext context) {
    final cubit = context.watch<SearchCubit>();
    final textController = useTextEditingController();
    if (textController.text != cubit.state) {
      textController.text = cubit.state;
    }

    useEffect(
      () {
        textController.addListener(() => cubit.setQuery(textController.text));
        return textController.dispose;
      },
      [textController],
    );

    return textController;
  }
}
