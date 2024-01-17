import 'package:equatable/equatable.dart';
import 'package:paisa/core/enum/category_types.dart';

class CategoryEntity extends Equatable {
  const CategoryEntity({
    this.budget,
    this.color,
    this.description,
    this.icon,
    this.name,
    this.superId,
    this.isBudget = false,
    this.type = CategoryType.expense,
  });

  final double? budget;
  final int? color;
  final String? description;
  final int? icon;
  final bool? isBudget;
  final CategoryType? type;
  final String? name;
  final int? superId;

  @override
  List<Object?> get props => [
        budget,
        color,
        description,
        icon,
        name,
        superId,
        isBudget,
        type,
      ];
}
