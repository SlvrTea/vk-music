import 'package:just_audio/just_audio.dart';

class CustomShuffleOrder extends DefaultShuffleOrder {
  static (int, int)? pendingMove;

  @override
  void shuffle({int? initialIndex}) {
    if (pendingMove != null) {
      indices.insert(pendingMove!.$1, pendingMove!.$2);
      pendingMove = null;
      return;
    }
    super.shuffle(initialIndex: initialIndex);
  }
}
