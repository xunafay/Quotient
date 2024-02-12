part of 'profile_bloc.dart';

sealed class ProfileEvent {}

final class ProfileChangedEvent extends ProfileEvent {
  ProfileChangedEvent({
    required this.profile,
  });

  final Profile profile;
}

final class ProfileUpdateNameEvent extends ProfileEvent {
  ProfileUpdateNameEvent({
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

final class ProfileErroredEvent extends ProfileEvent {
  final String failure;

  ProfileErroredEvent({required this.failure});
}
