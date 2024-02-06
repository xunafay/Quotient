import 'package:dartz/dartz.dart';
import 'package:image_picker/image_picker.dart';
import 'package:paisa/core/error/failures.dart';

abstract class ProfileRepository {
  Future<Either<Failure, String>> saveImage(XFile imageFile);
  Future<Either<Failure, String>> saveImagePath(String path);
  Future<Either<Failure, void>> saveName(String name);

  String get name;
  String get image;
}
