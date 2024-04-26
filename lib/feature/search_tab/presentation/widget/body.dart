
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vk_music/feature/search_tab/presentation/widget/recs_widget.dart';
import 'package:vk_music/feature/search_tab/presentation/widget/search_result.dart';

import '../../domain/state/search_cubit.dart';

class SearchTabBody extends StatefulWidget {
  const SearchTabBody({super.key});

  @override
  State<SearchTabBody> createState() => _SearchTabBodyState();
}

class _SearchTabBodyState extends State<SearchTabBody> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final search = context.watch<SearchCubit>();
    final state = search.state;
    return NotificationListener<ScrollEndNotification>(
      onNotification: (scrollEnd) {
        final metrics = scrollEnd.metrics;
        if (metrics.atEdge && metrics.pixels == metrics.maxScrollExtent) {
          if (state.query == null) {
            search.getRecommendations(offset: state.songs!.length);
          } else if (state.songs != null) {
            search.loadMore(_controller.text, offset: state.songs!.length);
          }
        }
        return true;
      },
      child: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: SearchBar(
                controller: _controller,
                leading: IconButton(
                  onPressed: () => search.search(_controller.text),
                  icon: const Icon(Icons.search_rounded, color: Colors.white)
                ),
                onSubmitted: (text) => search.search(_controller.text, count: 30),
                trailing: [
                  IconButton(
                    onPressed: () {
                      if (_controller.text.isNotEmpty) search.getRecommendations();
                      _controller.clear();
                    },
                    icon: const Icon(Icons.clear_rounded, color: Colors.white),
                  )
                ],
                backgroundColor: const MaterialStatePropertyAll(
                  Colors.transparent
                ),
              ),
            ),
          ),
          if (state.query == null) const SliverToBoxAdapter(child: RecsWidget()),
          if (state.query != null && state.songs != null) const SearchResult(),
        ],
      ),
    );
  }
}