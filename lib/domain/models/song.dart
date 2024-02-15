
class Song {
  final String artist;
  final String title;
  final String duration;
  final String accessKey;
  final String id;
  final String ownerId;
  final String shortId;
  final String url;
  final String? photoUrl68;
  final String? photoUrl135;
  final String? photoUrl600;
  Song({
    required this.artist,
    required this.title,
    required this.duration,
    required this.accessKey,
    required this.id,
    required this.shortId,
    required this.ownerId,
    required this.url,
    this.photoUrl600,
    this.photoUrl68,
    this.photoUrl135,
  });

  factory Song.fromMap(Map<String, dynamic> map){
    return Song(
      artist: map['artist'].toString().replaceAll("/", "&"),
      title: map['title'].toString().replaceAll("/", "&"),
      duration: map['duration'].toString(),
      accessKey: map['access_key']?.toString() ?? '',
      url: map['url']?.toString() ?? '',
      id: '${map['owner_id']}_${map['id']}',
      shortId: map['id'].toString(),
      ownerId: map['owner_id'].toString(),
      photoUrl68: map['album']?['thumb']?['photo_68'].toString(),
      photoUrl135: map['album']?['thumb']?['photo_135'].toString(),
      photoUrl600: map['album']?['thumb']?['photo_600'].toString()
    );
  }

  @override
  String toString() {
    return 'Song(artist: $artist, title: $title, duration: $duration)';
  }

  @override
  bool operator ==(covariant Song other) {
    if (identical(this, other)) return true;

    return other.artist == artist &&
        other.title == title &&
        other.duration == duration;
  }

  @override
  int get hashCode {
    return artist.hashCode ^ title.hashCode ^ duration.hashCode;
  }

  Song copyWith({
    String? artist,
    String? title,
    String? duration,
    String? accessKey,
    String? id,
    String? shortId,
    String? ownerId,
    String? url,
    String? photoUrl34,
    String? photoUrl68,
    String? photoUrl135,
    String? photoUrl600
  }) {
    return Song(
      artist: artist ?? this.artist,
      title: title ?? this.title,
      duration: duration ?? this.duration,
      accessKey: accessKey ?? this.accessKey,
      id: id ?? this.id,
      shortId: shortId ?? this.shortId,
      ownerId: ownerId ?? this.ownerId,
      url: url ?? this.url,
      photoUrl600: photoUrl34 ?? this.photoUrl600,
      photoUrl68: photoUrl68 ?? this.photoUrl68,
      photoUrl135: photoUrl135 ?? this.photoUrl135,
    );
  }
}
