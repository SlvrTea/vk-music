
class Playlist {
  final String title;
  final String? description;
  final String id;
  final String? photoUrl34;
  final String? photoUrl68;
  final String? photoUrl135;
  final String? photoUrl270;
  final String? photoUrl300;
  final String? photoUrl600;
  final String accessKey;
  final String ownerId;
  final bool isOwner;
  final bool isFollowing;

  Playlist({
    required this.title,
    required this.description,
    required this.id,
    this.photoUrl34,
    this.photoUrl68,
    this.photoUrl135,
    this.photoUrl270,
    this.photoUrl300,
    this.photoUrl600,
    required this.ownerId,
    this.isFollowing = false,
    this.isOwner = false,
    required this.accessKey
  });

  factory Playlist.fromMap(Map<String, dynamic> map) {
    return Playlist(
      title: map['title'].toString().replaceAll("/", "&"),
      description: map['description'].toString().replaceAll("/", "&").isEmpty ? null : map['description'].toString().replaceAll("/", "&"),
      accessKey: map['access_key']?.toString() ?? '',
      id: map['id'].toString(),
      ownerId: map['owner_id'].toString(),
      isOwner: !(map.containsKey('followed')) || !(map.containsKey('original')),
      isFollowing: map.containsKey('followed'),
      photoUrl34: map['thumbs']?[0]?['photo_34']?.toString() ?? map['photo']?['photo_34']?.toString(),
      photoUrl68: map['thumbs']?[0]?['photo_68']?.toString() ?? map['photo']?['photo_68']?.toString(),
      photoUrl135: map['thumbs']?[0]?['photo_135']?.toString() ?? map['photo']?['photo_135']?.toString(),
      photoUrl270: map['thumbs']?[0]?['photo_270']?.toString() ?? map['photo']?['photo_270']?.toString(),
      photoUrl300: map['thumbs']?[0]?['photo_300']?.toString() ?? map['photo']?['photo_300']?.toString(),
      photoUrl600: map['thumbs']?[0]?['photo_600']?.toString() ?? map['photo']?['photo_600']?.toString(),
    );
  }


  Playlist copyWith({String? title, String? description, bool? isOwner}) {
    return Playlist(
      title: title ?? this.title,
      description: description,
      ownerId: ownerId,
      id: id,
      accessKey: accessKey,
      isFollowing: isFollowing,
      isOwner: isOwner ?? this.isOwner,
      photoUrl600: photoUrl600,
      photoUrl300: photoUrl300,
      photoUrl270: photoUrl270,
      photoUrl135: photoUrl135,
      photoUrl68: photoUrl68,
      photoUrl34: photoUrl34
    );
  }

  @override
  String toString() {
    return 'Playlist: $title, $id';
  }
}