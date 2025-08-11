import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:vk_music/common/utils/di/scopes/app_scope.dart';

import '../../data/models/artist/artist.dart';
import '../../data/models/song/song_album/song_album.dart';

abstract interface class PlayerAudio extends UriAudioSource {
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
            artUri: album?.thumb != null ? Uri.parse(album!.thumb!.photo600!) : null,
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
    if (AppGlobalDependency.isKateAuth ?? false) {
      return PlayerAudioMP3.fromJson(json);
    } else {
      return PlayerAudioM3U8.fromJson(json);
    }
  }

  Map<String, dynamic> toJson();

  PlayerAudio copyWith({
    Uri? uri,
    String? artist,
    int? id,
    int? ownerId,
    String? title,
    String? accessKey,
    SongAlbum? album,
    String? releaseAudioId,
    List<Artist>? mainArtists,
  });
}

final class PlayerAudioMP3 extends ProgressiveAudioSource implements PlayerAudio {
  PlayerAudioMP3(
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
            artUri: album?.thumb != null ? Uri.parse(album!.thumb!.photo600!) : null,
          ),
        );

  @override
  final String artist;
  @override
  final int id;
  @override
  final int ownerId;
  @override
  final String title;
  @override
  final String accessKey;
  @override
  SongAlbum? album;
  @override
  String? releaseAudioId;
  @override
  List<Artist>? mainArtists;

  factory PlayerAudioMP3.fromJson(Map<String, dynamic> json) {
    return PlayerAudioMP3(
      Uri.parse(json['url'].toString()),
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

  @override
  Map<String, dynamic> toJson() {
    return {
      'url': super.uri.toString(),
      'artist': artist,
      'id': id,
      'owner_id': ownerId,
      'title': title,
      'access_key': accessKey,
      'duration': super.duration?.inSeconds,
      'album': album?.toJson(),
      'release_audio_id': releaseAudioId,
      'main_artists': mainArtists?.map((e) => e.toJson()).toList(),
    };
  }

  @override
  String toString() {
    return 'Player Audio MP3: $title, $artist';
  }

  @override
  PlayerAudio copyWith({
    Uri? uri,
    String? artist,
    int? id,
    int? ownerId,
    String? title,
    String? accessKey,
    SongAlbum? album,
    String? releaseAudioId,
    List<Artist>? mainArtists,
  }) {
    return PlayerAudioMP3(
      uri ?? super.uri,
      duration: super.duration,
      artist: artist ?? this.artist,
      id: id ?? this.id,
      ownerId: ownerId ?? this.ownerId,
      title: title ?? this.title,
      accessKey: accessKey ?? this.accessKey,
      album: album ?? this.album,
      releaseAudioId: releaseAudioId ?? this.releaseAudioId,
      mainArtists: mainArtists ?? this.mainArtists,
    );
  }
}

final class PlayerAudioM3U8 extends HlsAudioSource implements PlayerAudio {
  PlayerAudioM3U8(
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
            artUri: album?.thumb != null ? Uri.parse(album!.thumb!.photo600!) : null,
          ),
        );

  @override
  final String artist;
  @override
  final int id;
  @override
  final int ownerId;
  @override
  final String title;
  @override
  final String accessKey;
  @override
  SongAlbum? album;
  @override
  String? releaseAudioId;
  @override
  List<Artist>? mainArtists;

  factory PlayerAudioM3U8.fromJson(Map<String, dynamic> json) {
    return PlayerAudioM3U8(
      Uri.parse(json['url'].toString()),
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

  @override
  Map<String, dynamic> toJson() {
    return {
      'url': super.uri.toString(),
      'artist': artist,
      'id': id,
      'owner_id': ownerId,
      'title': title,
      'access_key': accessKey,
      'duration': super.duration?.inSeconds,
      'album': album?.toJson(),
      'release_audio_id': releaseAudioId,
      'main_artists': mainArtists?.map((e) => e.toJson()).toList(),
    };
  }

  @override
  String toString() {
    return 'Player Audio M3U8: $title, $artist';
  }

  @override
  PlayerAudio copyWith({
    Uri? uri,
    String? artist,
    int? id,
    int? ownerId,
    String? title,
    String? accessKey,
    SongAlbum? album,
    String? releaseAudioId,
    List<Artist>? mainArtists,
  }) {
    return PlayerAudioM3U8(
      uri ?? super.uri,
      duration: super.duration,
      artist: artist ?? this.artist,
      id: id ?? this.id,
      ownerId: ownerId ?? this.ownerId,
      title: title ?? this.title,
      accessKey: accessKey ?? this.accessKey,
      album: album ?? this.album,
      releaseAudioId: releaseAudioId ?? this.releaseAudioId,
      mainArtists: mainArtists ?? this.mainArtists,
    );
  }
}
