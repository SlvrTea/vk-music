
import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';

import '../../data/models/song/song.dart';

class PlayerPlaylist {
  PlayerPlaylist({required this.sources, required this.songs});

  final List<AudioSource> sources;
  final List<Song> songs;

  factory PlayerPlaylist.formSongList(List<Song> songs) {
    return PlayerPlaylist(
      sources: songs.map((song) => AudioSource.uri(
        Uri.parse(song.url),
        tag: MediaItem(
            id: song.id.toString(),
            title: song.title,
            artist: song.artist,
            artUri: song.album?.thumb.photo600 != null ? Uri.tryParse(song.album!.thumb.photo600!) : null
        )
      )).toList(),
      songs: songs
    );
  }
}