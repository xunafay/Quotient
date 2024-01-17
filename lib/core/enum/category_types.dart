import 'package:hive/hive.dart';

part 'category_types.g.dart';

@HiveType(typeId: 13)
enum CategoryType {
  @HiveField(0)
  income,
  @HiveField(1)
  expense,
  @HiveField(2)
  transfer,
}
