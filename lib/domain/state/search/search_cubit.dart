import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import '../../../data/vk_api/models/song.dart';
import '../../../data/vk_api/models/vk_api.dart';

part 'search_state.dart';

class SearchCubit extends Cubit<SearchState> {
  final VKApi vkApi;
  SearchCubit(this.vkApi) : super(SearchInitial());

  void search(String q, {int? count, int? offset}) async {
    emit(SearchProgressState());
    final result = await vkApi.music.method('audio.search',
        'q=$q&count=${count ?? ''}&offset=${offset ?? ''}');
    log(result.data.toString());
  }
}
