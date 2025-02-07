import 'package:elementary/elementary.dart';
import 'package:flutter/material.dart';
import 'package:vk_music/common/utils/di/scopes/app_scope.dart';
import 'package:vk_music/ui/theme/app_theme.dart';

extension ElementaryWMExtension on WidgetModel {
  // ignore: invalid_use_of_protected_member, invalid_use_of_visible_for_testing_member
  AppTheme get wmTheme => context.global.theme;

  // ignore: invalid_use_of_protected_member, invalid_use_of_visible_for_testing_member
  MediaQueryData get wmMediaQuery => MediaQuery.of(context);
}
