import 'package:elementary/elementary.dart';
import 'package:vk_music/data/models/response/search/search_response/search_response.dart';

import '../../../../../domain/audio/audio_repository.dart';

abstract interface class IAllSongsModel extends ElementaryModel {
  Future<SearchResponse> search({required String q, int? count, int? offset});
}

class AllSongsModel extends IAllSongsModel {
  AllSongsModel(this._audioRepository);

  final AudioRepository _audioRepository;

  @override
  Future<SearchResponse> search({required String q, int? count, int? offset}) async {
    final res = await _audioRepository.search(query: q, count: count, offset: offset);
    return res;
  }
}
