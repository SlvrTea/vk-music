import 'dart:ui';

import 'package:hive_ce/hive.dart';
import 'package:just_audio/just_audio.dart';
import 'package:vk_music/common/utils/config/app_config.dart';
import 'package:vk_music/data/models/artist/artist.dart';
import 'package:vk_music/data/models/artist/photo/artist_photo.dart';
import 'package:vk_music/data/models/playlist/cached_playlist.dart';
import 'package:vk_music/data/models/song/song_album/song_album.dart';
import 'package:vk_music/data/models/thumb/thumb.dart';
import 'package:vk_music/data/models/user/user.dart';
import 'package:vk_music/domain/model/player_audio.dart';


@GenerateAdapters([
  AdapterSpec<User>(),
  AdapterSpec<AppConfig>(),
  AdapterSpec<LoopMode>(),
  AdapterSpec<Color>(),
  AdapterSpec<Uri>(),
  AdapterSpec<PlayerAudioMP3>(),
  AdapterSpec<PlayerAudioM3U8>(),
  AdapterSpec<CachedPlaylist>(),
  AdapterSpec<SongAlbum>(),
  AdapterSpec<Artist>(),
  AdapterSpec<ArtistPhoto>(),
  AdapterSpec<Thumb>(),
])
part 'hive_adapters.g.dart';
