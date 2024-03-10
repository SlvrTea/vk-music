
class Artist {
  final String id;
  final String domain;
  final String name;

  Artist({
    required this.id,
    required this.domain,
    required this.name
  });

  factory Artist.fromMap(Map<String, dynamic> map) {
    return Artist(
      id: map['id'],
      domain: map['domain'],
      name: map['name']
    );
  }
}