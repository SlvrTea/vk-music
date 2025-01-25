import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:vk_music/common/utils/di/scopes/app_scope.dart';
import 'package:vk_music/domain/model/player_audio.dart';
import 'package:vk_music/ui/widgets/common/media_cover.dart';

@RoutePage()
class AddAudioScreen extends StatelessWidget {
  AddAudioScreen({super.key, required this.playlistAudios});

  final List<PlayerAudio> playlistAudios;
  final List<PlayerAudio> toAdd = [];

  void onAddTap(PlayerAudio audio) {
    if (toAdd.contains(audio)) {
      toAdd.remove(audio);
      return;
    }
    toAdd.add(audio);
  }

  @override
  Widget build(BuildContext context) {
    final allAudios = context.global.audioRepository.userAudiosNotifier.value!;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Добавить музыку'),
        actions: [
          IconButton(onPressed: () => context.router.maybePop(toAdd), icon: const Icon(Icons.check_rounded)),
        ],
      ),
      body: ListView.builder(
          itemCount: allAudios.length,
          itemBuilder: (context, index) {
            return _AddAudioTile(
              audio: allAudios[index],
              isAdded: playlistAudios.map((e) => e.id).contains(allAudios[index].id),
              onTap: onAddTap,
            );
          }),
    );
  }
}

class _AddAudioTile extends StatefulWidget {
  const _AddAudioTile({super.key, required this.audio, required this.isAdded, required this.onTap});

  final PlayerAudio audio;
  final bool isAdded;
  final void Function(PlayerAudio) onTap;

  @override
  State<_AddAudioTile> createState() => _AddAudioTileState();
}

class _AddAudioTileState extends State<_AddAudioTile> {
  late bool _isSelected;

  @override
  void initState() {
    _isSelected = widget.isAdded;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CoverWidget(photoUrl: widget.audio.album?.thumb?.photo270),
      title: Text(widget.audio.title),
      subtitle: Text(widget.audio.artist),
      trailing: _isSelected ? const Icon(Icons.check_box_rounded) : const Icon(Icons.check_box_outline_blank_rounded),
      onTap: () {
        widget.onTap(widget.audio);
        setState(() {
          _isSelected = !_isSelected;
        });
      },
    );
  }
}
