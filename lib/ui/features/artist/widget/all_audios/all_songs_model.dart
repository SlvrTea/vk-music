import 'package:elementary/elementary.dart';
import 'package:vk_music/data/models/response/get/get_response.dart';

import '../../../../../domain/audio/audio_repository.dart';

abstract interface class IAllSongsModel extends ElementaryModel {
  Future<GetResponse> search({required String artistId, int? count, int? offset});
}

class AllSongsModel extends IAllSongsModel {
  AllSongsModel(this._audioRepository);

  final AudioRepository _audioRepository;

  @override
  Future<GetResponse> search({required String artistId, int? count, int? offset}) async {
    final res = await _audioRepository.getAudiosByArtist(artistId: artistId, count: count, offset: offset);
    return res;
  }
}
