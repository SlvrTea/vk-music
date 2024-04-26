part of 'music_loader_cubit.dart';

@immutable
abstract class MusicLoaderState {}

class MusicLoaderInitial extends MusicLoaderState {}

class MusicLoadingState extends MusicLoaderState {}

class MusicLoadedState extends MusicLoaderState {
  final List<Song> songs;

  MusicLoadedState({required this.songs});
}

class MusicLoadingFailed extends MusicLoaderState {
  final String errorMessage;

  MusicLoadingFailed({required this.errorMessage});
}
