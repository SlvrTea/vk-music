import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';

import '../../data/models/artist/artist.dart';
import '../../data/models/song/song_album/song_album.dart';

class PlayerAudio extends HlsAudioSource {
  PlayerAudio(
    super.url, {
    required this.artist,
    required this.id,
    required this.ownerId,
    required this.title,
    required super.duration,
    required this.accessKey,
    this.album,
    this.releaseAudioId,
    this.mainArtists,
  }) : super(
          tag: MediaItem(
            id: id.toString(),
            title: title,
            artist: artist,
            artUri: album?.thumb?.photo600 == null ? null : Uri.parse(album!.thumb!.photo600!),
          ),
        );

  final String artist;
  final int id;
  final int ownerId;
  final String title;
  final String accessKey;
  SongAlbum? album;
  String? releaseAudioId;
  List<Artist>? mainArtists;

  factory PlayerAudio.fromJson(Map<String, dynamic> json) {
    return PlayerAudio(
      Uri.parse(json['url']),
      duration: Duration(seconds: json['duration']),
      artist: json['artist'] as String,
      id: json['id'] as int,
      ownerId: json['owner_id'] as int,
      title: json['title'] as String,
      accessKey: json['access_key'] as String,
      album: json['album'] == null ? null : SongAlbum.fromJson(json['album'] as Map<String, dynamic>),
      releaseAudioId: json['release_audio_id'] as String?,
      mainArtists:
          (json['main_artists'] as List<dynamic>?)?.map((e) => Artist.fromJson(e as Map<String, dynamic>)).toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'url': super.uri,
      'artist': artist,
      'id': id,
      'owner_id': ownerId,
      'title': title,
      'accessKey': accessKey,
      'album': album?.toJson(),
      'release_audio_id': releaseAudioId,
      'main_artists': mainArtists?.map((e) => e.toJson()).toList(),
    };
  }
}
