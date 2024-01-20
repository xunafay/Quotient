import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:paisa/core/constants/constants.dart';
import 'package:paisa/core/extensions/build_context_extension.dart';
import 'package:paisa/features/settings/domain/use_case/settings_use_case.dart';
import 'package:paisa/main.dart';

class BudgetRollOverWidget extends StatefulWidget {
  const BudgetRollOverWidget({super.key});

  @override
  State<BudgetRollOverWidget> createState() => _BudgetRollOverWidgetState();
}

class _BudgetRollOverWidgetState extends State<BudgetRollOverWidget> {
  final SettingsUseCase settingsUseCase = getIt.get();
  late bool isSelected =
      settingsUseCase.get(userBudgetRollOverKey, defaultValue: false);

  @override
  Widget build(BuildContext context) {
    return SwitchListTile(
      secondary: Icon(MdiIcons.autorenew),
      title: Text(context.loc.budgetRollover),
      subtitle: Text(context.loc.budgetRolloverDesc),
      onChanged: (bool value) async {
        setState(() {
          isSelected = value;
        });
        settingsUseCase.put(userBudgetRollOverKey, value);
      },
      value: isSelected,
    );
  }
}
