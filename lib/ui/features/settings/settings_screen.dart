import 'package:auto_route/annotations.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
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
  late bool _isSystem;

  @override
  void initState() {
    final AppConfig? config = Hive.box('config').get('main');
    _isSystem = config?.isSystem ?? true;
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
          Text('Тема', style: context.global.theme.t1),
          RadioListTile(
            title: const Text('Светлая'),
            groupValue: _isDarkMode,
            value: false,
            onChanged: (value) {
              if (value != _isDarkMode) {
                final newConfig = config.copyWith(
                  isDarkMode: value,
                  accentColor: context.global.theme.accentColor,
                );
                context.global.updateConfig(newConfig);
              }
              setState(() {
                _isDarkMode = value ?? _isDarkMode;
              });
            },
          ),
          RadioListTile(
            title: const Text('Тёмная'),
            groupValue: _isDarkMode,
            value: true,
            onChanged: (value) {
              if (value != _isDarkMode) {
                final newConfig = config.copyWith(
                  isDarkMode: value,
                  accentColor: context.global.theme.accentColor,
                );
                context.global.updateConfig(newConfig);
              }
              setState(() {
                _isDarkMode = value ?? _isDarkMode;
              });
            },
          ),
          Text('Акцентный цвет', style: context.global.theme.t1),
          RadioListTile(
            title: const Text('Системный'),
            value: true,
            groupValue: _isSystem,
            onChanged: (value) {
              setState(() {
                _isSystem = value ?? _isSystem;
              });
              final newConfig = config.copyWith(
                accentColor: context.global.systemColor,
                isDarkMode: _isDarkMode,
                isSystem: true,
              );
              context.global.updateConfig(newConfig);
            },
          ),
          RadioListTile(
            title: const Text('Свой'),
            value: false,
            groupValue: _isSystem,
            onChanged: (value) {
              setState(() {
                _isSystem = value ?? _isSystem;
              });
            },
            secondary: _isSystem
                ? null
                : Container(
                    color: config.accentColor == null ? context.global.systemColor : config.accentColor!,
                    height: 25,
                    width: 25,
                    child: GestureDetector(
                      onTap: () => showDialog(
                        context: context,
                        useRootNavigator: true,
                        builder: (context) => AlertDialog(
                          content: MaterialPicker(
                            pickerColor: config.accentColor == null ? context.global.systemColor : config.accentColor!,
                            onColorChanged: (color) {
                              context.global.updateConfig(config.copyWith(
                                accentColor: color,
                                isDarkMode: _isDarkMode,
                                isSystem: false,
                              ));
                            },
                          ),
                        ),
                      ),
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}
