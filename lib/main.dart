import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:paisa/core/enum/box_types.dart';
import 'package:paisa/features/profile/business/bloc/profile_bloc.dart';
import 'package:paisa/features/profile/data/providers/local_profile_repository.dart';
import 'package:paisa/features/profile/data/repositories/profile_repository.dart';
import 'package:paisa/features/recurring/domain/repository/recurring_repository.dart';
import 'package:paisa/app.dart';
import 'package:paisa/dependency_injection/dependency_injection.dart';

final getIt = GetIt.instance;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await configInjector(getIt);
  getIt.get<RecurringRepository>().checkForRecurring();
  final Box<dynamic> settings =
      getIt.get<Box<dynamic>>(instanceName: BoxType.settings.name);
  runApp(
    MultiRepositoryProvider(
      providers: [
        RepositoryProvider<ProfileRepository>(
          create: (context) => LocalProfileProvider(settings),
        ),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => ProfileBloc(context.read<ProfileRepository>()),
          ),
        ],
        child: PaisaApp(settings: settings),
      ),
    ),
  );
}
