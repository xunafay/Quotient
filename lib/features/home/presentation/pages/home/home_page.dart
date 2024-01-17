import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:in_app_review/in_app_review.dart';
import 'package:in_app_update/in_app_update.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:paisa/core/common.dart';
import 'package:paisa/core/common_enum.dart';
import 'package:paisa/features/home/presentation/bloc/home/home_bloc.dart';
import 'package:paisa/features/home/presentation/widgets/home_desktop_widget.dart';
import 'package:paisa/features/home/presentation/widgets/home_mobile_widget.dart';
import 'package:paisa/features/home/presentation/widgets/home_tablet_widget.dart';
import 'package:paisa/features/home/presentation/widgets/variable_size_fab.dart';
import 'package:paisa/main.dart';
import 'package:paisa/core/widgets/paisa_widget.dart';
import 'package:responsive_builder/responsive_builder.dart';

final destinations = [
  Destination(
    pageType: PageType.home,
    icon: const Icon(Icons.home_outlined),
    selectedIcon: const Icon(Icons.home),
  ),
  Destination(
    pageType: PageType.accounts,
    icon: const Icon(Icons.credit_card_outlined),
    selectedIcon: const Icon(Icons.credit_card),
  ),
  Destination(
    pageType: PageType.debts,
    icon: Icon(MdiIcons.accountCashOutline),
    selectedIcon: Icon(MdiIcons.accountCash),
  ),
  Destination(
    pageType: PageType.overview,
    icon: Icon(MdiIcons.sortVariant),
    selectedIcon: Icon(MdiIcons.sortVariant),
  ),
  Destination(
    pageType: PageType.category,
    icon: const Icon(Icons.category_outlined),
    selectedIcon: const Icon(Icons.category),
  ),
  Destination(
    pageType: PageType.budget,
    icon: Icon(MdiIcons.timetable),
    selectedIcon: Icon(MdiIcons.timetable),
  ),
  // TODO #21
  // Destination(
  //   pageType: PageType.recurring,
  //   icon: Icon(MdiIcons.cashSync),
  //   selectedIcon: Icon(MdiIcons.cashSync),
  // ),
];

class LandingPage extends StatelessWidget {
  const LandingPage({
    Key? key,
  }) : super(key: key);

  Future<void> _checkInApp(BuildContext context) async {
    final AppUpdateInfo updateInfo = await InAppUpdate.checkForUpdate();
    if (updateInfo.immediateUpdateAllowed) {
      final AppUpdateResult result = await InAppUpdate.performImmediateUpdate();
      if (context.mounted) {
        if (result == AppUpdateResult.inAppUpdateFailed) {
          context.showMaterialSnackBar('Update failed');
        } else if (result == AppUpdateResult.success) {
          context.showMaterialSnackBar('Update success');
        }
      }
    }
  }

  Future<void> _checkInAppReview() async {
    final isAvailable = await InAppReview.instance.isAvailable();
    if (isAvailable) {
      InAppReview.instance.requestReview();
    }
  }

  @override
  Widget build(BuildContext context) {
    final HomeBloc homeBloc = BlocProvider.of<HomeBloc>(context);

    final actionButton =
        HomeFloatingActionButtonWidget(summaryController: getIt.get());
    return PaisaAnnotatedRegionWidget(
      child: BlocProvider(
        create: (context) => homeBloc,
        child: WillPopScope(
          onWillPop: () async {
            if (homeBloc.selectedIndex == 0) {
              return true;
            }
            homeBloc.add(const CurrentIndexEvent(0));
            return false;
          },
          child: ScreenTypeLayout.builder(
            mobile: (p0) => HomeMobileWidget(
              floatingActionButton: actionButton,
              destinations: destinations,
            ),
            tablet: (p0) => HomeTabletWidget(
              floatingActionButton: actionButton,
              destinations: destinations,
            ),
            desktop: (p0) => HomeDesktopWidget(
              floatingActionButton: actionButton,
              destinations: destinations,
            ),
          ),
        ),
      ),
    );
  }
}

class Destination {
  Destination({
    required this.pageType,
    required this.icon,
    required this.selectedIcon,
  });

  final Icon icon;
  final PageType pageType;
  final Icon selectedIcon;
}
