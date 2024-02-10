
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vk_music/domain/state/search/search_cubit.dart';
import 'package:vk_music/presentation/search/search_result.dart';
import 'package:vk_music/presentation/song_list/music_list.dart';

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
    final state = cubit.state;
    if (state is SearchInitial) {
      cubit.getRecommendations();
    }
    return NotificationListener<ScrollEndNotification>(
      onNotification: (scrollEnd) {
        final metrics = scrollEnd.metrics;
        if (metrics.atEdge && metrics.pixels == metrics.maxScrollExtent) {
          if (state is SearchRecommendations) {
            cubit.getRecommendations(offset: state.recs.length);
          } else if (state is SearchFinishedState) {
            cubit.loadMore(_controller.text, offset: state.searchResult.length);
          }
        }
        return true;
      },
      child: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          // SliverToBoxAdapter(
          //   child: Padding(
          //     padding: const EdgeInsets.all(8.0),
          //     child: TextField(
          //       controller: _controller,
          //       onChanged: (value) => setState(() {}),
          //       decoration: InputDecoration(
          //           prefixIcon: IconButton(
          //               onPressed: () {
          //                 cubit.search(_controller.text, count: 20);
          //               },
          //               icon: const Icon(Icons.search_rounded, color: Colors.white)
          //           ),
          //           suffixIcon: IconButton(
          //             onPressed: () {
          //               if (_controller.text.isNotEmpty) {
          //                 _controller.clear();
          //                 cubit.getRecommendations();
          //               }
          //             },
          //             icon: const Icon(Icons.clear_rounded, color: Colors.white),
          //           )
          //       ).applyDefaults(_inputDecoration),
          //     ),
          //   ),
          // ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: SearchBar(
                controller: _controller,
                leading: IconButton(
                  onPressed: () => cubit.search(_controller.text),
                  icon: const Icon(Icons.search_rounded, color: Colors.white)
                ),
                onSubmitted: (text) => cubit.search(_controller.text, count: 20),
                trailing: [
                  IconButton(
                    onPressed: () {
                      if (_controller.text.isNotEmpty) cubit.getRecommendations();
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
          (state is SearchFinishedState)
              ? const SearchResult()
              : (state is SearchRecommendations)
              ? SliverToBoxAdapter(child: MusicList(songList: state.recs))
              : const SliverToBoxAdapter(child: Center(child: CircularProgressIndicator())),
        ],
      ),
    );
  }
}