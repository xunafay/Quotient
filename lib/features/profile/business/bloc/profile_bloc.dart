import 'package:bloc/bloc.dart';
import 'package:paisa/features/profile/data/repositories/profile_repository.dart';
import 'package:share_plus/share_plus.dart';
import 'package:copy_with_extension/copy_with_extension.dart';

part 'profile_event.dart';
part 'profile_state.dart';

part 'profile_bloc.g.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  ProfileBloc(
    this.repository,
  ) : super(ProfileLoadingState()) {
    on<ProfileUpdateEvent>((event, emit) {
      repository.saveName(event.name);
    });

    on<ProfileImageSelectedEvent>((event, emit) async {
      final result = await repository.saveImage(event.image);
      result.fold((failure) {
        emit(ProfileErrorState(failure: failure.toString()));
      }, (image) {
        emit(ProfileLoadedState(
          name: repository.name,
          image: image,
        ));
      });
    });

    on<ProfileUpdateEvent>((event, emit) async {
      await repository.saveName(event.name);
      emit(ProfileLoadedState(
        name: event.name,
        image: repository.image,
      ));
    });

    on<ProfileLoadEvent>((event, emit) {
      emit(ProfileLoadedState(
        name: repository.name,
        image: repository.image,
      ));
    });

    // Start loading profile data
    add(ProfileLoadEvent());
  }

  final ProfileRepository repository;
}
