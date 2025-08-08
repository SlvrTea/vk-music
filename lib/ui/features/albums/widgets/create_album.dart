import 'package:flutter/material.dart';
import 'package:text_marquee/text_marquee.dart';
import 'package:vk_music/common/utils/di/scopes/app_scope.dart';

class CreateAlbumWidget extends StatelessWidget {
  const CreateAlbumWidget({super.key, required this.onCreateAlbum});

  final VoidCallback onCreateAlbum;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 131,
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onCreateAlbum,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox.square(
              dimension: 115,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Container(
                  color: context.global.theme.colors.secondary,
                  child: const Icon(
                    Icons.add_rounded,
                    size: 70,
                    color: Colors.black,
                  ),
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
              child: TextMarquee(
                'Создать плейлист',
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
