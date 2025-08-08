import 'package:flutter/material.dart';

class ContextMenuItem extends StatelessWidget {
  const ContextMenuItem({
    super.key,
    required this.title,
    required this.leading,
    this.iconColor,
    required this.onTap,
  });

  final Widget title;
  final Widget leading;
  final Color? iconColor;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      iconColor: iconColor ?? Theme.of(context).colorScheme.primary,
      leading: leading,
      title: title,
      onTap: onTap,
    );
  }
}
