
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../home_screen/presentation/home.dart';
import '../../domain/state/auth_bloc.dart';

class AuthButton extends StatelessWidget {
  final String login;
  final String password;
  const AuthButton({super.key, required this.login, required this.password});

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
              MaterialPageRoute(builder: (_) => const HomeTab())
          );
        }
      },
      builder: (context, state) {
        return ElevatedButton(
            onPressed: () {
              context.read<AuthBloc>().add(AuthUserEvent(
                login: login,
                password: password
              ));
            },
            child: state is UserLoadingState
                ? const Center(child: CircularProgressIndicator())
                : const Text('Войти', style: TextStyle(fontSize: 18))
        );
      },
    );
  }
}
