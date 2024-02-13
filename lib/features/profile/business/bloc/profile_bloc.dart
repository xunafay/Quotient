import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:paisa/src/rust/api/db/profile.dart';
import 'package:share_plus/share_plus.dart';
import 'package:copy_with_extension/copy_with_extension.dart';

part 'profile_event.dart';
part 'profile_state.dart';

part 'profile_bloc.g.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  ProfileBloc(
    this.repository,
  ) : super(ProfileLoadingState()) {
    on<ProfileImageSelectedEvent>((event, emit) async {
      throw UnimplementedError();
      // final result = await repository.saveImage(event.image);
      // result.fold((failure) {
      //   emit(ProfileErrorState(failure: failure.toString()));
      // }, (image) {
      //   emit(ProfileLoadedState(
      //     name: repository.name,
      //     image: image,
      //   ));
      // });
    });

    on<ProfileImageUpdateEvent>((event, emit) async {
      await repository.setImage(value: event.image);
      emit(ProfileLoadedState(
        profile: Profile(
          image: event.image,
          name: (state as ProfileLoadedState).profile.name,
        ),
      ));
    });

    on<ProfileUpdateNameEvent>((event, emit) async {
      await repository.setName(value: event.name);
      emit(ProfileLoadedState(
        profile: Profile(
          image: (state as ProfileLoadedState).profile.image,
          name: event.name,
        ),
      ));
    });

    on<ProfileChangedEvent>((event, emit) async {
      emit(ProfileLoadedState(profile: event.profile));
    });

    on<ProfileErroredEvent>((event, emit) async {
      emit(ProfileErrorState(failure: event.failure));
    });

    (() async {
      debugPrint("initializing profile");
      add(ProfileChangedEvent(profile: await repository.getProfile()));
    })();
  }

  final ProfileRepository repository;
}
