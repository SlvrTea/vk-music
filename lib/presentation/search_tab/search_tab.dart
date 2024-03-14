import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vk_music/domain/state/search/search_cubit.dart';
import 'package:vk_music/presentation/search_tab/recs_widget.dart';
import 'package:vk_music/presentation/search_tab/search_result.dart';

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
          if (state is SearchRecommendations) {
            search.getRecommendations(offset: state.recs.length);
          } else if (state is SearchFinishedState) {
            search.loadMore(_controller.text, offset: state.searchResult.length);
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
          if (state is SearchRecommendations) const SliverToBoxAdapter(child: RecsWidget()),
          if (state is SearchFinishedState) const SearchResult(),
          if (state is SearchProgressState) const SliverToBoxAdapter(
            child: Center(child: CircularProgressIndicator())
          )
        ],
      ),
    );
  }
}