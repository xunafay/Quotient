import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:hive_flutter/adapters.dart';
import 'package:paisa/core/common_enum.dart';
import 'package:paisa/features/profile/business/bloc/profile_bloc.dart';
import 'package:paisa/main.dart';

import 'package:paisa/core/common.dart';

class WelcomeNameWidget extends StatelessWidget {
  const WelcomeNameWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileBloc, ProfileState>(
      bloc: context.read<ProfileBloc>(),
      builder: (context, state) {
        if (state is ProfileLoadedState) {
          return ListTile(
            title: Text(
              state.profile.name ?? '',
              style: context.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: context.onBackground,
              ),
            ),
            subtitle: Text(
              context.loc.welcomeMessage,
              style: Theme.of(context)
                  .textTheme
                  .labelMedium
                  ?.copyWith(color: context.bodySmall?.color),
            ),
          );
        } else {
          return const SizedBox.shrink();
        }
      },
    );
  }
}
