import 'dart:ui';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:vk_music/common/utils/di/scopes/app_scope.dart';

class CustomAppBar extends StatelessWidget {
  const CustomAppBar({super.key, this.actions});

  final List<Widget>? actions;

  @override
  Widget build(BuildContext context) {
    return ClipRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaY: 20, sigmaX: 20),
        child: AppBar(
          backgroundColor: context.global.theme.colors.backgroundColor.withAlpha(128),
          actions: actions,
          title: Text(
            'VKMusic',
            style: context.global.theme.h3.copyWith(fontWeight: FontWeight.normal),
          ),
          leading: context.router.canPop()
              ? IconButton(onPressed: context.router.maybePop, icon: const Icon(Icons.arrow_back_ios_rounded))
              : null,
        ),
      ),
    );
  }
}
