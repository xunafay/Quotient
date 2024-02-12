import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:paisa/config/routes.dart';
import 'package:paisa/core/common.dart';
import 'package:paisa/core/widgets/paisa_widget.dart';
import 'package:paisa/features/intro/presentation/cubit/country_picker_cubit.dart';
import 'package:paisa/features/intro/presentation/widgets/intro_account_add_widget.dart';
import 'package:paisa/features/intro/presentation/widgets/intro_category_add_widget.dart';
import 'package:paisa/features/intro/presentation/widgets/intro_country_picker_widget.dart';
import 'package:paisa/features/intro/presentation/widgets/intro_set_name_widget.dart';
import 'package:paisa/features/intro/presentation/widgets/intro_image_picker_widget.dart';
import 'package:paisa/features/profile/business/bloc/profile_bloc.dart';
import 'package:paisa/main.dart';
import 'package:provider/provider.dart';

class UserOnboardingPage extends StatefulWidget {
  const UserOnboardingPage({
    super.key,
    this.forceCountrySelector = false,
  });
  final bool forceCountrySelector;

  @override
  State<UserOnboardingPage> createState() => _UserOnboardingPageState();
}

class _UserOnboardingPageState extends State<UserOnboardingPage> {
  final GlobalKey<FormState> _formState = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final CountryPickerCubit countryPickerCubit = getIt.get<CountryPickerCubit>();
  int currentIndex = 0;

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero).then((value) {
      if (widget.forceCountrySelector) {
        changePage(4);
      }
    });
  }

  Future<void> saveCategoryAndNavigate() async {
    await settings.put(userCategorySelectorKey, false);
    if (mounted) {
      changePage(4);
    }
  }

  Future<void> saveAccountAndNavigate() async {
    await settings.put(userAccountSelectorKey, false);
    if (mounted) {
      changePage(3);
    }
  }

  Future<void> saveImage() async {
    // context
    //   .read<ProfileBloc>()
    //   .add(ProfileImageUpdateEvent(image: ''));
    changePage(2);
  }

  void saveName(BuildContext context) {
    if (_formState.currentState!.validate()) {
      context
          .read<ProfileBloc>()
          .add(ProfileUpdateNameEvent(name: _nameController.text));
      changePage(1);
    }
  }

  @override
  Widget build(BuildContext context) {
    return PaisaAnnotatedRegionWidget(
      color: context.background,
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        bottomNavigationBar: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Visibility(
                  visible: currentIndex != 0,
                  child: FloatingActionButton.extended(
                    heroTag: 'backButton',
                    onPressed: () {
                      if (currentIndex == 0) {
                        changePage(0);
                      } else {
                        changePage(--currentIndex);
                      }
                    },
                    extendedPadding: const EdgeInsets.symmetric(horizontal: 24),
                    label: Text(
                      context.loc.back,
                      style: context.bodyLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1,
                      ),
                    ),
                    icon: Icon(MdiIcons.arrowLeft),
                  ),
                ),
                const Spacer(),
                FloatingActionButton.extended(
                  heroTag: 'next',
                  onPressed: () {
                    if (currentIndex == 0) {
                      saveName(context);
                    } else if (currentIndex == 1) {
                      saveImage();
                    } else if (currentIndex == 2) {
                      saveAccountAndNavigate();
                    } else if (currentIndex == 3) {
                      saveCategoryAndNavigate();
                    } else if (currentIndex == 4) {
                      countryPickerCubit.saveCountry();
                    }
                  },
                  extendedPadding: const EdgeInsets.symmetric(horizontal: 24),
                  label: Icon(MdiIcons.arrowRight),
                  icon: Text(
                    currentIndex == 4 ? context.loc.done : context.loc.next,
                    style: context.bodyLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        body: IndexedStack(
          index: currentIndex,
          children: [
            Center(
              child: IntroSetNameWidget(
                formState: _formState,
                nameController: _nameController,
              ),
            ),
            const IntroImagePickerWidget(),
            const IntroAccountAddWidget(),
            const IntroCategoryAddWidget(),
            IntroCountryPickerWidget(
              forceCountrySelector: widget.forceCountrySelector,
              countryCubit: countryPickerCubit,
            ),
          ],
        ),
      ),
    );
  }

  void changePage(int index) {
    setState(() {
      currentIndex = index;
    });
  }
}
