import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:vk_music/common/utils/di/scopes/app_scope.dart';

@RoutePage()
class TfaScreen extends StatefulWidget {
  const TfaScreen({
    super.key,
    required this.sid,
    required this.token,
    required this.onAcceptTap,
  });

  final String sid;
  final String token;
  final Future<String> Function(String) onAcceptTap;

  @override
  State<TfaScreen> createState() => _TfaScreenState();
}

class _TfaScreenState extends State<TfaScreen> {
  late final TextEditingController controller;

  @override
  void initState() {
    controller = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Center(
                  child: Text('Введите код', style: context.global.theme.h3),
                ),
                Center(
                  child: Text(
                    'Код создаётся в приложении для генерации кодов',
                    textAlign: TextAlign.center,
                    style: context.global.theme.b2.copyWith(
                      color: context.global.theme.colors.secondaryTextColor,
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                TextField(
                  controller: controller,
                  decoration: InputDecoration(hintText: 'Код'),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadiusGeometry.circular(8),
                    ),
                  ),
                  onPressed: () async {
                    final res = await widget.onAcceptTap(controller.text);
                    if (context.mounted) context.maybePop(res);
                  },
                  child: Text('Продолжить'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
