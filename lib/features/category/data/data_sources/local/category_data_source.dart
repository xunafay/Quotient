import 'package:collection/collection.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:injectable/injectable.dart';
import 'package:paisa/core/common_enum.dart';
import 'package:paisa/features/category/data/model/category_model.dart';

abstract class LocalCategoryManager {
  Future<void> add(CategoryModel category);

  Future<void> delete(int key);

  List<CategoryModel> categories();

  CategoryModel? findById(int? categoryId);

  Iterable<CategoryModel> export();

  Future<void> update(CategoryModel categoryModel);

  Future<void> clear();

  List<CategoryModel> defaultCategories();
}

@Singleton(as: LocalCategoryManager)
class LocalCategoryManagerDataSourceImpl implements LocalCategoryManager {
  LocalCategoryManagerDataSourceImpl(this.categoryBox);

  final Box<CategoryModel> categoryBox;

  @override
  Future<void> add(CategoryModel category) async {
    final int id = await categoryBox.add(category);
    category.superId = id;
    return category.save();
  }

  @override
  List<CategoryModel> categories() {
    return categoryBox.values
        .where((element) => element.type != TransactionType.transfer)
        .toList();
  }

  @override
  Future<void> clear() => categoryBox.clear();

  @override
  List<CategoryModel> defaultCategories() {
    return categoryBox.values
        .where((element) => element.type != TransactionType.transfer)
        .toList();
  }

  @override
  Future<void> delete(int key) async {
    await categoryBox.delete(key);
  }

  @override
  Iterable<CategoryModel> export() => categoryBox.values;

  @override
  CategoryModel? findById(int? categoryId) =>
      categoryBox.values.firstWhereOrNull(
        (element) => element.superId == categoryId,
      );

  @override
  Future<void> update(CategoryModel categoryModel) {
    return categoryBox.put(categoryModel.superId!, categoryModel);
  }
}
