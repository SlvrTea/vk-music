part of 'navigation_bar.dart';

class NavBarItem {
  NavBarItem({required this.icon, this.activeColor, this.inactiveColor});

  final Widget icon;
  Color? inactiveColor;
  Color? activeColor;
}

class _NavBarItem extends StatelessWidget {
  const _NavBarItem({
    required this.item,
    required this.isSelected,
    required this.navHeight,
    required this.animationDuration,
    required this.animationCurve,
    required this.iconSize,
  });

  final Curve animationCurve;
  final Duration animationDuration;
  final double iconSize;
  final bool isSelected;
  final NavBarItem item;
  final double navHeight;

  @override
  Widget build(BuildContext context) {
    final selectedColor = item.activeColor ?? Theme.of(context).bottomNavigationBarTheme.selectedItemColor;
    final unselectedColor = item.inactiveColor ?? Theme.of(context).bottomNavigationBarTheme.unselectedItemColor;
    return SizedBox(
      height: double.maxFinite,
      child: Stack(
        alignment: Alignment.center,
        children: [
          AnimatedAlign(
              alignment: isSelected ? const Alignment(0, -0.3) : Alignment.center,
              duration: animationDuration,
              child: AnimatedOpacity(
                  opacity: isSelected ? 1.0 : 1.0,
                  duration: animationDuration,
                  child: IconTheme(
                    data: IconThemeData(
                      size: iconSize,
                      color: isSelected ? selectedColor!.withAlpha(255) : unselectedColor,
                    ),
                    child: item.icon,
                  ))),
          Align(
            alignment: Alignment.bottomCenter,
            child: AnimatedOpacity(
              duration: animationDuration,
              opacity: isSelected ? 1.0 : 0.0,
              child: Container(
                width: 20,
                height: 5,
                alignment: Alignment.center,
                margin: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: selectedColor,
                  borderRadius: BorderRadius.circular(2.5),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
