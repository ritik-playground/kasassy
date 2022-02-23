import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kasassy/constants/palette.dart';
import 'package:kasassy/constants/widgets.dart';
import 'package:kasassy/search/cubit/search_cubit.dart';
import 'package:kasassy/search/widgets/no_content.dart';
import 'package:kasassy/search/widgets/search_results.dart';

// ignore: must_be_immutable
class Search extends StatelessWidget {
  Search({Key? key}) : super(key: key);

  TextEditingController searchController = TextEditingController();

  static Route route(SearchCubit cubit) {
    return MaterialPageRoute<void>(
      builder: (_) => BlocProvider.value(
        value: cubit,
        child: Search(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          autofocus: true,
          style: const TextStyle(color: Palette.whiteColor),
          controller: searchController,
          cursorColor: Palette.whiteColor,
          keyboardType: TextInputType.text,
          textInputAction: TextInputAction.search,
          textCapitalization: TextCapitalization.words,
          decoration: const InputDecoration.collapsed(
            hintStyle: TextStyle(color: Palette.whiteColor),
            hintText: 'Search for a user...',
          ),
          onSubmitted: (query) {
            context.read<SearchCubit>().searchStart(query);
            FocusScope.of(context).requestFocus(
              FocusNode(),
            );
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(
              Icons.clear,
            ),
            onPressed: () {
              searchController.clear();
              FocusScope.of(context).requestFocus(
                FocusNode(),
              );
            },
          ),
        ],
      ),
      body: BlocBuilder<SearchCubit, SearchState>(
        builder: (context, state) {
          if (state is SearchInitial) {
            return const NoContent(
              displayText: 'Find Users',
            );
          }
          if (state is SearchEmpty) {
            return const NoContent(
              displayText: 'No Users Found',
            );
          }
          if (state is SearchLoaded) {
            return SearchResults(
              searchUserResults: state.searchUserResults,
            );
          } else {
            return Progress.circularProgress();
          }
        },
      ),
    );
  }
}
