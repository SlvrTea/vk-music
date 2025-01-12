import 'package:auto_route/auto_route.dart';
import 'package:elementary/elementary.dart';
import 'package:flutter/material.dart';
import 'package:vk_music/ui/features/album/widget/edit_playlist_screen.dart';

import 'edit_playlist_model.dart';

abstract interface class IEditPlaylistWidgetModel implements IWidgetModel {
  TextEditingController get titleController;

  TextEditingController get descriptionController;

  void navigateBack();

  void saveChanges();
}

EditPlaylistWidgetModel defaultEditPlaylistWidgetModelFactory(BuildContext context) =>
    EditPlaylistWidgetModel(EditPlaylistModel());

class EditPlaylistWidgetModel extends WidgetModel<EditPlaylistScreen, IEditPlaylistModel>
    implements IEditPlaylistWidgetModel {
  EditPlaylistWidgetModel(super.model);

  final _titleController = TextEditingController();

  final _descriptionController = TextEditingController();

  @override
  TextEditingController get titleController => _titleController;

  @override
  TextEditingController get descriptionController => _descriptionController;

  @override
  void initWidgetModel() {
    _titleController.text = widget.playlist.title;
    _descriptionController.text = widget.playlist.description;
    super.initWidgetModel();
  }

  @override
  void navigateBack() => context.router.maybePop();

  @override
  void saveChanges() {}
}
