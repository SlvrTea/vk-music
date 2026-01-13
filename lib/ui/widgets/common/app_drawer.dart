import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:hive_ce_flutter/hive_flutter.dart';
import 'package:vk_music/common/utils/di/scopes/app_scope.dart';
import 'package:vk_music/common/utils/router/app_router.dart';
import 'package:vk_music/data/models/user/user.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: SafeArea(
        child: Column(
          children: [
            TextButton(
              onPressed: () => context.router.push(const SettingsRoute()),
              child: const Row(
                children: [Icon(Icons.settings), Text('Настройки')],
              ),
            ),
            TextButton(
              onPressed: () async {
                final res = await showDialog<bool>(
                  context: context,
                  builder: (context) {
                    return AlertDialog.adaptive(
                      title: Text('Проверка путей'),
                      content: Text(
                        'Запустить проверку путей кеша, если какая-либо из песней в кеше не проигрывается. Данное действие удалит такие песни.',
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => context.maybePop(false),
                          child: Text('Отмена'),
                        ),
                        TextButton(
                          onPressed: () => context.maybePop(true),
                          child: Text('Продолжить'),
                        ),
                      ],
                    );
                  },
                );
                if (res != null && res && context.mounted) {
                  context.global.cacheManager.checkFilePath();
                  context.global.audioRepository
                    ..loadCachedAudio()
                    ..loadCachedPlaylist();
                }
              },
              child: const Row(
                children: [Icon(Icons.cached_rounded), Text('Проверка путей')],
              ),
            ),
            const Spacer(),
            TextButton(
              onPressed: () {
                Hive.box<User>('user').delete('user');
                context.global.audioPlayer.stop();
                context.global.audioRepository
                  ..userAudiosNotifier.value = []
                  ..userAlbumsNotifier.value = [];
                context.router.replace(const AuthRoute());
              },
              child: const Row(
                children: [
                  Icon(Icons.logout_rounded, color: Colors.red),
                  Text('Выйти', style: TextStyle(color: Colors.red)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
