import 'package:bloc/bloc.dart';
import 'package:paisa/src/rust/api/db/db.dart';
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
      final profile = await repository.getProfile(); // TODO improve
      emit(ProfileLoadedState(
        name: profile.name ?? '',
        image: event.image,
      ));
    });

    on<ProfileUpdateEvent>((event, emit) async {
      await repository.setName(value: event.name);
      final profile = await repository.getProfile(); // TODO improve
      emit(ProfileLoadedState(
        name: event.name,
        image: profile.image ?? '',
      ));
    });

    on<ProfileLoadEvent>((event, emit) async {
      final profile = await repository.getProfile();
      emit(ProfileLoadedState(
        name: profile.name ?? '',
        image: profile.image ?? '',
      ));
    });

    // Start loading profile data
    add(ProfileLoadEvent());
  }

  final ProfileRepository repository;
}
