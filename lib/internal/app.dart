import 'package:flutter/material.dart';
import 'package:vk_music/data/vk_api/models/vk_api.dart';
import 'package:vk_music/domain/auth_bloc/auth_bloc.dart';
import 'package:vk_music/presentation/auth/login_screen.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    final VKApi vkApi = VKApi();
    final authBloc = AuthBloc(vkApi: vkApi)
      ..add(LoadUserEvent());
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthBloc>(
            create: (context) => authBloc
        )
      ],
      child: MaterialApp(
        title: 'VK Music Player',
        theme: ThemeData(
            useMaterial3: true,
            colorScheme: ColorScheme.fromSeed(
                seedColor: Colors.blue,
                brightness: Brightness.dark
            )
        ),
        home: const LoginScreen(),
      ),
    );
  }
}
