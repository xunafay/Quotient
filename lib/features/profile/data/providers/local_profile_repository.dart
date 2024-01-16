import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:image_picker/image_picker.dart';
import 'package:paisa/core/constants/constants.dart';
import 'package:paisa/core/error/failures.dart';
import 'package:paisa/features/profile/data/repositories/profile_repository.dart';
import 'package:path_provider/path_provider.dart';

class LocalProfileProvider implements ProfileRepository {
  LocalProfileProvider(
    this.settings,
  );

  final Box<dynamic> settings;

  @override
  Future<Either<Failure, String>> saveImage(XFile imageFile) async {
    final String path = await _saveImageFileToCache(imageFile);
    settings.put(userImageKey, path);
    return right(path);
  }

  @override
  String get image => settings.get(userImageKey, defaultValue: '');

  @override
  Future<Either<Failure, void>> saveName(String name) async {
    await settings.put(userNameKey, name);
    return right(null);
  }

  @override
  String get name => settings.get(userNameKey, defaultValue: '');

  Future<String> _saveImageFileToCache(XFile xFile) async {
    final Directory directory = await getTemporaryDirectory();
    final cachePath = '${directory.path}/profile_picture.jpg';
    final imageFile = File(xFile.path);
    await imageFile.copy(cachePath);
    return cachePath;
  }
}
