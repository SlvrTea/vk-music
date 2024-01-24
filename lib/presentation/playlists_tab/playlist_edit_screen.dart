
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vk_music/domain/const.dart';
import 'package:vk_music/domain/state/playlist/playlist_cubit.dart';
import 'package:vk_music/presentation/cover.dart';

import '../../data/vk_api/models/song.dart';

class PlaylistEdit extends StatefulWidget {
  const PlaylistEdit({super.key});

  @override
  State<PlaylistEdit> createState() => _PlaylistEditState();
}

class _PlaylistEditState extends State<PlaylistEdit> {
  late final TextEditingController _titleController;
  late final TextEditingController _descriptionController;
  String? newTitle;
  String? newDescription;
  final List<List> _reorder = [];

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController();
    _descriptionController = TextEditingController();
  }

  void handleReorder(Song song, int newIndex) {
    _reorder.removeWhere((element) => _reorder[_reorder.indexOf(element)].contains(element[1]));
    _reorder.add([song.ownerId, song.shortId, newIndex]);
  }

  @override
  Widget build(BuildContext context) {
    final cubit = context.watch<PlaylistCubit>();
    final state = cubit.state;
    if (state is PlaylistLoadedState) {
      return Scaffold(
        appBar: AppBar(
          title: Text(state.playlist.title),
          actions: [
            IconButton(
              onPressed: () {
                cubit.savePlaylist(
                  playlist: state.playlist,
                  title: newTitle,
                  description: newDescription,
                  reorder: _reorder
                );
                navigatorKey.currentState!.pop();
              },
              icon: const Icon(Icons.check)
            )
          ],
        ),
        body: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            SliverList(
              delegate: SliverChildListDelegate(
                [
                  Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 16, left: 16),
                        child: CoverWidget(photoUrl: state.playlist.photoUrl300, size: 120),
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                          child: TextField(
                              onChanged: (value) => setState(() => newTitle = value),
                              controller: _titleController,
                              decoration: InputDecoration(
                                  hintText: 'Название',
                                  label: Text(state.playlist.title)
                              ).applyDefaults(_inputDecoration)
                          ),
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextField(
                      controller: _descriptionController,
                      onChanged: (value) => setState(() => newDescription = value),
                      decoration: InputDecoration(
                          hintText: 'Описание',
                          label: (state.playlist.description == null) ? null : Text(state.playlist.description!)
                      ).applyDefaults(_inputDecoration),
                    ),
                  ),
                  ListTile(
                    titleTextStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                    title: const Text('Добавить музыку'),
                    leading: Container(
                      width: 55,
                      height: 55,
                      decoration: BoxDecoration(
                          color: Colors.grey.withOpacity(0.3),
                          borderRadius: BorderRadius.circular(8)
                      ),
                      child: const Icon(Icons.add_rounded, size: 40),
                    ),
                  ),
                ]
              )
            ),
            SliverReorderableList(
              itemBuilder: (context, index) {
                return Material(
                  key: ValueKey(index),
                  child: ReorderableDelayedDragStartListener(
                    index: index,
                    child: ListTile(
                      leading: CoverWidget(photoUrl: state.songs[index].photoUrl135),
                      titleTextStyle: const TextStyle(fontWeight: FontWeight.bold),
                      title: Text(state.songs[index].title, maxLines: 1, overflow: TextOverflow.ellipsis),
                      subtitle: Text(state.songs[index].artist, maxLines: 1, overflow: TextOverflow.ellipsis),
                      onTap: () {},
                      trailing: IconButton(
                          onPressed: () => cubit.deleteFromPlaylist(playlist: state.playlist, songsToDelete: [state.songs[index]], allPlaylistSongs: state.songs),
                          icon: const Icon(Icons.highlight_remove_rounded)
                      ),
                    ),
                  ),
                );
              },
              itemCount: state.songs.length,
              onReorder: (oldIndex, newIndex) {
                if (oldIndex < newIndex) {
                  newIndex -= 1;
                }
                final item = state.songs.removeAt(oldIndex);
                state.songs.insert(newIndex, item);
                handleReorder(item, newIndex);
              }
            )
          ]
        ),
      );
    }
    return const CircularProgressIndicator();
  }
}

final _inputDecoration = InputDecorationTheme(
  focusedBorder: OutlineInputBorder(
      borderSide: const BorderSide(color: Colors.white, width: 2.0),
      borderRadius: BorderRadius.circular(16)),
  enabledBorder: OutlineInputBorder(
      borderSide: const BorderSide(color: Colors.white, width: 2.0),
      borderRadius: BorderRadius.circular(16)),
);