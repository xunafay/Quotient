part of 'profile_bloc.dart';

sealed class ProfileEvent {}

final class ProfileLoadEvent extends ProfileEvent {}

final class ProfileUpdateEvent extends ProfileEvent {
  ProfileUpdateEvent({
    required this.name,
  });

  final String name;
}

final class ProfileImageSelectedEvent extends ProfileEvent {
  ProfileImageSelectedEvent({
    required this.image,
  });

  final XFile image;
}

final class ProfileImageUpdateEvent extends ProfileEvent {
  ProfileImageUpdateEvent({
    required this.image,
  });

  final String image;
}
