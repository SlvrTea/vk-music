import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:vk_music/common/utils/di/scopes/app_scope.dart';
import 'package:vk_music/ui/widgets/common/context_menu_item.dart';

class AlbumMoreSheet extends StatelessWidget {
  const AlbumMoreSheet({super.key, required this.onEditTap, required this.onDeleteTap});

  final VoidCallback onEditTap;
  final VoidCallback onDeleteTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 1, sigmaY: 1),
        child: Container(
          decoration: BoxDecoration(
            color: context.global.theme.colors.secondaryBackground,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ContextMenuItem(
                title: const Text('Изменить'),
                leading: const Icon(Icons.edit),
                onTap: onEditTap,
              ),
              ContextMenuItem(
                title: const Text('Удалить'),
                leading: const Icon(Icons.delete_rounded),
                onTap: onDeleteTap,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
