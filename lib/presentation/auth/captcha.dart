
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/state/auth/auth_bloc.dart';
import '../home_screen/home.dart';

class Capcha extends StatefulWidget {
  const Capcha ({super.key, required this.capchaUrl, required this.capchaSId, required this.query});
  final String capchaUrl;
  final String capchaSId;
  final Map<String, dynamic> query;

  @override
  State<Capcha> createState() => _CapchaState();
}

class _CapchaState extends State<Capcha> {
  late TextEditingController textEdit;
  @override
  void initState() {
    textEdit = TextEditingController();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Capcha')),
      body: Center(
        child: Column(
          children: [
            CachedNetworkImage(imageUrl: widget.capchaUrl),
            TextField(
              controller: textEdit,
              onChanged: (value) => setState(() {}),
            ),
            _CaptchaButton(query: widget.query, captchaSid: widget.capchaSId, captchaKey: textEdit.text)
          ],
        ),
      ),
    );
  }
}


class _CaptchaButton extends StatelessWidget {
  const _CaptchaButton({super.key, required this.query, required this.captchaSid, required this.captchaKey});
  final Map<String, dynamic> query;
  final String captchaSid;
  final String captchaKey;

  @override
  Widget build(BuildContext context) {
    snackBar(errorMessage) => SnackBar(
      content: Text(errorMessage),
      duration: const Duration(seconds: 3),
      action: SnackBarAction(
        label: 'Закрыть',
        onPressed: () {},
      ),
    );
    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthFailed) {
          ScaffoldMessenger.of(context).showSnackBar(snackBar(state.errorMessage));
        } else if (state is UserLoadedState) {
          Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (_) => const Home())
          );
        }
      },
      builder: (context, state) {
        return ElevatedButton(
            onPressed: () {
              context.read<AuthBloc>().add(
                  UserLoginCaptchaEvent(query, captchaSid: captchaSid, captchaKey: captchaKey)
              );
            },
            child: state is AuthFailed || state is AuthInitial
                ? const Text('Войти', style: TextStyle(fontSize: 18))
                : const Center(child: CircularProgressIndicator())
        );
      },
    );
  }
}
