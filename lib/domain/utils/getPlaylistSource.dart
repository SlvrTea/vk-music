
import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';

import '../models/player_playlist.dart';
import '../models/song.dart';

PlayerPlaylist getPlaylistSource(List<Song> songs) {
  final List<AudioSource> sources = [];
  for (var song in songs) {
    sources.add(
      AudioSource.uri(
        Uri.parse(song.url),
        tag: MediaItem(
          id: song.id.toString(),
          title: song.title,
          artist: song.artist,
          artUri: song.photoUrl68 != null ? Uri.tryParse(song.photoUrl68!) : null
        )
      )
    );
  }
  return PlayerPlaylist(sources: sources, songs: songs);
}