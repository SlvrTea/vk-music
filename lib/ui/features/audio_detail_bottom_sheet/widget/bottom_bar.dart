import 'package:elementary_helper/elementary_helper.dart';
import 'package:flutter/material.dart';
import 'package:vk_music/common/utils/di/scopes/app_scope.dart';

import '../../main/widget/navigation_bar/audio_buttons.dart';

class BottomBar extends StatelessWidget {
  const BottomBar({super.key, required this.activeTab});

  final EntityValueListenable<int> activeTab;

  @override
  Widget build(BuildContext context) {
    return EntityStateNotifierBuilder(
      listenableEntityState: activeTab,
      builder: (context, index) {
        return Row(
          children: [
            const ShuffleButton(),
            const Spacer(),
            Icon(
              Icons.circle,
              size: 12,
              color: index! == 0 ? context.global.theme.colors.mainTextColor : Colors.grey,
            ),
            const SizedBox(width: 4),
            Icon(
              Icons.list_rounded,
              color: index == 1 ? context.global.theme.colors.mainTextColor : Colors.grey,
            ),
            const Spacer(),
            const LoopModeButton(),
          ],
        );
      },
    );
  }
}
