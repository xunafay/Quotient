import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:paisa/core/common.dart';
import 'package:paisa/features/profile/business/bloc/profile_bloc.dart';
import 'package:responsive_builder/responsive_builder.dart';

class UserImageWidget extends StatelessWidget {
  const UserImageWidget({
    Key? key,
    this.onPressed,
  }) : super(key: key);

  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileBloc, ProfileState>(
      builder: (context, state) {
        if ((state is! ProfileLoadedState)) {
          return const SizedBox.shrink();
        }

        String image = state.profile.image ?? '';
        if (image == 'no-image') {
          image = '';
        }

        return ScreenTypeLayout.builder(
          mobile: (p0) => Builder(
            builder: (context) {
              if (image.isEmpty) {
                return ClipOval(
                  child: Container(
                    width: 32,
                    height: 32,
                    color: context.secondaryContainer,
                    child: Icon(
                      Icons.account_circle_outlined,
                      color: context.onSecondaryContainer,
                    ),
                  ),
                );
              } else {
                return CircleAvatar(
                  maxRadius: 16,
                  foregroundImage: FileImage(File(image)),
                );
              }
            },
          ),
          tablet: (p0) => Builder(
            builder: (context) {
              if (image.isEmpty) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ClipOval(
                    child: Container(
                      width: 42,
                      height: 42,
                      color: context.secondaryContainer,
                      child: Icon(
                        Icons.account_circle_outlined,
                        color: context.onSecondaryContainer,
                      ),
                    ),
                  ),
                );
              } else {
                return Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: CircleAvatar(
                    foregroundImage: FileImage(
                      File(image),
                    ),
                  ),
                );
              }
            },
          ),
        );
      },
    );
  }
}
