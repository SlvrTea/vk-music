
import 'package:flutter/material.dart';
import 'package:vk_music/feature/artist_tab/presentation/widget/body.dart';

class ArtistTab extends StatelessWidget {
  const ArtistTab(this.artistId, {super.key});

  final String artistId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(child: ArtistTabBody(artistId)),
    );
  }
}
