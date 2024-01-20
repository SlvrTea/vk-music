import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:vk_music/data/vk_api/vk_music.dart';
import 'package:vk_music/domain/models/playlist.dart';

part 'playlists_state.dart';

class PlaylistsCubit extends Cubit<PlaylistsState> {
  PlaylistsCubit(this.vkApi) : super(PlaylistsInitial());
  
  final VKApi vkApi;
  
  Future<void> getPlaylists() async => emit(PlaylistsLoadedState(await vkApi.music.getPlaylists(args: 'count=200')));
}
