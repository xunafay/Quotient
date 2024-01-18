import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:paisa/config/routes_name.dart';
import 'package:paisa/core/common.dart';
import 'package:paisa/core/enum/transaction_type.dart';
import 'package:paisa/core/theme/custom_color.dart';
import 'package:paisa/features/category/domain/entities/category.dart';

class CategoryItemMobileWidget extends StatelessWidget {
  const CategoryItemMobileWidget({
    Key? key,
    required this.category,
  }) : super(key: key);

  final CategoryEntity category;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(8),
      onTap: () => context.pushNamed(
        RoutesName.editCategory.name,
        pathParameters: <String, String>{'cid': category.superId.toString()},
      ),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Color(category.color ?? Colors.amber.shade100.value)
              .withOpacity(0.3),
          child: Icon(
            IconData(
              category.icon ?? 0,
              fontFamily: fontFamilyName,
              fontPackage: fontFamilyPackageName,
            ),
            color: Color(category.color ?? Colors.amber.shade100.value),
          ),
        ),
        title: Text(
          category.name ?? '',
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: context.titleMedium?.copyWith(
            color: context.onSurfaceVariant,
          ),
        ),
        trailing: _trailingTypeIcon(context, category),
        subtitle: category.description == null || category.description == ''
            ? null
            : Text(
                category.description!,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: context.bodyLarge?.copyWith(
                  color: Theme.of(context)
                      .colorScheme
                      .onSurfaceVariant
                      .withOpacity(0.75),
                ),
              ),
      ),
    );
  }

  Icon? _trailingTypeIcon(BuildContext context, CategoryEntity category) {
    switch (category.type) {
      case TransactionType.income:
        return Icon(
          MdiIcons.arrowBottomLeft,
          color: Theme.of(context).extension<CustomColors>()!.green ??
              context.secondary,
        );
      case TransactionType.expense:
        return Icon(
          MdiIcons.arrowTopRight,
          color: Theme.of(context).extension<CustomColors>()!.red ??
              context.secondary,
        );
      case TransactionType.transfer:
        return Icon(
          MdiIcons.swapHorizontal,
          color: Theme.of(context).extension<CustomColors>()!.blue ??
              context.secondary,
        );
      default:
        return null;
    }
  }
}
