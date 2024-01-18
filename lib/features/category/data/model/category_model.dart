import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:paisa/core/enum/transaction_type.dart';

part 'category_model.g.dart';
part 'category_model.freezed.dart';

@unfreezed
class CategoryModel extends HiveObject with _$CategoryModel {
  @HiveType(typeId: 1, adapterName: 'CategoryModelAdapter')
  factory CategoryModel({
    @HiveField(0) String? name,
    @HiveField(1) String? description,
    @HiveField(2) int? icon,
    // @Default(false) @HiveField(3, defaultValue: false) bool? isDefault,
    @HiveField(4, defaultValue: 0) int? superId,
    @HiveField(6, defaultValue: 0) double? budget,
    @HiveField(7, defaultValue: false) bool? isBudget,
    @HiveField(8, defaultValue: 0xFFFFC107) int? color,
    @Default(TransactionType.expense)
    @HiveField(9, defaultValue: TransactionType.expense)
    TransactionType? type,
  }) = _CategoryModel;

  CategoryModel._();

  factory CategoryModel.fromJson(Map<String, dynamic> json) =>
      _$CategoryModelFromJson(json);
}
