class Song {
  final String artist;
  final String title;
  final String duration;
  final String? accessKey;
  final String? id;
  final String? url;
  final String? photoUrl34;
  final String? photoUrl68;
  final String? photoUrl135;
  final bool online;
  Song({
      required this.artist,
      required this.title,
      required this.duration,
      required this.accessKey,
      required this.id,
      required this.url,
      this.photoUrl34,
      this.photoUrl68,
      this.photoUrl135,
      required this.online
    });

  factory Song.fromMap({required Map<String, dynamic> map}) {
    return Song(
      artist: map['artist'].toString().replaceAll("/", "&"),
      title: map['title'].toString().replaceAll("/", "&"),
      duration: map['duration'].toString(),
      accessKey: map['access_key']?.toString() ?? '',
      url: map['url']?.toString() ?? '',
      photoUrl34: map['album']?['thumb']?['photo_34'].toString(),
      photoUrl68: map['album']?['thumb']?['photo_68'].toString(),
      photoUrl135: map['album']?['thumb']?['photo_135'].toString(),
      id: '${map['owner_id']}${map['id']}',
      online: true,
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
    String? url,
    String? photoUrl34,
    String? photoUrl68,
    String? photoUrl135,
    bool? online,
  }) {
    return Song(
      artist: artist ?? this.artist,
      title: title ?? this.title,
      duration: duration ?? this.duration,
      accessKey: accessKey ?? this.accessKey,
      id: id ?? this.id,
      url: url ?? this.url,
      photoUrl34: photoUrl34 ?? this.photoUrl34,
      photoUrl68: photoUrl68 ?? this.photoUrl68,
      photoUrl135: photoUrl135 ?? this.photoUrl135,
      online: online ?? this.online,
    );
  }
}
