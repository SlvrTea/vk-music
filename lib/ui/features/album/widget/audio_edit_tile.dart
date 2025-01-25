import 'package:flutter/material.dart';
import 'package:vk_music/domain/model/player_audio.dart';

import '../../../widgets/common/media_cover.dart';

class AudioEditTile extends StatefulWidget {
  const AudioEditTile({super.key, required this.audio, required this.onIconTap, required this.isAdded});

  final PlayerAudio audio;
  final VoidCallback onIconTap;
  final bool isAdded;

  @override
  State<AudioEditTile> createState() => _AudioEditTileState();
}

class _AudioEditTileState extends State<AudioEditTile> {
  late bool _selected;

  @override
  void initState() {
    _selected = widget.isAdded;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CoverWidget(photoUrl: widget.audio.album?.thumb?.photo270),
      title: Text(widget.audio.title),
      subtitle: Text(widget.audio.artist),
      enabled: _selected,
      trailing: IconButton(
        onPressed: () {
          setState(() {
            _selected = !_selected;
          });
          widget.onIconTap();
        },
        icon: const Icon(Icons.clear_rounded),
      ),
    );
  }
}
