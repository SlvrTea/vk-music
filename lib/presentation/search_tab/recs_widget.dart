
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vk_music/domain/state/search/search_cubit.dart';
import 'package:vk_music/presentation/song_list/lazy_load_music_list.dart';

class RecsWidget extends StatelessWidget {
  const RecsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final state = (context.watch<SearchCubit>().state as SearchRecommendations);
    return LazyLoadMusicList(songs: state.recs, withMenu: true);
  }
}
