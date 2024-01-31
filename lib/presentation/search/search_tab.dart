
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vk_music/domain/state/search/search_cubit.dart';
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
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: _controller,
                onChanged: (value) => setState(() {}),
                decoration: InputDecoration(
                  prefixIcon: IconButton(
                    onPressed: () {
                      cubit.search(_controller.text, count: 20);
                    },
                    icon: const Icon(Icons.search_rounded, color: Colors.white)
                  ),
                  suffixIcon: IconButton(
                    onPressed: () {
                      if (_controller.text.isNotEmpty) {
                        _controller.clear();
                        cubit.getRecommendations();
                      }
                    },
                    icon: const Icon(Icons.clear_rounded, color: Colors.white),
                  )
                ).applyDefaults(_inputDecoration),
              ),
            ),
            (state is SearchFinishedState)
                ? MusicList(songList: state.searchResult)
                : (state is SearchRecommendations)
                ? MusicList(songList: state.recs)
                : const Center(child: CircularProgressIndicator())
          ],
        ),
      ),
    );
  }
}

final _inputDecoration = InputDecorationTheme(
  focusedBorder: OutlineInputBorder(
      borderSide: const BorderSide(color: Colors.white, width: 2.0),
      borderRadius: BorderRadius.circular(16)),
  enabledBorder: OutlineInputBorder(
      borderSide: const BorderSide(color: Colors.white, width: 2.0),
      borderRadius: BorderRadius.circular(16)),
);