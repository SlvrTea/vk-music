
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../song_list/lazy_load_music_list.dart';
import '../../domain/state/search_cubit.dart';

class RecsWidget extends StatelessWidget {
  const RecsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final cubit = context.watch<SearchCubit>();
    final state = cubit.state;
    if (state.songs == null) {
      return const Center(child: CircularProgressIndicator());
    }
    return LazyLoadMusicList(songs: state.songs!, withMenu: true);
  }
}
