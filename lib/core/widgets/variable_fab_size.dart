import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';

import 'package:paisa/core/common.dart';
import 'package:provider/provider.dart';
import 'package:responsive_builder/responsive_builder.dart';

class VariableFABSize extends StatelessWidget {
  const VariableFABSize({
    super.key,
    required this.onPressed,
    required this.icon,
    required this.tooltip,
  });

  final IconData icon;
  final VoidCallback onPressed;

  /// Tooltip for FAB, required for accessibility reasons
  final String tooltip;

  @override
  Widget build(BuildContext context) {
    return ScreenTypeLayout.builder(
      tablet: (context) {
        return FloatingActionButton(
          onPressed: onPressed,
          tooltip: tooltip,
          child: Icon(icon),
        );
      },
      mobile: (context) {
        return ValueListenableBuilder<Box<dynamic>>(
          valueListenable: Provider.of<Box<dynamic>>(context).listenable(
            keys: [smallSizeFabKey],
          ),
          builder: (context, value, child) {
            final isSmallSize = value.get(smallSizeFabKey, defaultValue: false);
            if (isSmallSize) {
              return FloatingActionButton(
                backgroundColor: context.secondaryContainer,
                onPressed: onPressed,
                tooltip: tooltip,
                child: Icon(
                  icon,
                  color: context.onSecondaryContainer,
                ),
              );
            } else {
              return FloatingActionButton.large(
                backgroundColor: context.secondaryContainer,
                onPressed: onPressed,
                tooltip: tooltip,
                child: Icon(
                  icon,
                  color: context.onSecondaryContainer,
                ),
              );
            }
          },
        );
      },
    );
  }
}
