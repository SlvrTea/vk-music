import 'package:auto_route/annotations.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:vk_music/common/utils/config/app_config.dart';
import 'package:vk_music/common/utils/di/scopes/app_scope.dart';

@RoutePage()
class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  late bool _isDarkMode;

  @override
  void initState() {
    final AppConfig? config = Hive.box('config').get('main');
    if (config != null) {
      _isDarkMode = config.isDarkMode;
    } else {
      _isDarkMode = SchedulerBinding.instance.platformDispatcher.platformBrightness == Brightness.light ? false : true;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final config = context.global.config;
    return Scaffold(
      appBar: AppBar(title: const Text('Настройки')),
      body: Column(
        children: [
          const Text('Тема'),
          ListTile(
            title: const Text('Светлая'),
            leading: Radio<bool>(
              groupValue: _isDarkMode,
              value: false,
              onChanged: (value) {
                if (value != _isDarkMode) {
                  final newConfig = config.copyWith(
                    isDarkMode: value,
                    accentColor: context.global.theme.accentColor.value,
                  );
                  context.global.updateConfig(newConfig);
                }
                setState(() {
                  _isDarkMode = value ?? _isDarkMode;
                });
              },
            ),
          ),
          ListTile(
            title: const Text('Тёмная'),
            leading: Radio<bool>(
                groupValue: _isDarkMode,
                value: true,
                onChanged: (value) {
                  if (value != _isDarkMode) {
                    final newConfig = config.copyWith(
                      isDarkMode: value,
                      accentColor: context.global.theme.accentColor.value,
                    );
                    context.global.updateConfig(newConfig);
                  }
                  setState(() {
                    _isDarkMode = value ?? _isDarkMode;
                  });
                }),
          ),
        ],
      ),
    );
  }
}
