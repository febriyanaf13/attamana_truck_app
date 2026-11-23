import 'dart:io';

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

class FileHelper {

  /// =========================
  /// COPY IMAGE TO APP STORAGE
  /// =========================
  static Future<String>
  saveImagePermanently(
      String filePath) async {

    /// folder aplikasi
    final directory =
    await getApplicationDocumentsDirectory();

    /// extension file
    final ext =
    extension(filePath);

    /// rename file
    final fileName =
        '${DateTime.now().millisecondsSinceEpoch}$ext';

    /// lokasi baru
    final newPath =
    join(
      directory.path,
      fileName,
    );

    /// copy file
    final File imageFile =
    File(filePath);

    final File newImage =
    await imageFile.copy(
      newPath,
    );

    return newImage.path;
  }
}