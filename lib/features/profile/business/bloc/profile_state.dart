part of 'profile_bloc.dart';

sealed class ProfileState {}

@CopyWith()
final class ProfileLoadedState extends ProfileState {
  ProfileLoadedState({
    required this.name,
    required this.image,
  });

  final String name;
  final String image;
}

final class ProfileLoadingState extends ProfileState {}

final class ProfileErrorState extends ProfileState {
  ProfileErrorState({
    required this.failure,
  });

  final String failure;
}
