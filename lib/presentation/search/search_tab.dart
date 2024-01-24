
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vk_music/domain/state/search/search_cubit.dart';

class SearchTab extends StatefulWidget {
  const SearchTab({super.key});

  @override
  State<SearchTab> createState() => _SearchTabState();
}

class _SearchTabState extends State<SearchTab> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
  }
  @override
  Widget build(BuildContext context) {
    final cubit = context.watch<SearchCubit>();
    if (cubit.state is SearchInitial) {
      cubit.search('123', count: 1);
    }
    return SingleChildScrollView(
      child: Column(
        children: [
          TextField(
            controller: _controller,
          )
        ],
      ),
    );
  }
}
