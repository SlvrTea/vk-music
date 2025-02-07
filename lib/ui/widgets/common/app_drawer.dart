import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:vk_music/common/utils/di/scopes/app_scope.dart';
import 'package:vk_music/common/utils/router/app_router.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              TextButton(
                onPressed: () => context.router.push(const SettingsRoute()),
                child: const Row(
                  children: [
                    Icon(Icons.settings),
                    Text('Настройки'),
                  ],
                ),
              ),
              TextButton(
                onPressed: () {
                  Hive.box('userBox').delete('user');
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
      ),
    );
  }
}
