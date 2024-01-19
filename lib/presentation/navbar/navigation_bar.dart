
import 'package:flutter/material.dart';
part 'navigation_bar_item.dart';

class NavBar extends StatelessWidget {
  const NavBar({
    super.key,
    this.selectedIndex = 0,
    this.height = 60,
    this.iconSize = 20,
    this.backgroundColor,
    this.animationDuration = const Duration(milliseconds: 170),
    this.animationCurve = Curves.linear,
    this.shadows = const [
      BoxShadow(
        color: Colors.black12,
        blurRadius: 3,
      ),
    ],
    required this.items,
    required this.onItemSelected,
  });

  final Curve animationCurve;
  final Duration animationDuration;
  final Color? backgroundColor;
  final double height;
  final double iconSize;
  final List<NavBarItem> items;
  final ValueChanged<int> onItemSelected;
  final int selectedIndex;
  final List<BoxShadow> shadows;

  double iconSizeEffectCalculator(double size) => size > 30
      ? size * 1.2
      : size > 10
      ? size * .6
      : 0;

@override
  Widget build(BuildContext context) {
    final background = backgroundColor
        ?? Theme.of(context).bottomNavigationBarTheme.backgroundColor;
    return Container(
      decoration: BoxDecoration(
        color: background,
        boxShadow: shadows,
        borderRadius: const BorderRadius.only(topLeft: Radius.circular(16), topRight: Radius.circular(16))
      ),
      child: SafeArea(
        child: Container(
          width: double.infinity,
          height: height + iconSizeEffectCalculator(iconSize),
          padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: items.map((item) {
              var index = items.indexOf(item);
              return Expanded(
                  child: GestureDetector(
                    onTap: () => onItemSelected(index),
                    child: _NavBarItem(
                        item: item,
                        isSelected: index == selectedIndex,
                        navHeight: height,
                        backgroundColor: background!,
                        animationDuration: animationDuration,
                        animationCurve: animationCurve,
                        iconSize: iconSize
                    ),
                  )
              );
            }).toList(),
          ),
        ),
      ),
    );
  }
}
