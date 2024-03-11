
class Artist {
  final String id;
  final String domain;
  final String name;
  final String? photo;

  Artist({
    required this.id,
    required this.domain,
    required this.name,
    required this.photo
  });

  factory Artist.fromMap(Map<String, dynamic> map) {
    return Artist(
      id: map['id'],
      domain: map['domain'],
      name: map['name'],
      photo: map['photos']?[0]?['photo']?.last['url']
    );
  }

  @override
  String toString() => 'Artist: $name, $id, $domain';
}