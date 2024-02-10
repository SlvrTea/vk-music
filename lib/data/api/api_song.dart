
class ApiSong {
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

  ApiSong.fromApi(Map<String, dynamic> map):
    artist = map['artist'].toString().replaceAll("/", "&"),
    title = map['title'].toString().replaceAll("/", "&"),
    duration = map['duration'].toString(),
    accessKey = map['access_key']?.toString() ?? '',
    url = map['url']?.toString() ?? '',
    id = '${map['owner_id']}_${map['id']}',
    shortId = map['id'].toString(),
    ownerId = map['owner_id'].toString(),
    photoUrl68 = map['album']?['thumb']?['photo_68'].toString(),
    photoUrl135 = map['album']?['thumb']?['photo_135'].toString(),
    photoUrl600 = map['album']?['thumb']?['photo_600'].toString();
}