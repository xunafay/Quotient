import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

import 'package:paisa/core/common.dart';
import 'package:paisa/features/profile/business/bloc/profile_bloc.dart';
import 'package:paisa/core/widgets/paisa_widget.dart';

class UserProfileBottomSheetWidget extends StatelessWidget {
  const UserProfileBottomSheetWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final TextEditingController controller = TextEditingController();
    final state = context.read<ProfileBloc>().state;
    var name = '';
    if (state is ProfileLoadedState) {
      name = state.name;
    }

    controller.text = name;
    controller.selection = TextSelection.collapsed(offset: name.length);

    return BlocListener<ProfileBloc, ProfileState>(
      listener: (context, state) {
        if (state is ProfileErrorState) {
          Navigator.pop(context);
          context.showMaterialSnackBar(state.failure);
        }
      },
      child: Padding(
        padding: MediaQuery.of(context).viewInsets,
        child: SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              ListTile(
                title: Text(
                  context.loc.profile,
                  style: context.titleLarge,
                ),
              ),
              Row(
                children: [
                  const SizedBox(width: 16),
                  PaisaUserImageWidget(pickImage: () async {
                    final ImagePicker picker = ImagePicker();
                    final file =
                        await picker.pickImage(source: ImageSource.gallery);
                    if (file != null) {
                      if (!context.mounted) return;
                      context.read<ProfileBloc>().add(
                            ProfileImageUpdateEvent(image: file.path),
                          );
                    }
                  }),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: PaisaTextFormField(
                        controller: controller,
                        hintText: 'Enter name',
                        keyboardType: TextInputType.name,
                        onChanged: (value) {},
                      ),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: TextButton(
                  style: TextButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 12,
                    ),
                  ),
                  onPressed: () => context.read<ProfileBloc>().add(
                        ProfileUpdateEvent(name: controller.text),
                      ),
                  child: Text(context.loc.update),
                ),
              ),
              const SizedBox(height: 10)
            ],
          ),
        ),
      ),
    );
  }
}
