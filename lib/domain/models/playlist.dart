
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


  Playlist copyWith({String? title, String? description}) {
    return Playlist(
      title: title ?? this.title,
      description: description,
      ownerId: ownerId,
      id: id,
      accessKey: accessKey,
      isFollowing: isFollowing,
      isOwner: isOwner,
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
    return 'Playlist: $title, $id, $isOwner';
  }
}