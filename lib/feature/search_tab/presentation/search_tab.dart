
import 'package:flutter/material.dart';
import 'package:vk_music/feature/search_tab/presentation/widget/body.dart';

import '../../../core/presentation/scaffold_with_navbar.dart';

class SearchTab extends StatelessWidget {
  const SearchTab({super.key});

  @override
  Widget build(BuildContext context) {
    return ScaffoldWithNavigationBar(
        appBar: AppBar(title: const Text('VKMusic')),
        child: const SearchTabBody()
    );
  }
}
