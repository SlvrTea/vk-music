import 'package:flutter/material.dart';

part 'navigation_bar_item.dart';

class NavBar extends StatelessWidget {
  const NavBar({
    super.key,
    required this.items,
    required this.onItemSelected,
    this.backgroundColor,
    this.selectedIndex = 0,
    this.height = 40,
    this.iconSize = 20,
    this.animationDuration = const Duration(milliseconds: 170),
    this.animationCurve = Curves.linear,
    this.shadows = const [
      BoxShadow(
        color: Colors.black12,
        blurRadius: 3,
      ),
    ],
  });

  final Curve animationCurve;
  final Duration animationDuration;
  final Color? backgroundColor;
  final double height;
  final double iconSize;
  final List<NavBarItem> items;
  final void Function(int) onItemSelected;
  final int selectedIndex;
  final List<BoxShadow> shadows;

  double iconSizeEffectCalculator(double size) => size > 30
      ? size * 1.2
      : size > 10
          ? size * 0.6
          : 0;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Container(
        width: double.infinity,
        color: backgroundColor,
        height: height + iconSizeEffectCalculator(iconSize),
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: items.map((item) {
            final index = items.indexOf(item);
            return Expanded(
              child: GestureDetector(
                onTap: () => onItemSelected(index),
                child: _NavBarItem(
                  item: item,
                  isSelected: index == selectedIndex,
                  navHeight: height,
                  animationDuration: animationDuration,
                  animationCurve: animationCurve,
                  iconSize: iconSize,
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}
