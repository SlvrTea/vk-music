
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
  final String? accessKey;
  final String? ownerId;
  final bool isOwner;

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
    this.ownerId,
    this.isOwner = false,
    required this.accessKey
  });

  factory Playlist.fromMap({required Map<String, dynamic> map}) {
    return Playlist(
      title: map['title'].toString().replaceAll("/", "&"),
      description: map['description'].toString().replaceAll("/", "&").isEmpty ? null : map['description'].toString().replaceAll("/", "&"),
      accessKey: map['access_key']?.toString() ?? '',
      id: map['id'].toString(),
      ownerId: map['owner_id'].toString(),
      isOwner: map.containsKey('original') ? (map['original']?['owner_id'] == map['owner_id']) : true,
      photoUrl34: map['thumbs']?[0]?['photo_34']?.toString() ?? map['photo']?['photo_34']?.toString(),
      photoUrl68: map['thumbs']?[0]?['photo_68']?.toString() ?? map['photo']?['photo_68']?.toString(),
      photoUrl135: map['thumbs']?[0]?['photo_135']?.toString() ?? map['photo']?['photo_135']?.toString(),
      photoUrl270: map['thumbs']?[0]?['photo_270']?.toString() ?? map['photo']?['photo_270']?.toString(),
      photoUrl300: map['thumbs']?[0]?['photo_300']?.toString() ?? map['photo']?['photo_300']?.toString(),
      photoUrl600: map['thumbs']?[0]?['photo_600']?.toString() ?? map['photo']?['photo_600']?.toString(),
    );
  }

  Playlist copyWith({String? title, String? description}) {
    return Playlist(
      title: title ?? this.title,
      description: description,
      id: id,
      accessKey: accessKey,
      photoUrl600: photoUrl600,
      photoUrl300: photoUrl300,
      photoUrl270: photoUrl270,
      photoUrl135: photoUrl135,
      photoUrl68: photoUrl68,
      photoUrl34: photoUrl34
    );
  }
}